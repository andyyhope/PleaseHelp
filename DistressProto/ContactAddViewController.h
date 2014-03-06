//
//  ContactAddViewController.h
//  Please Help
//
//  Created by Adrian Jurcevic & Andyy Hope on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//
//  This class file refers to all the methods needed to add a contact into the plist
//  Defines the importing a contact, adding new, import phtoto, take a new photo and all validation regarding contacts
//

#import <UIKit/UIKit.h>
//#import <QuartzCore/QuartzCore.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@protocol ContactAddViewControllerDelegate;

@interface ContactAddViewController : UIViewController
{
    UIImage *image;
    UIImageView *imageView;
    UITextField *nameTextField;
    UITextField *phoneTextField;
    UITextField *relationTextField;
}

@property (weak) id<ContactAddViewControllerDelegate> delegate;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImage *capImage;
@property (nonatomic, retain) UITextField *nameTextField;
@property (nonatomic, retain) UITextField *relationTextField;
@property (nonatomic, retain) UITextField *phoneTextField;
@property (nonatomic, retain) UIImageView *imageView;

@end

//The delegate and its methods
@protocol ContactAddViewControllerDelegate <NSObject>

- (void)controller:(ContactAddViewController *)controller didSaveContactWithName:(NSString *)name andPhone:(NSString *)phone andRelation:(NSString *)relation andImage:(UIImage *)image;

@end
