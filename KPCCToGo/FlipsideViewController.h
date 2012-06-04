//
//  FlipsideViewController.h
//  KPCCToGo
//
//  Created by Eric Richardson on 4/15/12.
//  Copyright (c) 2012 Eric Richardson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController

@property (assign, nonatomic) IBOutlet id <FlipsideViewControllerDelegate> delegate;
@property (retain, nonatomic) IBOutlet UISlider *duration;
@property (retain, nonatomic) IBOutlet UISwitch *topOfHour;
@property (retain, nonatomic) IBOutlet UILabel *durationLabel;

- (IBAction)done:(id)sender;

@end
