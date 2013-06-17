//
//  RCReachabilityClientViewController.h
//  eppz!reachability
//
//  Created by Gardrobe on 6/16/13.
//  Copyright (c) 2013 eppz!. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPPZRechabilityStatusView.h"


@interface RCReachabilityClientViewController : UIViewController

    <EPPZReachabilityDelegate>

@property (nonatomic, weak) IBOutlet UISegmentedControl *reachabilityModeSegmentedControl;
@property (nonatomic, weak) IBOutlet EPPZRechabilityStatusView *statusView;

@end
