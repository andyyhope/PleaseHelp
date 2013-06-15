//
//  ContactViewController.h
//  Please Help
//
//  Created by Adrian Jurcevic & Anddy Hope on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ContactEditViewController.h"
#import "ContactAddViewController.h"
#import "AppDelegate.h"
#import "ContactItem.h"

@interface ContactViewController : UITableViewController
<ContactAddViewControllerDelegate, ContactEditViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@end
