//
//  GrabNGoController.h
//  KPCCToGo
//
//  Created by Eric Richardson on 4/21/12.
//  Copyright (c) 2012 Eric Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"

@interface GrabNGoController : AFHTTPClient;

@property (readonly) Boolean isDownloading;
@property (readonly) AFHTTPRequestOperation *operation;
@property (readonly) NSDate *freshAt;

- (void)startAudioGrabWithMinutes:(NSInteger)minutes topOfHour:(Boolean)top complete:(void (^)())complete;

@end
