//
//  OptionViewController.m
//  Please Help
//
//  Created by Adrian Jurcevic & Andyy Hope on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "AppDelegate.h"
#import "SVProgressHUD.h" 
#import "OptionViewController.h"
#import "TextToSpeech.h"
#import "Appearance.h"

//Define the private variables for this class
@interface OptionViewController ()
{
    TextToSpeech *textToSpeech;
}

@end

@implementation OptionViewController
@synthesize contactImage;
@synthesize contactName;
@synthesize contactNumber;
@synthesize contactRelation;
@synthesize nextContactImage;
@synthesize nextContactName;
@synthesize nextContactNumber;
@synthesize nextContactRelation;
@synthesize locationAddressLabel;
@synthesize userName;
@synthesize userNumber;
@synthesize userLatitude;
@synthesize userLongitude;
@synthesize recipient;
@synthesize googleMapsString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialize 
        self.locationAddressLabel = [[UILabel alloc] init];
        self.contactImage = [[UIImage alloc] init];
        self.nextContactImage = [[UIImage alloc] init];
        locationHeaderLabel = [[UILabel alloc] init];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = kLOCATION_HEADER_FONT_COLOR;
    
    // Setup Contact frames
    [self createContactFrame];
    [self createNextContactFrame];

    //Initialise Text to Speech
    textToSpeech = [[TextToSpeech alloc] init];
    [textToSpeech optionWithContact:contactName andNextContact:nextContactName];
    
    // Setup Text Labels for Contact and Next Contact
    textPersonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5  + 20, self.view.frame.size.width, 30)];
    textPersonLabel.font = kLOCATION_HEADER_FONT;
    textPersonLabel.textColor = kVIEW_FOREGROUND_COLOR;
    textPersonLabel.text = @"TEXT MESSAGE";
    textPersonLabel.textAlignment = NSTextAlignmentCenter;
    textPersonLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:textPersonLabel];
    
    callNextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 155 + 20, self.view.frame.size.width, 30)];
    callNextLabel.font = kLOCATION_HEADER_FONT;
    callNextLabel.textColor = kVIEW_FOREGROUND_COLOR;
    callNextLabel.text = @"CALL NEXT PERSON";
    callNextLabel.textAlignment = NSTextAlignmentCenter;
    callNextLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:callNextLabel];
        
    // Add Stop button to bottom of view
    [Appearance addStopButtonToView:self];
    
    // Apply skin to Location label
    locationAddressLabel.frame = CGRectMake(0, self.view.frame.size.height - 170, self.view.frame.size.width, 100);
    [Appearance applySkinToLocationLabel:locationAddressLabel];
    locationAddressLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.view addSubview:locationAddressLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dismissCallingView
{
    // Dismiss Calling View
    [self dismissViewControllerAnimated:YES completion:^{
        AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate endCallCycle];
    }];
}

- (void)createContactFrame
{
    // Setup Contact frame
    UIView *contactFrame = [[UIView alloc] initWithFrame:CGRectMake(10, 35 + 20, self.view.frame.size.width - 20, 110)];
    
    // Apply skin to Contact frame
    [Appearance applySkinToOptionsContactFrame:contactFrame withName:contactName relation:contactRelation image:contactImage andIcon:[UIImage imageNamed:@"smsIcon"]];
    [self.view addSubview:contactFrame];
    
    // Create a Text Message button
    UIButton *textButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [textButton setBackgroundColor:[UIColor clearColor]];
    [textButton setFrame:contactFrame.frame];
    [textButton addTarget:self action:@selector(messageContact) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:textButton];
}

- (void)createNextContactFrame
{
    // Setup Next Contact frame
    UIView *contactFrame = [[UIView alloc] initWithFrame:CGRectMake(10, 185 + 20, self.view.frame.size.width - 20, 110)];
    
    // Apply skin to Next Contact frame
    [Appearance applySkinToOptionsContactFrame:contactFrame withName:nextContactName relation:nextContactRelation image:nextContactImage andIcon:[UIImage imageNamed:@"callIcon"]];
    [self.view addSubview:contactFrame];
    
    // Create a Call Next Contact button
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundColor:[UIColor clearColor]];
    [nextButton setFrame:contactFrame.frame];
    [nextButton addTarget:self action:@selector(callNextContact) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
}

- (void)callNextContact
{
    // Dismiss View
    [self dismissViewControllerAnimated:NO completion:^{
    }];
    
    // Then call Next Contact
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate callNextPerson];
}

- (void)messageContact
{
    //Initilise the message composer view
    [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    NSDictionary *titleTextAttr = @{[UIColor greenColor]: NSForegroundColorAttributeName};
    [[UINavigationBar appearance] setTitleTextAttributes:titleTextAttr];
    MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
    
    //Set delegate
    messageComposeViewController.messageComposeDelegate = self;
    
    messageComposeViewController.navigationBar.tintColor = [UIColor redColor];
    //Check if SMS Text can be sent from device

    if ([MFMessageComposeViewController canSendText]) {
        //If enabled, clear the recipients
        recipient = nil;
    
        //Add the recipient of the current contact user
        recipient = [[NSString alloc] initWithString:userNumber];
        [messageComposeViewController setRecipients:@[recipient]];

        //Define the message for assistance to the recipient
        NSString *messageString = [[NSString alloc]
                                   initWithFormat:@"Im within the vicinity of:\n%@\n\nShow in Maps:\n%@\n\nLatitude: %@\nLongitude: %@",
                                   locationAddressLabel.text,
                                   self.googleMapsString,
                                   userLatitude,
                                   userLongitude];
        
        NSString *completeString = [[NSString alloc]
                                    initWithFormat:@"%@ %@",
                                    kSMS_MESSAGE_TEXT,
                                    messageString];
        
        //Add message defined into the body of the SMS Text
        [messageComposeViewController setBody:completeString];
        //Initiate Text to Speech
        [textToSpeech say:@"PRESS THE BLUE, SEND BUTTON TO TEXT MESSAGE"];
        
        //Present the SMS Message Composer View
        [self presentViewController:messageComposeViewController animated:YES completion:^{
            
        }];

    } else
    {
        //Display Error
        [SVProgressHUD showErrorWithStatus:@"Cannot send Messages"];
    }
}

//A delegate method when initialising a message composer view
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    // Show HUD based on Message send status
    switch (result) {
        case MessageComposeResultCancelled:
            [SVProgressHUD showErrorWithStatus:@"Message cancelled"];
            break;
        case MessageComposeResultSent:
            [SVProgressHUD showSuccessWithStatus:@"Message sent"];
            break;
        case MessageComposeResultFailed:
            [SVProgressHUD showErrorWithStatus:@"Message failed"];
            break;
        default:
            
            break;
    }
    // Dismiss Message UI View
    [controller dismissViewControllerAnimated:YES completion:^{
        // Dismiss Option View
        [self dismissViewControllerAnimated:NO completion:^{
            [self dismissCallingView];
            // Call Next Contact
            AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];


//            [appDelegate updateAppearanceOfUIKit];
            [appDelegate callNextPerson];
            
        }];
    }];
}

-(void)updateUserName:(NSString *)name andNumber:(NSString *)number
{
    // Update Contact Name
    self.userName = name;
    self.userNumber = number;
}

-(void)updateLat:(NSString *)latitude andLong:(NSString *)longitude
{
    // Update Lat/Long
    self.userLatitude = latitude;
    self.userLongitude = longitude;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
