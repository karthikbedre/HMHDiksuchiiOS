//
//  VisitorViewController.m
//  HMHDiksuchi
//
//  Created by Bedre, Karthik on 3/12/15.
//  Copyright (c) 2015 Hughton Mifflin Harcourt. All rights reserved.
//

#import "VisitorViewController.h"

@interface VisitorViewController ()

@property(nonatomic, strong)  RangeBeacons        *moniterBeacons;

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
    if(!self.moniterBeacons){
        self.moniterBeacons = [[RangeBeacons alloc]init];
        [self.moniterBeacons startRangingBeacons];
        self.moniterBeacons.rangeDelegate = self;
    }
}

-(void)RangedBeacons:(NSArray *)beacons{
    NSLog(@"%@",beacons);
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
