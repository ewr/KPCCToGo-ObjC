//
//  MainViewController.m
//  KPCCToGo
//
//  Created by Eric Richardson on 4/15/12.
//  Copyright (c) 2012 Eric Richardson. All rights reserved.
//

#import "MainViewController.h"
#import "AudioPlayer.h"

@implementation MainViewController

@synthesize flipsidePopoverController = _flipsidePopoverController;

@synthesize client;
@synthesize player;

@synthesize downloadView;
@synthesize downloadProgress;
@synthesize downloadProgressLabel;

@synthesize playView;
@synthesize playButton;
@synthesize playProgress;
@synthesize freshAtLabel;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setDownloadView:nil];
    [self setDownloadProgress:nil];
    [self setDownloadProgressLabel:nil];
    [self setPlayButton:nil];
    [self setPlayProgress:nil];
    [self setPlayView:nil];
    [self setFreshAtLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // get a pointer to the global player object
    self.player = [AudioPlayer sharedPlayer];
    
    if (client && client.isDownloading) {
        // show the download view
        NSLog(@"vWA show downloadView");
        self.downloadView.alpha = 1;
    } else {
        self.downloadView.alpha = 0;
        NSLog(@"vWA hide downloadView");
    }
    
    // should we show the player view?
    [self showPlayerIfAudio];
    
    // register timer to connect to the progress bar
    [self.player registerTimerListener:self andSelector:@selector(updatePlayerProgress:)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (void)dealloc
{
    [_flipsidePopoverController release];
    [downloadView release];
    [downloadProgress release];
    [downloadProgressLabel release];
    [playButton release];
    [playProgress release];
    [playView release];
    [freshAtLabel release];
    [super dealloc];
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}

- (IBAction)grabAudioButtonPushed:(UIButton *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!self.client) {
        client = [[GrabNGoController alloc] 
                       initWithBaseURL:[NSURL URLWithString:[defaults stringForKey:@"serverURL"]]];
    }
    
    // make sure we aren't already downloading
    if (client.isDownloading) {
        // we don't start another download...
        return;
    }
    
    // stop and hide the player if it's running
    self.playView.alpha = 0;
    [self.player stop];
    
    // what happens when the request completes?
    void (^complete)() = ^(){
        // re-enable download button
        sender.enabled = YES;
        
        // hide the download area
        self.downloadView.alpha = 0;
        
        // if we have audio, show the player
        if (self.client.freshAt) {
            // display audio player
            NSLog(@"fresh audio!");
            NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"EEEE, h:mma" options:0 locale:[NSLocale currentLocale]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:formatString];
            self.freshAtLabel.text = [dateFormatter stringFromDate:self.client.freshAt];
            
            // display player
            [self showPlayerIfAudio];
        }
    };
    
    // start the download...
    [client startAudioGrabWithMinutes:[defaults integerForKey:@"duration"] 
                            topOfHour:[defaults boolForKey:@"topOfHour"] complete:complete];
    
    // progress tracker
    [client.operation setDownloadProgressBlock:^(NSInteger bytesRead, NSInteger totalBytesRead, NSInteger totalBytesExpectedToRead) {
        NSNumber *prog = [NSNumber numberWithFloat:((float)totalBytesRead / (float)totalBytesExpectedToRead)];
        //NSLog(@"prog is %@", prog);
        [self.downloadProgress setProgress:[prog floatValue]];
    }];
    
    // hide download button
    sender.enabled = NO;
    
    // show download view
    self.downloadView.alpha = 1;
}

//----------

- (IBAction)playButtonPushed:(UIButton *)sender {
    [self.player togglePlay];
}

//----------

- (void)showPlayerIfAudio {
    NSLog(@"showPlayerIfAudio");
    
    if ([self.player audioReady]) {
        self.playProgress.progress = self.player.currentProgress;        
        self.playView.alpha = 1;
    } else {
        self.playView.alpha = 0;
    }
}

- (void)updatePlayerProgress:(NSTimer *)timer {
    [self.playProgress setProgress:self.player.currentProgress];
}

@end
