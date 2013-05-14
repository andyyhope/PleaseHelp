//
//  CallingViewController.m
//  PhoneCycleTest
//
//  Created by Andyy Hope on 22/04/13.
//  Copyright (c) 2013 Andyy Hope. All rights reserved.
//
#import "AppDelegate.h"
#import "AppearanceConstants.h"
#import "CallingViewController.h"

@implementation CallingViewController
@synthesize contactImage;
@synthesize contactNameLabel;
@synthesize contactNumber;
@synthesize locationAddressLabel, locationHeaderLabel;

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
    
    [self createContactFrame];
	
    self.view.backgroundColor = kLOCATION_HEADER_FONT_COLOR;
    
    stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    stopButton.frame = CGRectMake(10, self.view.frame.size.height - 10 - 60, 300, 60);
    stopButton.backgroundColor = kSTOP_BACKGROUND_COLOR;
    [stopButton setTitle:@"STOP" forState:UIControlStateNormal];
    stopButton.titleLabel.font = kCELL_HEADER_FONT;
    stopButton.layer.cornerRadius = kCELL_CORNER_RADIUS;
    [stopButton addTarget:self action:@selector(dismissCallingView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopButton];
    
    locationAddressLabel.frame = CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 100);
    locationAddressLabel.backgroundColor = [UIColor clearColor];
    locationAddressLabel.font = [UIFont boldSystemFontOfSize:18];
    locationAddressLabel.textColor = [UIColor whiteColor];

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
    locationAddressLabel.textAlignment = UITextAlignmentCenter;
#else
    locationAddressLabel.textAlignment = NSTextAlignmentCenter;
#endif

//    locationAddressLabel.textAlignment = NSTextAlignmentCenter;
    locationAddressLabel.numberOfLines = 0;
    [self.view addSubview:locationAddressLabel];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) dismissCallingView
{
    NSLog(@"Called");
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate endCallCycle];
    }];
}

- (void)createContactFrame
{
    UIView *contactFrame = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 110)];
    contactFrame.backgroundColor = [UIColor whiteColor];
    contactFrame.layer.cornerRadius = kCELL_CORNER_RADIUS;
    
    self.contactNameLabel.frame = CGRectMake(110, 20, 180, 30);
    self.contactNameLabel.numberOfLines = 1;
    self.contactNameLabel.backgroundColor = [UIColor clearColor];
    self.contactNameLabel.font = kCELL_HEADER_FONT;

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
    self.contactNameLabel.textAlignment = UITextAlignmentCenter;
#else
    self.contactNameLabel.textAlignment = NSTextAlignmentCenter;
#endif

    //self.contactNameLabel.textAlignment = NSTextAlignmentCenter;
    self.contactNameLabel.textColor = kCELL_HEADER_FONT_COLOR;
    
    contactImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 90, 90)];
    contactImageView.layer.cornerRadius = kCELL_CORNER_RADIUS;
    contactImageView.layer.masksToBounds = TRUE;
    contactImageView.image = contactImage;
    
    [contactFrame addSubview:contactImageView];
    [contactFrame addSubview:contactNameLabel];
    
    [self.view addSubview:contactFrame];
    
}

- (void)updateContactImageWith:(UIImage *)newImage
{
    contactImageView.image = newImage;
}
@end
