//
//  AppDelegate.m
//  KPCCToGo
//
//  Created by Eric Richardson on 4/15/12.
//  Copyright (c) 2012 Eric Richardson. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize player;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // register prefs
    NSString* prefPath = [[NSBundle mainBundle] pathForResource:@"Prefs" ofType:@"plist"];
    NSDictionary* userDefaults = [NSDictionary dictionaryWithContentsOfFile:prefPath];
    [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaults];
    
    // load AudioPlayer object
    
    //get the documents directory:
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    //make a file name to write the data to using the documents directory:
    //NSString *apath = [NSString stringWithFormat:@"%@/pump.mp3", documentsDirectory];
    
    //NSString *apath = [NSString stringWithFormat:@"%@/pump.mp3", [[NSBundle mainBundle] resourcePath]];
    //NSString *apath = [[NSBundle mainBundle] pathForResource:@"pump" ofType:@"mp3"];
    //NSString *apathtmp = [[NSBundle mainBundle] pathForResource:@"pump" ofType:@"mp3"];
    //NSLog(@"apathtmp is %@", apathtmp);
    //NSURL *apath = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"pump" ofType:@"mp3"]];
    //NSURL *apath = [[NSURL alloc] initFileURLWithPath:[NSString stringWithFormat:@"%@/Library/Caches/pump.mp3", [[NSBundle mainBundle] resourcePath]]];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSURL *aurl = [[NSURL alloc] initFileURLWithPath:[NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0],@"pump.mp3"]];
    
    NSLog(@"apath is %@", aurl);
    self.player = [AudioPlayer sharedPlayer]; 
    [self.player initWithAudioPath:aurl];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
