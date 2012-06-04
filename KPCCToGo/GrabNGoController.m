//
//  GrabNGoController.m
//  KPCCToGo
//
//  Created by Eric Richardson on 4/21/12.
//  Copyright (c) 2012 Eric Richardson. All rights reserved.
//

#import "GrabNGoController.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AudioPlayer.h"

@implementation GrabNGoController {

@private
    Boolean _isDownloading;
    AFNetworkActivityIndicatorManager *activityManager;
    AFHTTPRequestOperation *_operation;
    NSDate *_freshAt;
    AudioPlayer *_player;
}

@synthesize isDownloading   = _isDownloading;
@synthesize operation       = _operation;
@synthesize freshAt         = _freshAt;

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self setDefaultHeader:@"Accept" value:@"audio/mpeg"];
    [self setDefaultHeader:@"User-Agent" value:@"KPCC Grab-N-Go 0.1"];
    
    activityManager = [AFNetworkActivityIndicatorManager sharedManager];
    activityManager.enabled = true;
    
    // grab a copy of the shared player
    _player = [AudioPlayer sharedPlayer];
    
    return self;
}

- (void)startAudioGrabWithMinutes:(NSInteger)minutes topOfHour:(Boolean)top complete:(void (^)())complete {
    // start our download
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[NSNumber numberWithInt:minutes*60] forKey:@"pump"];
    
    NSDate *reqDate = [NSDate date];
    
    // create success handler
    void (^success)(AFHTTPRequestOperation*,id) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        // success
        _isDownloading = false;
        [activityManager decrementActivityCount];
        
        _freshAt = reqDate;
        [_player setHaveAudio:true];
        
        NSLog(@"success");
        complete();
    };
    
    // create failure handler
    void (^failure)(AFHTTPRequestOperation*,id) = ^(AFHTTPRequestOperation *operation, NSError *error) {
        // failure
        _isDownloading = false;
        [activityManager decrementActivityCount];
        NSLog(@"failure");
        
        _freshAt = nil;
        
        complete();
    };
        
    NSURLRequest *request = [self requestWithMethod:@"GET" path:@"" parameters:params];
    _operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    
    NSLog(@"writing to %@", _player.path);
    [[NSData data] writeToURL:_player.path options:NSDataWritingAtomic error:nil];
    _operation.outputStream = [NSOutputStream outputStreamWithURL:_player.path append:NO];
    
    [self enqueueHTTPRequestOperation:_operation];
        
    NSLog(@"starting download");

    _isDownloading = true;
    [activityManager incrementActivityCount];
}

@end