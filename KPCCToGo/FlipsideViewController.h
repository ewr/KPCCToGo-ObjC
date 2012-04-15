//
//  FlipsideViewController.h
//  KPCCToGo
//
//  Created by Eric Richardson on 4/15/12.
//  Copyright (c) 2012 KPCC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController

@property (assign, nonatomic) IBOutlet id <FlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
