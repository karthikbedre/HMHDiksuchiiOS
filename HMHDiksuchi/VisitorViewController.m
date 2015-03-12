//
//  VisitorViewController.m
//  HMHDiksuchi
//
//  Created by Bedre, Karthik on 3/12/15.
//  Copyright (c) 2015 Hughton Mifflin Harcourt. All rights reserved.
//

#import "VisitorViewController.h"

@interface VisitorViewController ()

@property(nonatomic, strong)  BeaconRanging         *beaconRanging;
@end

@implementation VisitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Welcome";
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initializeRanging];
}

-(void)initializeRanging{
    
    if(!self.beaconRanging){
        self.beaconRanging = [[BeaconRanging alloc]init];
        self.beaconRanging.rangeBeaconDelegate=self;
        [self.beaconRanging startMonitoringWithProximityTypes:@[@(CLProximityNear),@(CLProximityFar),@(CLProximityImmediate)]];
    }
}

#pragma mark Range Beacon Delegates

-(void)rangedBeacons:(NSArray *)beacons{
    if(beacons.count>0)
        NSLog(@"%@",[beacons firstObject]);
}

-(void)rangingFailedWithError:(NSString *)error{
    
}

-(void)exitedRegion:(CLRegion *)region locationManager :(CLLocationManager *)locationManager{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    // current time plus 10 secs
    NSDate *now = [NSDate date];
    
    localNotification.fireDate = now;
    localNotification.alertBody = @"Hi there!! Welcome to HMH, slide through to get navigated.4";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(void)enteredRegion:(CLRegion *)region{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    // current time plus 10 secs
    NSDate *now = [NSDate date];
    
    localNotification.fireDate = now;
    localNotification.alertBody = @"Hi there!! Welcome to HMH, slide through to get navigated.4";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
