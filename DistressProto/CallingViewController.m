//
//  CallingViewController.m
//  Please Help
//
//  Created by Adrian Jurcevic & Anddy Hope on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "AppDelegate.h"
#import "CallingViewController.h"
#import "TextToSpeech.h"

@implementation CallingViewController
@synthesize contactIndex;
@synthesize contactImage;
@synthesize contactName;
@synthesize contactNameLabel;
@synthesize contactNumber;
@synthesize contactRelation;
@synthesize locationAddressLabel;
@synthesize  locationHeaderLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.contactImage = [[UIImage alloc] init];
        self.contactNameLabel = [[UILabel alloc] init];
        self.locationAddressLabel = [[UILabel alloc] init];
        self.locationHeaderLabel = [[UILabel alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Update Appearances
    [self createContactFrame];
	self.view.backgroundColor = kLOCATION_HEADER_FONT_COLOR;
    
    // Text to speech
    // NOT WORKING
    TextToSpeech *textToSpeech = [[TextToSpeech alloc] init];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TextToSpeechEnabled"])
    {
        [textToSpeech doYouWantToCall:contactName];
    }
    
    // Add a Stop button to bottom of screen
    [Appearance addStopButtonToView:self];
    
    // Add a label for Location and skin it
    locationAddressLabel.frame = CGRectMake(0, self.view.frame.size.height - 160, self.view.frame.size.width, 100);
    [Appearance applySkinToLocationLabel:locationAddressLabel];
    [self.view addSubview:locationAddressLabel];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dismissCallingView
{
    // Pop view off stack
    [self dismissViewControllerAnimated:YES completion:^{
        AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate endCallCycle];
    }];
}

- (void)createContactFrame
{
    // Create Contact frame
    // Add to view
    UIView *contactFrame = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 110)];
    [Appearance applySkinToContactFrame:contactFrame withName:contactName  relation:contactRelation andImage:contactImage];
    [self.view addSubview:contactFrame];
    
    // Add transparent button over frame
    UIButton *contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
    contactButton.frame = contactFrame.frame;
    [contactButton addTarget:self action:@selector(contactButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:contactButton];
}

- (void)updateContactImageWith:(UIImage *)newImage
{
    // Refresh Contact Image
    contactImageView.image = newImage;
}

- (void)contactButtonPressed
{
    // If the user Cancelled the Call Dialog
    // They can press the Contact frame to start the Call Cycle
    [self dismissViewControllerAnimated:NO completion:^{
        AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate startCallCycleAt:contactIndex withAnimation:NO];
    }];
    
}

@end
