//
//  ImportInstructionsViewController.m
//  DistressProto
//
//  Created by Andyy Hope on 14/06/13.
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
    
    [Appearance addBackButtonToViewController:self];
    
    self.title = @"Importing Instructions";
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
	self.view.backgroundColor = kVIEW_ALT2_BACKGROUND_COLOR;
    
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
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
@end
