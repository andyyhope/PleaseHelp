//
//  MainViewController.m
//  DistressProto
//
//  Created by Adrian Jurcevic on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "MainViewController.h"
#import "ContactsViewController.h"
#import "PasscodeViewController.h"
#import "JCMSegmentPageController.h"

@interface MainViewController () <JCMSegmentPageControllerDelegate>

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Need Assistance";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Settings View

- (IBAction)settingsView{
    // Initiate ContactViewController and PasscodeViewController
    ContactsViewController *cvc = [[ContactsViewController alloc]
                                   initWithNibName:@"ContactsViewController" bundle:[NSBundle mainBundle]];
    
    PasscodeViewController *pvc = [[PasscodeViewController alloc] initWithNibName:@"PasscodeViewController" bundle:[NSBundle mainBundle]];
    
    // Add viewcontrollers to array
    NSArray *vcs = @[cvc, pvc];
    
    // Set titles of each segment control
    cvc.title = @"Contacts";
	pvc.title = @"Passcode";
    
    // Push to new view when button is selected
	JCMSegmentPageController *segmentPageController = [[JCMSegmentPageController alloc] init];
    segmentPageController.title = @"Settings";
	segmentPageController.delegate = self;
	segmentPageController.viewControllers = vcs;
    [self.navigationController pushViewController:segmentPageController animated:YES];
}


#pragma mark - Segment Delegates

- (BOOL)segmentPageController:(JCMSegmentPageController *)segmentPageController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index {
	//NSLog(@"segmentPageController %@ shouldSelectViewController %@ at index %u", segmentPageController, viewController, index);
	return YES;
}

- (void)segmentPageController:(JCMSegmentPageController *)segmentPageController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index {
	//NSLog(@"segmentPageController %@ didSelectViewController %@ at index %u", segmentPageController, viewController, index);
}


@end
