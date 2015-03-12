//
//  VisitorInteractController.m
//  HMHDiksuchi
//
//  Created by Bedre, Karthik on 3/12/15.
//  Copyright (c) 2015 Hughton Mifflin Harcourt. All rights reserved.
//

#import "VisitorInteractController.h"
#import <CoreLocation/CoreLocation.h>
@interface VisitorInteractController ()<iCarouselDataSource,iCarouselDelegate>

@property(nonatomic, strong) NSMutableArray     *beaconArray;
@property(nonatomic, strong) NSMutableArray     *messagesArray;
@property(nonatomic, strong)  BeaconRanging         *beaconRanging;
@property(nonatomic, strong) NSMutableDictionary  *messagesDict;
@end

@implementation VisitorInteractController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.messagesDict = [[NSMutableDictionary alloc]init];
    [self.messagesDict setObject:@"We have notified your meeting host (EMPLOYEE NAME) that you’ve arrived. Before proceeding, please check in with the security desk to receive your visitor badge. (EMPLOYEE NAME) will contact you shortly.Please proceed to (X) floor after check in at security desk" forKey:@"50148"];
    [self.messagesDict setObject:@"Great job! Your meeting is on this floor! (EMPLOYEE NAME) will meet you here soon." forKey:@"46740"];
    [self.messagesDict setObject:@"Wrong Floor! Oops! \n Looks like you’ve landed on the wrong floor. This is the (4th) floor. Your meeting takes place on the (3rd) Floor." forKey:@"61155"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myCarousel.delegate=self;
    self.myCarousel.dataSource=self;
    self.myCarousel.type=iCarouselTypeCoverFlow;
    
    self.myCarousel.layer.borderWidth = 1.0;
    self.myCarousel.layer.borderColor = [[UIColor grayColor] CGColor];
    
    self.messagesArray = [[NSMutableArray alloc]init];
    self.beaconArray = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initializeRanging];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.beaconArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if(!view){
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, carousel.frame.size.width, carousel.frame.size.height)];
        UILabel *label = [[UILabel alloc]initWithFrame:view.frame];
        view.backgroundColor=[UIColor lightGrayColor];
        label.numberOfLines = 8;
        NSDictionary *dict= [self.messagesArray objectAtIndex:index];
        
        label.text = [dict objectForKey:@"message"];
        
        [view addSubview:label];
    }
    return view;
}

-(void)initializeRanging{
    
    if(!self.beaconRanging){
        self.beaconRanging = [[BeaconRanging alloc]init];
        self.beaconRanging.rangeBeaconDelegate=self;
        [self.beaconRanging startMonitoringWithProximityTypes:@[@(CLProximityNear)]];
    }
}

#pragma mark Range Beacon Delegates

-(void)rangedBeacons:(NSArray *)beacons{
    if(beacons.count>0){
        NSLog(@"%@",[beacons firstObject]);
        CLBeacon *beacon = beacons.firstObject;
        if(![self.beaconArray containsObject:beacon.major]){
            [self.beaconArray addObject:beacon.major];
            
            NSMutableDictionary *metaData = [[NSMutableDictionary alloc]init];
            [metaData setObject:[self.messagesDict objectForKey:[NSString stringWithFormat:@"%@",beacon.major]] forKey:@"message"];
            [self.messagesArray addObject:metaData];
            [self.myCarousel insertItemAtIndex:self.messagesArray.count-1 animated:YES];
            [self.myCarousel scrollToItemAtIndex:self.messagesArray.count-1 animated:YES];
        }
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
