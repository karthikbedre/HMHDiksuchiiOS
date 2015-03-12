//
//  BeaconRanging.h
//  HMHDiksuchi
//
//  Created by Bedre, Karthik on 3/12/15.
//  Copyright (c) 2015 Hughton Mifflin Harcourt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol RangeBeaconDelegates <NSObject>

@required

-(void)rangedBeacons:(NSArray *)beacons;

-(void)rangingFailedWithError:(NSString *)error;

@optional

-(void)exitedRegion:(CLRegion *)region locationManager :(CLLocationManager *)locationManager;

-(void)enteredRegion:(CLRegion *)region;

@end

@interface BeaconRanging : NSObject<CLLocationManagerDelegate>
@property NSMutableDictionary *beacons;
@property CLLocationManager *locationManager;
@property NSMutableDictionary *rangedRegions;
@property (nonatomic, strong) id<RangeBeaconDelegates> rangeBeaconDelegate;


- (void)startRanging:(NSArray *)uuidArray;
- (void)startMonitoringWithProximityTypes:(NSArray *)proximityTypes;

@end
