//
//  AudioPlayer.m
//  KPCCToGo
//
//  Created by Eric Richardson on 4/22/12.
//  Copyright (c) 2012 KPCC. All rights reserved.
//

#import "AudioPlayer.h"
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVAudioSession.h>

@interface AudioPlayer()
@property(nonatomic, retain, readwrite) NSURL* path;
@property(nonatomic, retain, readwrite) AVAudioPlayer* avplayer;
@property(nonatomic, retain, readwrite) id timerObject;
@property(nonatomic, readwrite) SEL timerSelector;
@end

@implementation AudioPlayer {
@private 
    //NSString *_path;
    //AVAudioPlayer *_avplayer;
    BOOL _haveAudio;
    NSTimer *_playTimer;
}

@synthesize path;
@synthesize avplayer;
@synthesize timerObject;
@synthesize timerSelector;

static AudioPlayer *_sharedPlayer = nil;

//----------

+ (id)sharedPlayer {
    if (_sharedPlayer == nil) {
        _sharedPlayer = [[super allocWithZone:NULL] init];
    }
    
    return _sharedPlayer;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedPlayer] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

//----------

- (void)initWithAudioPath:(NSURL *)_path {
    // stash this path
    self.path = _path;
    NSLog(@"stashed audio path of %@",_path);
    //return self;
}

//----------

- (bool)_initWithURL {
    NSError *error;
    
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.path error:&error];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
    if (audioPlayer == nil) {
        NSLog(@"avplayer init error: %@", error);
        return false;
    } else {
        self.avplayer = audioPlayer;
    }
    
    return true;
}

//----------

- (bool)setHaveAudio:(bool)status {
    if (status == true) {
        // saying yes...
        // init if we haven't already
        if (self.avplayer) {
            //[self.avplayer release];
            self.avplayer = nil;
        }    
        
        if (![self _initWithURL]) {
            return false;
        }
        
        self.avplayer.currentTime = 0;
        _haveAudio = true;
    } else {
        if (self.avplayer) {
            [self.avplayer stop];
            //[self.avplayer release];
            self.avplayer = nil;
        }
    }
    
    return true;
}

//----------

- (bool)audioReady {
    return _haveAudio;
}

//----------

- (bool)play {
    if (!self.avplayer) {
        if (![self _initWithURL]) {
            return false;
        }
    }
    
    if ([self.avplayer play]) {
        // start the slider update timer
        [self startTimer];        
        return true;
    } else {
        return false;
    }
}

- (bool)togglePlay {
    if (!self.avplayer) {
        if (![self _initWithURL]) {
            return false;
        }
    }
    
    if (self.avplayer.playing) {
        [self.avplayer stop];
        [self stopTimer];
    } else {
        [self startTimer];    
        [self.avplayer play];
    }
    
    return true;
}

//----------

- (void)stop {
    if (self.avplayer) {
        [self.avplayer stop];
        [self stopTimer];
    }
}

//----------

- (float)currentProgress {
    if (self.avplayer) {
        return (self.avplayer.currentTime / self.avplayer.duration);
    } else {
        return 0.0;
    }
}

//----------

- (void)registerTimerListener:(id)obj andSelector:(SEL)selector {
    self.timerObject = obj;
    self.timerSelector = selector;
}

//----------

- (void)startTimer {
    if (self.timerObject && self.timerSelector) {
        _playTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self.timerObject selector:self.timerSelector userInfo:self.avplayer repeats:YES];
    }
}

- (void)stopTimer {
    if (_playTimer) {
        [_playTimer invalidate];
        _playTimer = nil;
    }
}

@end
