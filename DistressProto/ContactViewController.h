//
//  ContactViewController.h
//  Please Help
//
//  Created by Adrian Jurcevic & Andyy Hope on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//
//  This class defines the management of the contacts within the application
//  This is the main page for the settings in regards to the contacts
//

#import <UIKit/UIKit.h>
//#import <QuartzCore/QuartzCore.h>
#import "ContactEditViewController.h"
#import "ContactAddViewController.h"
#import "AppDelegate.h"
#import "ContactItem.h"

@interface ContactViewController : UITableViewController
<ContactAddViewControllerDelegate, ContactEditViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@end
