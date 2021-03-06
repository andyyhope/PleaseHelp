//
//  ImportInstructionsViewController.m
//  Please Help
//
//  Created by Adrian Jurcevic & Andyy Hope on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "ImportInstructionsViewController.h"
#import "Appearance.h"

@interface ImportInstructionsViewController ()
@end

@implementation ImportInstructionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add a Back Button
    [Appearance addBackButtonToViewController:self];
    
    // Set title
    self.title = @"Importing Instructions";
    
    // Skin view
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
	self.view.backgroundColor = kVIEW_ALT2_BACKGROUND_COLOR;
    
    // Create an instruction image and show it
    UIImageView *instructionsImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Instructions.png"]];
    instructionsImage.frame = CGRectMake(0, 0, 320, 415);
    [self.view addSubview:instructionsImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissView
{
    // Pop view from stack
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
