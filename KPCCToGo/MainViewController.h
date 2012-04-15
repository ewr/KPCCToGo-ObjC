//
//  MainViewController.h
//  KPCCToGo
//
//  Created by Eric Richardson on 4/15/12.
//  Copyright (c) 2012 KPCC. All rights reserved.
//

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@end
