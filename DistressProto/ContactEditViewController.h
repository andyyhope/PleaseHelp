//
//  ContactEditViewController.h
//  Please Help
//
//  Created by Adrian Jurcevic & Andyy Hope on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//
//  This class defines the features for editing a contact
//  It incorporates the AddViewController
//

#import "ContactAddViewController.h"
#import "ContactItem.h"

@class ContactItem;

// Define the Delegate
@protocol ContactEditViewControllerDelegate;

// This Class is object of ContactAddViewController
@interface ContactEditViewController : ContactAddViewController

- (id)initWithContact:(ContactItem *)item andDelegate:(id<ContactEditViewControllerDelegate>)delegate;

@end

//The delegate and its methods
@protocol ContactEditViewControllerDelegate <NSObject>

- (void)controller:(ContactEditViewController *)controller didUpdateContact:(ContactItem *)contact;

@end