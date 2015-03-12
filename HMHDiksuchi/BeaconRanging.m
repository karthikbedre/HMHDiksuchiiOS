//
//  BeaconRanging.m
//  HMHDiksuchi
//
//  Created by Bedre, Karthik on 3/12/15.
//  Copyright (c) 2015 Hughton Mifflin Harcourt. All rights reserved.
//

#import "BeaconRanging.h"

@interface BeaconRanging()<CBCentralManagerDelegate>

@property (nonatomic) int rangeInterval;
@property (nonatomic) BOOL checkRangingAvailability;
@property (nonatomic, strong) NSTimer *rangingTimer ;
@property (nonatomic, strong) NSTimer *timer_checkRangingAvailability ;
@property (nonatomic) BOOL rangingActive;
@property (nonatomic) BOOL rangingStarted;
@property (nonatomic,strong)   NSMutableArray *uuidArray;
@property(nonatomic,strong)CBCentralManager *cbBluetoothRanging;
@property(nonatomic, strong) NSArray    *proximityType;

@end

@implementation BeaconRanging
-(id)init{
    if(self){
    }
    return self;
}

-(void)startMonitoringWithProximityTypes:(NSArray *)proximityTypes{
    self.proximityType=[NSArray arrayWithArray:proximityTypes];
    [self startRanging:[NSArray arrayWithObject:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]];
}

- (void)startRanging:(NSArray *)uuidStringArray{
    
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]){
        //notify the delegate with error message
        if(self.rangeBeaconDelegate && [self.rangeBeaconDelegate respondsToSelector:@selector(rangingFailedWithError:)])
            [self.rangeBeaconDelegate rangingFailedWithError:@"This device doesnot support iBeacon"];
    }
    
    self.rangeInterval = 1.0f;
    self.checkRangingAvailability=NO;
    self.rangingStarted = NO;
    
    self.beacons = [[NSMutableDictionary alloc] init];
    self.locationManager = [[CLLocationManager alloc] init];
    //creating object for corebluetooth
    
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    
    self.uuidArray = [NSMutableArray array];
    
    for (int i=0; i < uuidStringArray.count; i++) {
        NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:[uuidStringArray objectAtIndex:i]];
        [self.uuidArray addObject:proximityUUID];
    }
    
    //
    if([self.uuidArray count] == 0){
        NSLog(@"BSLibException:- No UUIDs found to start monitoring");
        return;
    }
    
    // Populate the regions we will range once.
    self.rangedRegions = [[NSMutableDictionary alloc] init];
    
    for (NSUUID *uuid in self.uuidArray){
        
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:[uuid UUIDString]];
        self.rangedRegions[region] = [NSArray array];
    }
    
    // Start ranging after regions are ready.
    for (CLBeaconRegion *region in self.rangedRegions){
        
        [self.locationManager startMonitoringForRegion:region];
        [self.locationManager startUpdatingLocation];
        
    }
}

#pragma mark - Ranging

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    //    if(self.rangingActive)
    //        return;
    
    if(self.checkRangingAvailability == NO)
        self.checkRangingAvailability = YES;
    
    self.rangedRegions[region] = beacons;
    [self.beacons removeAllObjects];
    
    NSMutableArray *allBeacons = [NSMutableArray array];
    
    for (NSArray *regionResult in [self.rangedRegions allValues])
    {
        [allBeacons addObjectsFromArray:regionResult];
    }
    for (NSNumber *range in @[@(CLProximityUnknown), @(CLProximityImmediate), @(CLProximityNear), @(CLProximityFar)])
    {
        NSArray *proximityBeacons = [allBeacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", [range intValue]]];
        if([proximityBeacons count])
        {
            self.beacons[range] = proximityBeacons;
        }
    }
    //    NSLog(@"Beacons are %@",self.beacons);
    //    NSLog(@"Sorted nearer array %@",sortedDict);
}

-(void)stopRanging{
    // Stop ranging when the view goes away.
    for (CLBeaconRegion *region in self.rangedRegions)
    {
        [self.locationManager stopRangingBeaconsInRegion:region];
    }
}

#pragma -mark Monitoring

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    
    //start ranging for monitored regions
    for (CLBeaconRegion *tempRegion in self.rangedRegions) {
        
        if([tempRegion.identifier isEqual:region.identifier]){
            //            [tempRegion setNotifyEntryStateOnDisplay:YES];
            [tempRegion setNotifyOnEntry:YES];
            [tempRegion setNotifyOnExit:YES];
            [self.locationManager startRangingBeaconsInRegion:tempRegion];
            [self.locationManager startUpdatingLocation];
            self.rangingStarted = YES;
        }
    }
    if(!self.rangingTimer)
        self.rangingTimer=[NSTimer scheduledTimerWithTimeInterval:self.rangeInterval target:self selector:@selector(changeRangingStatus) userInfo:nil repeats:YES];
    
    [self.timer_checkRangingAvailability invalidate];
    self.timer_checkRangingAvailability=nil;
    self.timer_checkRangingAvailability=[NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(checkRanging) userInfo:nil repeats:NO];
    
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    
    //notify the delegate with the region it entered
    if(self.rangeBeaconDelegate && [self.rangeBeaconDelegate respondsToSelector:@selector(enteredRegion:)])
        [self.rangeBeaconDelegate enteredRegion:region];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    
    //notify the delegate with the region it entered
    if(self.rangeBeaconDelegate && [self.rangeBeaconDelegate respondsToSelector:@selector(exitedRegion:locationManager:)])
        [self.rangeBeaconDelegate exitedRegion:region locationManager:manager];
    
}

#pragma mark -Utility
-(NSDictionary *)getSortedResult :(NSDictionary *)beaconsDict {
    
    NSMutableDictionary *sortedDictionary = [[NSMutableDictionary alloc] init];
    
    for (NSNumber *range in @[@(CLProximityUnknown), @(CLProximityImmediate), @(CLProximityNear), @(CLProximityFar)]){
        if([[beaconsDict allKeys] containsObject:range]){
            NSArray *tempArray = [beaconsDict objectForKey:range];
            NSArray* resultArray= [tempArray sortedArrayUsingComparator:^NSComparisonResult(CLBeacon *obj1,CLBeacon *obj2)
                                   {
                                       if((obj1.accuracy) >(obj2.accuracy))
                                       {
                                           return NSOrderedDescending;
                                           
                                       }
                                       else
                                       {
                                           return NSOrderedAscending;
                                       }
                                   }];
            
            sortedDictionary[range] = resultArray;
        }
    }
    return sortedDictionary;
}

-(void)changeRangingStatus{
    if(self.rangingActive){
        self.rangingActive = NO;
        //notify the delegate with sorted beacons list
        if(self.rangeBeaconDelegate && [self.rangeBeaconDelegate respondsToSelector:@selector(rangedBeacons:)]){
            NSDictionary *sortedDict = [self getSortedResult:self.beacons];
            
            [self.rangeBeaconDelegate rangedBeacons:[self filterBeaconsOfType:sortedDict]];
        }
    }
    else
        self.rangingActive = YES;
}

-(void)checkRanging
{
    if(self.rangingStarted==NO)
    {
        [self.rangeBeaconDelegate rangingFailedWithError:@"Not inside region"];
        [self.timer_checkRangingAvailability invalidate];
        self.timer_checkRangingAvailability=nil;
        return;
    }
    if(self.rangingStarted==YES && self.checkRangingAvailability == NO)
    {
        [self.rangeBeaconDelegate rangingFailedWithError:@"RangingFailed"];
        [self.timer_checkRangingAvailability invalidate];
        self.timer_checkRangingAvailability=nil;
        return;
    }
}
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
    
}

- (NSArray *)filterBeaconsOfType:(NSDictionary *)beaconDict {
    
    NSMutableArray *filterdArray = [[NSMutableArray alloc] init];
    for (NSNumber *proximityType in self.proximityType) {
        if([[beaconDict objectForKey:proximityType] count] > 0)
            [filterdArray addObjectsFromArray:[beaconDict objectForKey:proximityType]];
    }
    return filterdArray;
    
}

@end
