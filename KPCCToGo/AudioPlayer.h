//
//  AudioPlayer.h
//  KPCCToGo
//
//  Created by Eric Richardson on 4/22/12.
//  Copyright (c) 2012 KPCC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface AudioPlayer : NSObject

@property (retain, nonatomic, readonly) NSURL *path;

+ (id)sharedPlayer;

- (void)initWithAudioPath:(NSURL *)path;
- (bool)setHaveAudio:(bool)status;
- (bool)audioReady;
- (void)stop;
- (bool)togglePlay;
- (bool)play;
- (void)registerTimerListener:(id)obj andSelector:(SEL)selector;
- (float)currentProgress;

@end
