//
//  RangeBeacons.h
//  HMHDiksuchi
//
//  Created by Bedre, Karthik on 3/12/15.
//  Copyright (c) 2015 Hughton Mifflin Harcourt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol RangingDelegate <NSObject>

-(void)RangedBeacons:(NSArray *)beacons;

@end

@interface RangeBeacons : NSObject<CLLocationManagerDelegate>

@property(nonatomic, strong)    CLLocationManager       *locationManager;
@property(nonatomic, weak)      id<RangingDelegate>     rangeDelegate;
@property NSMutableDictionary *beacons;

-(void)startRangingBeacons;

@end
