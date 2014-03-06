//
//  SettingsViewController.m
//  Please Help
//
//  Created by Adrian Jurcevic & Andyy Hope on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

//Import the relavant Class Header files that are linked to this Class
#import "SettingsViewController.h"
#import "ContactViewController.h"
#import "PasscodeSettingsViewController.h"
#import "VoiceViewController.h"
#import "SVProgressHUD.h"

#import "HMSegmentedControl.h"
#import "Appearance.h"

//Define the private variables for this class
@interface SettingsViewController ()
{
    PasscodeSettingsViewController *passcodeViewController;
    ContactViewController *contactViewController;
    VoiceViewController *voiceViewController;
    HMSegmentedControl *segmentedControl;
    UIAlertView *alertView;
    UIScrollView *viewContainer;
}
@end

@implementation SettingsViewController

//This is the first method run in this class which is launched when the view loads.
- (void)viewDidLoad
{
    [self setNeedsStatusBarAppearanceUpdate];
    
    [super viewDidLoad];

    //Remove any ProgressHUD from view
    [SVProgressHUD dismiss];

    //Set the background to the colour defined in the AppearanceConstants.h class
    self.view.backgroundColor = kVIEW_BACKGROUND_COLOR;
    
    //Set the title of the view
    self.navigationItem.title = @"Settings";
    
    //Initialise the two view controller classes - Contacts and Passcode
    contactViewController = [[ContactViewController alloc] initWithStyle:UITableViewStyleGrouped];
    passcodeViewController = [[PasscodeSettingsViewController alloc] init];
    voiceViewController = [[VoiceViewController alloc] init];
    
    //Create the Segmented Controller
    segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"Contacts", @"Passcode", @"Voice"]];
    segmentedControl.backgroundColor = kVIEW_ALT2_BACKGROUND_COLOR;
    [segmentedControl setSelectionStyle:HMSegmentedControlSelectionStyleFullWidthStrip];
    [segmentedControl setSelectionLocation:HMSegmentedControlSelectionLocationDown];
    [segmentedControl setTextColor:kVIEW_ALT_BACKGROUND_COLOR];
    [segmentedControl setFont:kCELL_TEXT_FONT];
    [segmentedControl setSelectedTextColor:[UIColor whiteColor]];
    [segmentedControl setFrame:CGRectMake(0, -10, 320, 50)];
    [segmentedControl setSelectedTextColor:[UIColor whiteColor]];
    [segmentedControl addTarget:self action:@selector(segmentAction) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    
    //Set the size of these views so they fit within the bounds of the current SettingsViewController Class
    contactViewController.view.frame = CGRectMake(self.view.frame.size.width * 0, 0, self.view.frame.size.width, self.view.frame.size.height - 40);
    passcodeViewController.view.frame = CGRectMake(self.view.frame.size.width * 1, 0, self.view.frame.size.width, self.view.frame.size.height - 40);
    voiceViewController.view.frame = CGRectMake(self.view.frame.size.width * 2, 0, self.view.frame.size.width, self.view.frame.size.height - 40);
    
    // Create a view container for better UX
    viewContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height - 40)];
    viewContainer.scrollEnabled = false;
    viewContainer.backgroundColor = [UIColor clearColor];
    viewContainer.contentSize = CGSizeMake(self.view.frame.size.width * 3, self.view.frame.size.height - 40);
    [self.view addSubview:viewContainer];
	
    //Create Parent/Child relationship between these Classes
    [passcodeViewController didMoveToParentViewController:self];
    [self addChildViewController:passcodeViewController];
    [contactViewController didMoveToParentViewController:self];
    [self addChildViewController:contactViewController];
    [voiceViewController didMoveToParentViewController:self];
    [self addChildViewController:voiceViewController];
    
    //Add the subviews to the Scroll view container
    [viewContainer addSubview:contactViewController.view];
    [viewContainer addSubview:passcodeViewController.view];
    [viewContainer addSubview:voiceViewController.view];
    
    // Create Alert View to get user to set a passcode
    alertView = [[UIAlertView alloc]
                 initWithTitle:@"Settings Unlocked"
                 message:kSETTINGS_ALERT_MSG
                 delegate:self
                 cancelButtonTitle:@"Ignore"
                 otherButtonTitles:@"Set Passcode", nil];
    
    //Add the Custom back button to the settings view
    [Appearance addBackButtonToViewController:self];
    
    //Add a lock status icon to navigation bar
    [Appearance updateSettingsLockedIconToViewController:self];
}

//This method is regarding memory warnings and is a standard for all view controller classes
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//This method defines the actions of the segmented control 
-(void)segmentAction
{
    // Depending on what Segmented is selected. It will slide the corresponding view
    // 00 - Contacts
    // 01 - Passcode
    // 02 - Voice
    if (segmentedControl.selectedSegmentIndex == 0)
    {
        [viewContainer setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if (segmentedControl.selectedSegmentIndex == 1)
    {
        [viewContainer setContentOffset:CGPointMake(self.view.frame.size.width * 1, 0) animated:YES];
    }
    else if (segmentedControl.selectedSegmentIndex == 2)
    {
        [viewContainer setContentOffset:CGPointMake(self.view.frame.size.width * 2, 0) animated:YES];
    }
}

// This defines the action that the Custom Back button performs
- (void)dismissView
{
    // If there is no passcode set - prompt the user to set one before exiting the settings panel
    // Else - pop the view
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"PasscodeSet"])
    {
        [alertView show];
    } else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// Define the actions that will occur when user is told they have not set a passcode
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
            // User chooses to set a passcode
            // Show Passcode panel
        case 1:
            segmentedControl.selectedSegmentIndex = 1;
            [self segmentAction];
            break;
            
            // User chooses to ignore the warning
            // Pop the view
        default:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            break;
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
