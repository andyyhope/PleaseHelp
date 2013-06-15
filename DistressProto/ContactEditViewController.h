//
//  ContactEditViewController.h
//  Please Help
//
//  Created by Adrian Jurcevic & Anddy Hope on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "ContactAddViewController.h"
#import "ContactItem.h"

@class ContactItem;
@protocol ContactEditViewControllerDelegate;

@interface ContactEditViewController : ContactAddViewController

- (id)initWithContact:(ContactItem *)item andDelegate:(id<ContactEditViewControllerDelegate>)delegate;

@end

@protocol ContactEditViewControllerDelegate <NSObject>

- (void)controller:(ContactEditViewController *)controller didUpdateContact:(ContactItem *)contact;

@end