//
//  MainViewController.h
//  KPCCToGo
//
//  Created by Eric Richardson on 4/15/12.
//  Copyright (c) 2012 Eric Richardson. All rights reserved.
//


#import "FlipsideViewController.h"
#import "GrabNGoController.h"
#import "AudioPlayer.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@property (retain) GrabNGoController *client;
@property (retain) AudioPlayer *player;

@property (retain, nonatomic) IBOutlet UIView *downloadView;
@property (retain, nonatomic) IBOutlet UIProgressView *downloadProgress;
@property (retain, nonatomic) IBOutlet UILabel *downloadProgressLabel;

@property (retain, nonatomic) IBOutlet UIView *playView;
@property (retain, nonatomic) IBOutlet UIButton *playButton;
@property (retain, nonatomic) IBOutlet UIProgressView *playProgress;

@property (retain, nonatomic) IBOutlet UILabel *freshAtLabel;

@end
