//
//  ContactAddViewController.h
//  DistressProto
//
//  Created by Andyy Hope on 7/05/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
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

@protocol ContactAddViewControllerDelegate <NSObject>

//- (void)controller:(ContactAddViewController *)controller didSaveContactWithName:(NSString *)name andPhone:(NSString *)phone andRelation:(NSString *)relation;
- (void)controller:(ContactAddViewController *)controller didSaveContactWithName:(NSString *)name andPhone:(NSString *)phone andRelation:(NSString *)relation andImage:(UIImage *)image;

@end
