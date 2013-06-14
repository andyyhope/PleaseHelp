//
//  PasscodeViewController.h
//  Please Help
//
//  Created by Adrian Jurcevic on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KVPasscodeViewController.h"

@interface PasscodeViewController : UIViewController
<KVPasscodeViewControllerDelegate>

-(void)setupButtons;
@end
