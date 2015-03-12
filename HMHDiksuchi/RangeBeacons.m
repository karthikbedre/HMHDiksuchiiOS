//
//  RangeBeacons.m
//  HMHDiksuchi
//
//  Created by Bedre, Karthik on 3/12/15.
//  Copyright (c) 2015 Hughton Mifflin Harcourt. All rights reserved.
//

#import "RangeBeacons.h"

#define ProximityUUID           @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"

@interface RangeBeacons()
@property (nonatomic, strong) CLBeaconRegion *beaconRegion;
@end

@implementation RangeBeacons

@synthesize rangeDelegate;

-(void)startRangingBeacons{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate=self;
    
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    NSUUID *UUID = [[NSUUID alloc]initWithUUIDString:ProximityUUID];
    self.beaconRegion = [[CLBeaconRegion alloc]initWithProximityUUID:UUID identifier:@"EstimoteBeacons"];
    self.beaconRegion.notifyOnEntry=YES;
    self.beaconRegion.notifyOnExit=YES;
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
    
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    // current time plus 10 secs
    NSDate *now = [NSDate date];
    
    localNotification.fireDate = now;
    localNotification.alertBody = @"Hi there!! Welcome to HMH, slide through to get navigated.4";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
        
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    if(beacons.count>0){
        [self.rangeDelegate RangedBeacons:beacons];
    }
}


@end
