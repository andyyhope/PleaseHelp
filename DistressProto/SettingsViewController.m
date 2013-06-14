//
//  SettingsViewController.m
//  Please Help
//
//  Created by Andyy Hope & Adrian Jurcevic on 7/05/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

//Import the relavant Class Header files that are linked to this Class
#import "SettingsViewController.h"
#import "ContactViewController.h"
#import "PasscodeViewController.h"
#import "SVProgressHUD.h"

#import "HMSegmentedControl.h"
#import "Appearance.h"

//Define the private variables for this class
@interface SettingsViewController ()
{
    PasscodeViewController *passcodeViewController;
    ContactViewController *contactViewController;
    HMSegmentedControl *segmentedControl;
    
    UIAlertView *alertView;
    UIScrollView *viewContainer;
}
@end

@implementation SettingsViewController

//This is the first method run in this class which is launched when the view loads.
- (void)viewDidLoad
{
    [super viewDidLoad];

    //Remove any ProgressHUD from view
    [SVProgressHUD dismiss];

    //Set the background to the colour defined in the AppearanceConstants.h class
    self.view.backgroundColor = kVIEW_BACKGROUND_COLOR;
    
    //Set the title of the view
    self.navigationItem.title = @"Settings";
    
    //Initialise the two view controller classes - Contacts and Passcode
    contactViewController = [[ContactViewController alloc] initWithStyle:UITableViewStyleGrouped];
    passcodeViewController = [[PasscodeViewController alloc] init];
    
    
    // Segmented Control
    segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"Contacts", @"Passcode"]];
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
    passcodeViewController.view.frame = CGRectMake(320, 0, self.view.frame.size.width, self.view.frame.size.height - 40);
    contactViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 40);
    
    // Create a view container for better UX
    viewContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 40)];
    viewContainer.backgroundColor = [UIColor clearColor];
    viewContainer.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height - 40);
    [self.view addSubview:viewContainer];
	
    //Create Parent/Child relationship between these Classes
    [passcodeViewController didMoveToParentViewController:self];
    [self addChildViewController:passcodeViewController];
    [contactViewController didMoveToParentViewController:self];
    [self addChildViewController:contactViewController];
    
    //Add the subviews to the Scroll view container
    [viewContainer addSubview:contactViewController.view];
    [viewContainer addSubview:passcodeViewController.view];
    
    // Create Alert View to get user to set a passcode
    alertView = [[UIAlertView alloc] initWithTitle:@"Settings Unlocked" message:@"You haven't set a passcode for the settings panel.\n\nIt's highly recommended to set a passcode for the Settings panel." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Set Passcode", @"Proceed Anyway", nil];
    
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
    if (segmentedControl.selectedSegmentIndex == 0)
    {
        [viewContainer setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if (segmentedControl.selectedSegmentIndex == 1)
    {
        [viewContainer setContentOffset:CGPointMake(320, 0) animated:YES];
    }
}

// This defines the action that the Custom Back button performs
- (void)dismissView
{
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"PasscodeSet"])
    {
        [alertView show];
    } else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 2:
            [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"00");
            break;
        case 1:
            NSLog(@"01");
            segmentedControl.selectedSegmentIndex = 1;
            [self segmentAction];
            break;
        default:
            break;
    }
}

@end
