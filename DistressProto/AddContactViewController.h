//
//  AddContactViewController.h
//  assistance
//
//  Created by Adrian Jurcevic on 9/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddContactViewControllerDelegate;

@interface AddContactViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak) id<AddContactViewControllerDelegate> delegate;

@property IBOutlet UITextField *nameTextField;
@property IBOutlet UITextField *phoneTextField;
@property IBOutlet UIButton *addPhotoButton;
@property IBOutlet UIImageView *imageView;

-(IBAction)addPhoto:(id)sender;

@end

@protocol AddContactViewControllerDelegate <NSObject>
- (void)controller:(AddContactViewController *)controller didSaveContactWithName:(NSString *)name andPhone:(NSString *)phone;
- (void)controller:(AddContactViewController *)controller didSaveContactWithName:(NSString *)name andPhone:(NSString *)phone andImage:(UIImage *)image;

@end
