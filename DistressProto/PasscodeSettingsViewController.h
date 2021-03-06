//
//  PasscodeViewController.h
//  Please Help
//
//  Created by Adrian Jurcevic & Andyy Hope on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//
//  This class file deals with the visual and functionality of the passcode settings view
//

#import <UIKit/UIKit.h>
#import "KVPasscodeViewController.h"

@interface PasscodeSettingsViewController : UIViewController
<KVPasscodeViewControllerDelegate>

// Define public method
-(void)setupButtons;

@end
