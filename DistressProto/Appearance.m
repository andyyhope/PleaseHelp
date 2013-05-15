//
//  Appearance.m
//  DistressProto
//
//  Created by Andyy Hope on 11/05/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "Appearance.h"
#import "AppearanceConstants.h"

#import "AppDelegate.h"

@implementation Appearance
+ (void)addStopButtonToView:(UIViewController *)viewController
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, viewController.view.frame.size.height - 10 - 60, 300, 60);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"STOP" forState:UIControlStateNormal];
    button.titleLabel.font = kCELL_HEADER_FONT;
    button.layer.cornerRadius = kCELL_CORNER_RADIUS;
    [button addTarget:viewController action:@selector(dismissCallingView) forControlEvents:UIControlEventTouchUpInside];
    [viewController.view addSubview:button];
}
+ (void)applySkinToSettingsButton:(UIButton *)button withTitle:(NSString *)title
{
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateSelected];
    [button setTitleColor:kCELL_HEADER_FONT_COLOR forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = kCELL_TEXT_FONT;
    button.titleLabel.textColor = kCELL_HEADER_FONT_COLOR;
    button.layer.cornerRadius = kCELL_CORNER_RADIUS;
}

+ (void)applySkinToLocationLabel:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    
    #if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
    label.textAlignment = UITextAlignmentCenter;
    #else
    label.textAlignment = NSTextAlignmentCenter;
    #endif
}
+ (void)applySkinToContactFrame:(UIView *)frame withName:(NSString *)name andImage:(UIImage *)image
{
    frame.backgroundColor = [UIColor whiteColor];
    frame.layer.cornerRadius = kCELL_CORNER_RADIUS;
    
    UILabel *contactNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 20, 180, 70)];
    contactNameLabel.text = name;
    contactNameLabel.numberOfLines = 1;
    contactNameLabel.backgroundColor = [UIColor clearColor];
    contactNameLabel.font = kCELL_HEADER_FONT;
    contactNameLabel.textColor = kCELL_HEADER_FONT_COLOR;
    #if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
    contactNameLabel.textAlignment = UITextAlignmentCenter;
    #else
    contactNameLabel.textAlignment = NSTextAlignmentCenter;
    #endif
    
    UIImageView *contactImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 90, 90)];
    contactImageView.layer.cornerRadius = kCELL_CORNER_RADIUS;
    contactImageView.layer.masksToBounds = TRUE;
    contactImageView.image = image;
    
    [frame addSubview:contactImageView];
    [frame addSubview:contactNameLabel];
}

+ (void)applySkinToTextField:(UITextField *)textField withPlaceHolderText:(NSString *)placeHolderText
{
    textField.backgroundColor = [UIColor whiteColor];
    textField.borderStyle = UITextBorderStyleLine;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = [UIColor whiteColor].CGColor;
    textField.layer.cornerRadius = 3;
    textField.layer.borderWidth = 1.0f;
    textField.placeholder = placeHolderText;
}
+ (void)addBackButtonToViewController:(UIViewController *)viewController
{
    UIView *backButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    backButtonView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8f];
    backButtonView.layer.cornerRadius = kCELL_CORNER_RADIUS;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:viewController action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = backButtonView.frame;
    
    UIImageView *backButtonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backButton"]];
    backButtonImageView.frame = CGRectMake(5, 5, 20, 20);
    
    [backButtonView addSubview:backButton];
    [backButtonView addSubview:backButtonImageView];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButtonView];
    
    
    viewController.navigationItem.leftBarButtonItem = barButtonItem;
}

+ (void)addCancelButtonToViewController:(UIViewController *)viewController
{
    UIView *cancelButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    cancelButtonView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8f];
    cancelButtonView.layer.cornerRadius = kCELL_CORNER_RADIUS;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton addTarget:viewController action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.frame = cancelButtonView.frame;
    
    UIImageView *cancelButtonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cancelButton"]];
    cancelButtonImageView.frame = CGRectMake(5, 5, 20, 20);
    
    [cancelButtonView addSubview:cancelButton];
    [cancelButtonView addSubview:cancelButtonImageView];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButtonView];
    
    
    viewController.navigationItem.leftBarButtonItem = barButtonItem;
}

+ (void)addSaveButtonToViewController:(UIViewController *)viewController
{
    UIView *saveButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    saveButtonView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8f];
    saveButtonView.layer.cornerRadius = kCELL_CORNER_RADIUS;
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton addTarget:viewController action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    saveButton.frame = saveButtonView.frame;
    
    UIImageView *saveButtonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"saveButton"]];
    saveButtonImageView.frame = CGRectMake(5, 5, 20, 20);
    
    [saveButtonView addSubview:saveButton];
    [saveButtonView addSubview:saveButtonImageView];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButtonView];
    
    
    viewController.navigationItem.rightBarButtonItem = barButtonItem;
}
+ (void)addSaveButtonToEditViewController:(UIViewController *)viewController
{
    UIView *saveButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    saveButtonView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8f];
    saveButtonView.layer.cornerRadius = kCELL_CORNER_RADIUS;
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton addTarget:viewController action:@selector(saveEdit:) forControlEvents:UIControlEventTouchUpInside];
    saveButton.frame = saveButtonView.frame;
    
    UIImageView *saveButtonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"saveButton"]];
    saveButtonImageView.frame = CGRectMake(5, 5, 20, 20);
    
    [saveButtonView addSubview:saveButton];
    [saveButtonView addSubview:saveButtonImageView];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButtonView];
    
    
    viewController.navigationItem.rightBarButtonItem = barButtonItem;
}
@end
