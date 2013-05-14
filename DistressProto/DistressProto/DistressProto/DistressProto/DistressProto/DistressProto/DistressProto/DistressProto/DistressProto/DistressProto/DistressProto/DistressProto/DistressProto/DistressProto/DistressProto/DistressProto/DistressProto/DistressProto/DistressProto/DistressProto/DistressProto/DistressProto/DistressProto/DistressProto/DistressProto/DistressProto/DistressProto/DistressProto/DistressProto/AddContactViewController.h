//
//  AddContactViewController.h
//  assistance
//
//  Created by Adrian Jurcevic on 9/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol AddContactViewControllerDelegate;

@interface AddContactViewController : UIViewController
{
    UIImageView *imageView;
    UIImage *image;
    UIButton *addPhotoButton;
    UITextField *nameTextField;
    UITextField *phoneTextField;
    UITextField *relationTextField;
    
}
@property (weak) id<AddContactViewControllerDelegate> delegate;

@property (nonatomic, retain) UIImage *image;



-(IBAction)addPhoto;

@end

@protocol AddContactViewControllerDelegate <NSObject>
- (void)controller:(AddContactViewController *)controller didSaveContactWithName:(NSString *)name phone:(NSString *)phone relation:(NSString *)relation;
- (void)controller:(AddContactViewController *)controller didSaveContactWithName:(NSString *)name phone:(NSString *)phone relation:(NSString *)relation andImage:(UIImage *)image;

@end
