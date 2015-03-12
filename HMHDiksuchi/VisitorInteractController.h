//
//  VisitorInteractController.h
//  HMHDiksuchi
//
//  Created by Bedre, Karthik on 3/12/15.
//  Copyright (c) 2015 Hughton Mifflin Harcourt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "BeaconRanging.h"

@interface VisitorInteractController : UIViewController<RangeBeaconDelegates>

@property(nonatomic, strong) IBOutlet   iCarousel   *myCarousel;
@property(nonatomic, weak) IBOutlet     UILabel     *lbl_name,*lbl_address;

@end
