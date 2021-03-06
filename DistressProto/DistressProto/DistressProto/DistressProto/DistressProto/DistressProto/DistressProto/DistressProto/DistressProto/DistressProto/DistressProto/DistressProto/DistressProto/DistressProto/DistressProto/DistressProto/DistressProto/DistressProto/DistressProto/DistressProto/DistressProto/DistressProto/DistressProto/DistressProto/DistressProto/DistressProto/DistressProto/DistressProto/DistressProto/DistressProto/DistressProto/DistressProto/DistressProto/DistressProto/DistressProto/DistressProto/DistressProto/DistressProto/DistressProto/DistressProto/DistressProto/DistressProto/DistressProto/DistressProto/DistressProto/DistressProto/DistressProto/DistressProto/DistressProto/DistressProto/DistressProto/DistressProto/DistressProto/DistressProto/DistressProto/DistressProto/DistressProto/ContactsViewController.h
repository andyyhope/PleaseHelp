//
//  ContactsViewController.h
//  assistance
//
//  Created by Adrian Jurcevic on 26/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <QuartzCore/QuartzCore.h>
#import "AddContactViewController.h"
#import "EditContactViewController.h"

@interface ContactsViewController : UIViewController <AddContactViewControllerDelegate, EditContactViewControllerDelegate>


@end
