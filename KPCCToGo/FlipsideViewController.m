//
//  FlipsideViewController.m
//  KPCCToGo
//
//  Created by Eric Richardson on 4/15/12.
//  Copyright (c) 2012 Eric Richardson. All rights reserved.
//

#import "FlipsideViewController.h"

@implementation FlipsideViewController
@synthesize duration = _duration;
@synthesize topOfHour = _topOfHour;
@synthesize durationLabel = _durationLabel;

@synthesize delegate = _delegate;

- (void)awakeFromNib
{
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 480.0);
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.duration.value = [[defaults objectForKey:@"duration"] floatValue];
    self.topOfHour.on = [[defaults objectForKey:@"topOfHour"] boolValue];
    
    // set initial duration label
    self.durationLabel.text = [NSString stringWithFormat:@"%1.f Minutes", self.duration.value];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setDuration:nil];
    [self setTopOfHour:nil];
    [self setDurationLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

#pragma mark - Actions

- (IBAction)durationChanged:(UISlider *)sender {
    self.durationLabel.text = [NSString stringWithFormat:@"%1.f Minutes", sender.value];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:sender.value forKey:@"duration"];
}

- (IBAction)topOfHourChanged:(UISwitch *)sender {
    // update topOfHour pref
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:sender.on forKey:@"topOfHour"];
}

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

- (void)dealloc {
    [_duration release];
    [_topOfHour release];
    [_durationLabel release];
    [super dealloc];
}
@end
