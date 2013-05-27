//
//  ContactViewController.h
//  DistressProto
//
//  Created by Andyy Hope on 6/05/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ContactEditViewController.h"
#import "ContactAddViewController.h"
#import "AppDelegate.h"
#import "ContactItem.h"
//#import "AppearanceConstants.h"
#import "Appearance.h"

@interface ContactViewController : UITableViewController
<ContactAddViewControllerDelegate, ContactEditViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@end
