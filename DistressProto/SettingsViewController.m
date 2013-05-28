//
//  SettingsViewController.m
//  Please Help
//
//  Created by Andyy Hope & Adrian Jurcevic on 7/05/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

//Import the relavant Class Header files that are linked to this Class
#import "SVSegmentedControl.h"
#import "SettingsViewController.h"
#import "ContactViewController.h"
#import "PasscodeViewController.h"

//Define the private variables for this class
@interface SettingsViewController ()
{
    PasscodeViewController *passcodeViewController;
    ContactViewController *contactViewController;
    SVSegmentedControl *segmentedControl;
}
@end

@implementation SettingsViewController

//This is the first method run in this class which is launched when the view loads.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set the background to the colour defined in the AppearanceConstants.h class
    self.view.backgroundColor = kVIEW_BACKGROUND_COLOR;
    
    //Set the title of the view
    self.navigationItem.title = @"Settings";
    
    //Initialise the two view controller classes - Contacts and Passcode
    contactViewController = [[ContactViewController alloc] initWithStyle:UITableViewStyleGrouped];
    passcodeViewController = [[PasscodeViewController alloc] init];

    //Create the segmented control to switch the views on screen
    segmentedControl = [[SVSegmentedControl alloc] initWithFrame:CGRectMake(-5, -5, 330, 45)];
    [segmentedControl addTarget:self action:@selector(segmentAction) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setSectionTitles:@[@"Contacts", @"Passcode"]];
    [segmentedControl setBackgroundColor:kVIEW_BACKGROUND_COLOR];
    [segmentedControl setBackgroundTintColor:[UIColor clearColor]];
    [segmentedControl setInnerShadowColor:[UIColor clearColor]];
    [segmentedControl setTextShadowColor:[UIColor colorWithWhite:0.0f alpha:0.3f]];
    [segmentedControl setCornerRadius:kCELL_CORNER_RADIUS];
    [segmentedControl setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [segmentedControl setBackgroundTintColor:[UIColor clearColor]];
    [segmentedControl setFont:[UIFont boldSystemFontOfSize:12]];
    [self.view addSubview:segmentedControl];
    
    //Set the size of these views so they fit within the bounds of the current SettingsViewController Class
    passcodeViewController.view.frame = CGRectMake(0, 39, self.view.frame.size.width, self.view.frame.size.height - 40);
    contactViewController.view.frame = passcodeViewController.view.frame;
	
    //Create Parent/Child relationship between these Classes
    [passcodeViewController didMoveToParentViewController:self];
    [self addChildViewController:passcodeViewController];
    [contactViewController didMoveToParentViewController:self];
    [self addChildViewController:contactViewController];
    
    //Set ContactViewController to be the main view that displays on launch
    [self.view addSubview:contactViewController.view];
    
    //Add the Custom back button to the settings view
    [Appearance addBackButtonToViewController:self];
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
        // ContactViewController is displayed to the user and removes PasscodeViewController from view
        [self.view addSubview:contactViewController.view];
        [passcodeViewController.view removeFromSuperview];
    }
    else if (segmentedControl.selectedSegmentIndex == 1)
    {
        // PasscodeViewController is displayed to the user and removes ContactViewController from view
        [self.view addSubview:passcodeViewController.view];
        [contactViewController.view removeFromSuperview];
    }
}

// This defines the action that the Custom Back button performs
- (void)dismissView
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
