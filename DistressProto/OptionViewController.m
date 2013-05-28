//
//  OptionViewController.m
//  PhoneCycleTest
//
//  Created by Andyy Hope on 22/04/13.
//  Copyright (c) 2013 Andyy Hope. All rights reserved.
//
#import "AppDelegate.h"

#import "SVProgressHUD.h"
#import "Appearance.h"
#import "OptionViewController.h"

@interface OptionViewController ()

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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
	
    [self createContactFrame];
    [self createNextContactFrame];
    
    textPersonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 30)];
    textPersonLabel.font = kLOCATION_HEADER_FONT;
    textPersonLabel.textColor = kVIEW_FOREGROUND_COLOR;
    textPersonLabel.text = @"TEXT YOUR LOCATION";
    textPersonLabel.textAlignment = NSTextAlignmentCenter;
    textPersonLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:textPersonLabel];
    
    
    callNextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 155, self.view.frame.size.width, 30)];
    callNextLabel.font = kLOCATION_HEADER_FONT;
    callNextLabel.textColor = kVIEW_FOREGROUND_COLOR;
    callNextLabel.text = @"CALL NEXT PERSON";
    callNextLabel.textAlignment = NSTextAlignmentCenter;
    callNextLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:callNextLabel];
	
    self.view.backgroundColor = kLOCATION_HEADER_FONT_COLOR;
    

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
    NSLog(@"Called");
    
    [self dismissViewControllerAnimated:YES completion:^{
        AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate endCallCycle];
    }];
}

- (void)createContactFrame
{
    UIView *contactFrame = [[UIView alloc] initWithFrame:CGRectMake(10, 35, self.view.frame.size.width - 20, 110)];
    
    [Appearance applySkinToOptionsContactFrame:contactFrame withName:contactName relation:contactRelation image:contactImage andIcon:[UIImage imageNamed:@"smsIcon"]];
    
    [self.view addSubview:contactFrame];
    
    UIButton *textButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [textButton setBackgroundColor:[UIColor clearColor]];
    [textButton setFrame:contactFrame.frame];
    [textButton addTarget:self action:@selector(messageContact) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:textButton];
}
- (void)createNextContactFrame
{
    UIView *contactFrame = [[UIView alloc] initWithFrame:CGRectMake(10, 185, self.view.frame.size.width - 20, 110)];
    
    [Appearance applySkinToOptionsContactFrame:contactFrame withName:nextContactName relation:nextContactRelation image:nextContactImage andIcon:[UIImage imageNamed:@"callIcon"]];
    
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
    NSLog(@"Message button pressed");
    
    MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
    messageComposeViewController.messageComposeDelegate = self;
    if ([MFMessageComposeViewController canSendText]) {
        recipient = nil;
        
        recipient = [[NSString alloc] initWithString:userNumber];
        [messageComposeViewController setRecipients:@[recipient]];

        //[messageComposeViewController setRecipients:@[@"0421523454"]];
        NSString *googleMapsString = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps?f=q&hl=em&q=%@,%@&ie=UTF8&z=16&iwloc=addr&om=1", userLatitude, userLongitude];
        NSString *messageString = [NSString stringWithFormat:@"Im within the vicinity of:\n%@\n\nShow in Maps:\n%@\n\nLatitude: %@\nLongitude: %@", locationAddressLabel.text, googleMapsString, userLatitude, userLongitude];
                
        [messageComposeViewController setBody:[NSString stringWithFormat:@"%@ %@",kSMS_MESSAGE_TEXT, messageString]];
        
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
        [messageComposeViewController setBody:[NSString stringWithFormat:@"%@ %@",kSMS_MESSAGE_TEXT, messageString]]; 

        [self presentViewController:messageComposeViewController animated:NO completion:^{
            //code
        }];

    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
            [SVProgressHUD showErrorWithStatus:@"Message was cancelled"];
            NSLog(@"Cancelled");
            break;
        case MessageComposeResultSent:
            [SVProgressHUD showSuccessWithStatus:@"Message was sent"];
            NSLog(@"Sent");
            break;
        case MessageComposeResultFailed:
            [SVProgressHUD showErrorWithStatus:@"Message did not send"];
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
    NSLog(@"u:%@<<<%@",self.userName,self.userNumber);

}

-(void)updateLat:(NSString *)latitude andLong:(NSString *)longitude
{
    self.userLatitude = latitude;
    self.userLongitude = longitude;
    NSLog(@"u:%@<<<%@",self.userLatitude,self.userLongitude);
}




@end
