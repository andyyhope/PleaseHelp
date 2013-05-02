//
//  EditContactViewController.h
//  assistance
//
//  Created by Adrian Jurcevic on 9/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactItem;
@protocol EditContactViewControllerDelegate;

@interface EditContactViewController : UIViewController

@property IBOutlet UITextField *nameTextField;
@property IBOutlet UITextField *phoneTextField;
@property IBOutlet UIImageView *imageView;

- (id)initWithContact:(ContactItem *)item andDelegate:(id<EditContactViewControllerDelegate>)delegate;

@end

@protocol EditContactViewControllerDelegate <NSObject>
- (void)controller:(EditContactViewController *)controller didUpdateContact:(ContactItem *)contact;
@end

