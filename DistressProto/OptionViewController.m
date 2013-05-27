//
//  OptionViewController.m
//  PhoneCycleTest
//
//  Created by Andyy Hope on 22/04/13.
//  Copyright (c) 2013 Andyy Hope. All rights reserved.
//
#import "AppDelegate.h"
//#import "AppearanceConstants.h"
#import "Appearance.h"
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
@synthesize userName;
@synthesize userNumber;
@synthesize userLatitude;
@synthesize userLongitude;
@synthesize recipient;


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
    textPersonLabel.textColor = [UIColor whiteColor];
    textPersonLabel.text = @"TEXT MESSAGE";
    textPersonLabel.textAlignment = NSTextAlignmentCenter;
    textPersonLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:textPersonLabel];
    
    
    callNextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, self.view.frame.size.width, 30)];
    callNextLabel.font = kLOCATION_HEADER_FONT;
    callNextLabel.textColor = [UIColor whiteColor];
    callNextLabel.text = @"CALL";
    callNextLabel.textAlignment = NSTextAlignmentCenter;
    callNextLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:callNextLabel];
	
    self.view.backgroundColor = kLOCATION_HEADER_FONT_COLOR;
    

    // Add Stop button to bottom of view
    [Appearance addStopButtonToView:self];
    
    // Apply skin to Location label
    locationAddressLabel.frame = CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 100);
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
    
    UIImageView *smsImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smsIcon"]];
    smsImage.frame = CGRectMake(contactFrame.frame.size.width - 40, contactFrame.frame.size.height - 40, 30, 30);
    [contactFrame addSubview:smsImage];
    
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
    self.nextContactNameLabel.textAlignment = NSTextAlignmentCenter;
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
    
    UIImageView *callImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"callIcon"]];
    callImage.frame = CGRectMake(contactFrame.frame.size.width - 40, contactFrame.frame.size.height - 40, 30, 30);
    [contactFrame addSubview:callImage];
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
    NSLog(@"Message button pressed");
    
    MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
    messageComposeViewController.messageComposeDelegate = self;
    if ([MFMessageComposeViewController canSendText]) {
        recipient = nil;
        
        recipient = [[NSString alloc] initWithString:userNumber];
        [messageComposeViewController setRecipients:@[recipient]];

        //[messageComposeViewController setRecipients:@[@"0421523454"]];
        NSString *messageString = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps?f=q&hl=em&q=%@,%@&ie=UTF8&z=16&iwloc=addr&om=1", userLatitude, userLongitude];
        [messageComposeViewController setBody:[NSString stringWithFormat:@"%@ %@",kSMS_MESSAGE_TEXT, messageString]];  //<-- need to send the lat/long to this viewcontroller
        //[messageComposeViewController setBody:@"Help"];
        
        [self presentViewController:messageComposeViewController animated:YES completion:^{
            NSLog(@"present message");
        }];

    } else
    {
        NSLog(@"Cannot send text");
    }
}

-(void)messageContactAtIndex:(NSInteger)positionIndex
{
    
    NSLog(@"Message button done");
    
    MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
    messageComposeViewController.messageComposeDelegate = self;
    if ([MFMessageComposeViewController canSendText]) {
        recipient = nil;
        
        recipient = [[NSString alloc] initWithString:userNumber];
        
        //Recipient needs to be sent across also
        [messageComposeViewController setRecipients:@[recipient]];
        
        NSString *messageString = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps?f=q&hl=em&q=%@,%@&ie=UTF8&z=16&iwloc=addr&om=1", userLatitude, userLongitude];
        [messageComposeViewController setBody:[NSString stringWithFormat:@"%@ %@",kSMS_MESSAGE_TEXT, messageString]];  //<-- need to send the lat/long to this viewcontroller
        //[messageComposeViewController setBody:@"Help"];

        [self presentViewController:messageComposeViewController animated:NO completion:^{
            //code
        }];

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

-(void)updateUserName:(NSString *)name andNumber:(NSString *)number
{
    self.userName = name;
    self.userNumber = number;
    NSLog(@"bub:%@<<<%@",self.userName,self.userNumber);

}

-(void)updateLat:(NSString *)latitude andLong:(NSString *)longitude
{
    self.userLatitude = latitude;
    self.userLongitude = longitude;
    NSLog(@"bub:%@<<<%@",self.userLatitude,self.userLongitude);
}


- (void)updateContactImageWith:(UIImage *)newImage andNextContactImageWith:(UIImage *)nextImage
{
    contactImageView.image = newImage;
    nextContactImageView.image = nextImage;
}

@end
