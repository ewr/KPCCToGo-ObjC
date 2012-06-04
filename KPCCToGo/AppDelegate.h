//
//  AppDelegate.h
//  KPCCToGo
//
//  Created by Eric Richardson on 4/15/12.
//  Copyright (c) 2012 Eric Richardson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayer.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AudioPlayer *player;

@end
