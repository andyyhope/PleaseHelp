//
//  OptionViewController.m
//  PhoneCycleTest
//
//  Created by Andyy Hope on 22/04/13.
//  Copyright (c) 2013 Andyy Hope. All rights reserved.
//
#import "AppDelegate.h"
#import "AppearanceConstants.h"
#import "OptionViewController.h"

@interface OptionViewController ()

@end

@implementation OptionViewController
@synthesize contactImage;
@synthesize contactNameLabel;
@synthesize contactNumber;
@synthesize nextContactImage;
@synthesize nextContactNameLabel;
@synthesize nextContactNumber;
@synthesize locationAddressLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.contactImage = [[UIImage alloc] init];
        self.contactNameLabel = [[UILabel alloc] init];
        self.locationAddressLabel = [[UILabel alloc] init];
        self.nextContactImage = [[UIImage alloc] init];
        
        nextContactImageView = [[UIImageView alloc] init];
        contactImageView = [[UIImageView alloc] init];
        
        self.nextContactNameLabel = [[UILabel alloc] init];
        locationHeaderLabel = [[UILabel alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self createContactFrame];
    [self createNextContactFrame];
    
    textPersonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 30)];
    textPersonLabel.font = kLOCATION_HEADER_FONT;
    textPersonLabel.textColor = kVIEW_ALT_BACKGROUND_COLOR;
    textPersonLabel.text = @"TEXT YOUR ADDRESS TO";
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
    textPersonLabel.textAlignment = UITextAlignmentCenter;
#else
    textPersonLabel.textAlignment = NSTextAlignmentCenter;
#endif
    //textPersonLabel.textAlignment = NSTextAlignmentCenter;
    textPersonLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:textPersonLabel];
    
    
    callNextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, self.view.frame.size.width, 30)];
    callNextLabel.font = kLOCATION_HEADER_FONT;
    callNextLabel.textColor = kVIEW_ALT_BACKGROUND_COLOR;
    callNextLabel.text = @"CALL NEXT PERSON";
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
    callNextLabel.textAlignment = UITextAlignmentCenter;
#else
    callNextLabel.textAlignment = NSTextAlignmentCenter;
#endif
    //callNextLabel.textAlignment = NSTextAlignmentCenter;
    callNextLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:callNextLabel];
	
    self.view.backgroundColor = kLOCATION_HEADER_FONT_COLOR;
    
    stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    stopButton.frame = CGRectMake(10, self.view.frame.size.height - 10 - 60, 300, 60);
    stopButton.backgroundColor = [UIColor redColor];
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
    //locationAddressLabel.textAlignment = NSTextAlignmentCenter;
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
    UIView *contactFrame = [[UIView alloc] initWithFrame:CGRectMake(10, 50, self.view.frame.size.width - 20, 110)];
    contactFrame.backgroundColor = [UIColor whiteColor];
    contactFrame.layer.cornerRadius = kCELL_CORNER_RADIUS;
    
    self.contactNameLabel.frame = CGRectMake(120, 20, 180, 30);
    self.contactNameLabel.backgroundColor = [UIColor clearColor];
    
    self.contactNameLabel.frame = CGRectMake(110, 20, 180, 30);
    self.contactNameLabel.numberOfLines = 1;
    self.contactNameLabel.backgroundColor = [UIColor clearColor];
    self.contactNameLabel.font = kCELL_HEADER_FONT;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
    locationAddressLabel.textAlignment = UITextAlignmentCenter;
#else
    locationAddressLabel.textAlignment = NSTextAlignmentCenter;
#endif
    self.contactNameLabel.textAlignment = NSTextAlignmentCenter;
    self.contactNameLabel.textColor = kCELL_HEADER_FONT_COLOR;
    
    contactImageView.frame = CGRectMake(10, 10, 90, 90);
    contactImageView.layer.cornerRadius = kCELL_CORNER_RADIUS;
    contactImageView.layer.masksToBounds = TRUE;
    
    [contactFrame addSubview:contactImageView];
    [contactFrame addSubview:contactNameLabel];
    [self.view addSubview:contactFrame];
    
    UIButton *textButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [textButton setBackgroundColor:[UIColor clearColor]];
    [textButton setFrame:contactFrame.frame];
    [textButton addTarget:self action:@selector(messageContact) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:textButton];
}
- (void)createNextContactFrame
{
    UIView *contactFrame = [[UIView alloc] initWithFrame:CGRectMake(10, 200, self.view.frame.size.width - 20, 110)];
    contactFrame.backgroundColor = [UIColor whiteColor];
    contactFrame.layer.cornerRadius = kCELL_CORNER_RADIUS;
    
    self.nextContactNameLabel.frame = CGRectMake(120, 20, 180, 30);
    self.nextContactNameLabel.backgroundColor = [UIColor clearColor];
    
    self.nextContactNameLabel.frame = CGRectMake(110, 20, 180, 30);
    self.nextContactNameLabel.numberOfLines = 1;
    self.nextContactNameLabel.backgroundColor = [UIColor clearColor];
    self.nextContactNameLabel.font = kCELL_HEADER_FONT;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
    self.nextContactNameLabel.textAlignment = UITextAlignmentCenter;
#else
    self.nextContactNameLabel.textAlignment = NSTextAlignmentCenter;
#endif
    //self.nextContactNameLabel.textAlignment = NSTextAlignmentCenter;
    self.nextContactNameLabel.textColor = kCELL_HEADER_FONT_COLOR;
    
    nextContactImageView.frame = CGRectMake(10, 10, 90, 90);
    nextContactImageView.layer.cornerRadius = kCELL_CORNER_RADIUS;
    nextContactImageView.layer.masksToBounds = TRUE;
    
    [contactFrame addSubview:nextContactImageView];
    [contactFrame addSubview:nextContactNameLabel];
    [self.view addSubview:contactFrame];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundColor:[UIColor clearColor]];
    [nextButton setFrame:contactFrame.frame];
    [nextButton addTarget:self action:@selector(callNextContact) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
}

- (void)callNextContact
{
    [self dismissViewControllerAnimated:NO completion:^{
        //
    }];
    
    NSLog(@"Call next contact");
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate callNextPerson];
}

- (void)messageContact
{
    
    
    MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
    messageComposeViewController.messageComposeDelegate = self;
    if ([MFMessageComposeViewController canSendText]) {
        [messageComposeViewController setRecipients:@[@"0421523454"]];
        //        [messageComposeViewController setBody:[NSString stringWithFormat:kHELP_MESSAGE_TEXT, locationAddressString, latitude, longitude]];
        [messageComposeViewController setBody:@"Halp"];
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
        [self.navigationController presentModalViewController:messageComposeViewController animated:NO];
#else
        [self presentViewController:messageComposeViewController animated:NO completion:^{
            //code
        }];
#endif

        
    }
}

-(void)messageContactAtIndex:(NSInteger)positionIndex
{
    MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
    messageComposeViewController.messageComposeDelegate = self;
    if ([MFMessageComposeViewController canSendText]) {
        [messageComposeViewController setRecipients:@[@"0421523454"]];
        // this is the real message
        //        [messageComposeViewController setBody:[NSString stringWithFormat:kHELP_MESSAGE_TEXT, locationAddressString, latitude, longitude]];
        [messageComposeViewController setBody:@"Help"];
        //[contactsViewController presentViewController:messageComposeViewController animated:YES completion:nil];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
        [self.navigationController presentModalViewController:messageComposeViewController animated:NO];
#else
        [self presentViewController:messageComposeViewController animated:NO completion:^{
            //code
        }];
#endif

    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            // cancelled
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultSent:
            // sent
            NSLog(@"Sent");
            break;
        case MessageComposeResultFailed:
            // failed
            NSLog(@"Failed");
            break;
        default:
            
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Message view dismissed");
        [self dismissViewControllerAnimated:NO completion:^{
            [self dismissCallingView];
            AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate callNextPerson];
        }];
        
        
    }];
    
}

- (void)updateContactImageWith:(UIImage *)newImage andNextContactImageWith:(UIImage *)nextImage
{
    contactImageView.image = newImage;
    nextContactImageView.image = nextImage;
}
@end
