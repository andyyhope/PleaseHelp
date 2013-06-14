//
//  Appearance.m
//  DistressProto
//
//  Created by Andyy Hope on 11/05/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "Appearance.h"
//#import "AppearanceConstants.h"

//#import "AppDelegate.h"

@implementation Appearance
+ (void)addStopButtonToView:(UIViewController *)viewController
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, viewController.view.frame.size.height - 10 - 60, 300, 60);
    button.backgroundColor = kVIEW_ALT_BACKGROUND_COLOR;
    [button setTitle:@"I'M DONE" forState:UIControlStateNormal];
    button.titleLabel.font = kCELL_HEADER_FONT;
    button.layer.cornerRadius = kCELL_CORNER_RADIUS;
    [button addTarget:viewController action:@selector(dismissCallingView) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *returnIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"returnIcon.png"]];
    returnIcon.frame = CGRectMake(15, 20, 20, 20);
    [button addSubview:returnIcon];
    
    [viewController.view addSubview:button];
}
+ (void)applySkinToSettingsButton:(UIButton *)button withTitle:(NSString *)title
{
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateSelected];
    [button setTitleColor:kCELL_HEADER_FONT_COLOR forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = kCELL_TEXT_FONT;
    button.titleLabel.textColor = kCELL_HEADER_FONT_COLOR;
    button.layer.cornerRadius = kCELL_CORNER_RADIUS;
}

+ (void)applySkinToLocationLabel:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
}
+ (void)applySkinToContactFrame:(UIView *)frame withName:(NSString *)name  relation:(NSString *)relation andImage:(UIImage *)image
{
    frame.backgroundColor = [UIColor whiteColor];
    frame.layer.cornerRadius = kCELL_CORNER_RADIUS;
    
    UILabel *contactNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 180, 60)];
    contactNameLabel.text = name;
    contactNameLabel.numberOfLines = 0;
    contactNameLabel.backgroundColor = [UIColor clearColor];
    contactNameLabel.font = kCELL_HEADER_FONT;
    contactNameLabel.textColor = kCELL_HEADER_FONT_COLOR;
    contactNameLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *contactRelationLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 70, 180, 30)];
    contactRelationLabel.text = relation;
    contactRelationLabel.numberOfLines = 1;
    contactRelationLabel.backgroundColor = [UIColor clearColor];
    contactRelationLabel.font = kCELL_TEXT_FONT;
    contactRelationLabel.textColor = kCELL_TEXT_FONT_COLOR;
    contactRelationLabel.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *contactImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 90, 90)];
    contactImageView.layer.cornerRadius = kCELL_CORNER_RADIUS;
    contactImageView.layer.masksToBounds = TRUE;
    contactImageView.image = image;
    
    UIImageView *actionIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"callIcon.png"]];
    actionIcon.frame = CGRectMake(frame.frame.size.width - 40, frame.frame.size.height - 40, 30, 30);
    [frame addSubview:actionIcon];
    
    [frame addSubview:contactRelationLabel];
    [frame addSubview:contactImageView];
    [frame addSubview:contactNameLabel];
}

+ (void)applySkinToOptionsContactFrame:(UIView *)frame withName:(NSString *)name  relation:(NSString *)relation image:(UIImage *)image andIcon:(UIImage *)icon
{
    frame.backgroundColor = kVIEW_FOREGROUND_COLOR;
    frame.layer.cornerRadius = kCELL_CORNER_RADIUS;
    frame.layer.shadowOpacity = kVIEW_SHADOW_OPACITY;
    frame.layer.shadowOffset = kVIEW_SHADOW_OFFSET;
    frame.layer.shadowColor = kVIEW_SHADOW_COLOR;
    
    UILabel *contactNameLabel = [[UILabel alloc] init];
    contactNameLabel.text = name;
    contactNameLabel.backgroundColor = [UIColor clearColor];
    contactNameLabel.frame = CGRectMake(110, 10, 180, 60);
    contactNameLabel.numberOfLines = 0;
    contactNameLabel.backgroundColor = [UIColor clearColor];
    contactNameLabel.font = kCELL_HEADER_FONT;
    contactNameLabel.textAlignment = NSTextAlignmentCenter;
    contactNameLabel.textColor = kCELL_HEADER_FONT_COLOR;
    
    UILabel *contactRelationLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 70, 180, 30)];
    contactRelationLabel.text = relation;
    contactRelationLabel.numberOfLines = 1;
    contactRelationLabel.backgroundColor = [UIColor clearColor];
    contactRelationLabel.font = kCELL_TEXT_FONT;
    contactRelationLabel.textColor = kCELL_TEXT_FONT_COLOR;
    contactRelationLabel.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *contactImageView = [[UIImageView alloc] initWithImage:image];
    contactImageView.frame = CGRectMake(10, 10, 90, 90);
    contactImageView.layer.cornerRadius = kCELL_CORNER_RADIUS;
    contactImageView.layer.masksToBounds = TRUE;
    
    UIImageView *actionIcon = [[UIImageView alloc] initWithImage:icon];
    actionIcon.frame = CGRectMake(frame.frame.size.width - 40, frame.frame.size.height - 40, 30, 30);
    [frame addSubview:actionIcon];
    
    [frame addSubview:contactRelationLabel];
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
    backButtonView.backgroundColor = kVIEW_FOREGROUND_COLOR;
    backButtonView.layer.cornerRadius = kCELL_CORNER_RADIUS;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton addTarget:viewController action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = backButtonView.frame;
    

    UIImageView *backButtonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kBACK_BUTTON]];
    backButtonImageView.frame = CGRectMake(5, 5, 20, 20);
    
    [backButtonView addSubview:backButton];
    [backButtonView addSubview:backButtonImageView];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButtonView];
    
    
    viewController.navigationItem.leftBarButtonItem = barButtonItem;
}

+ (void)addCancelButtonToViewController:(UIViewController *)viewController
{
    UIView *cancelButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    cancelButtonView.backgroundColor = kVIEW_FOREGROUND_COLOR;
    cancelButtonView.layer.cornerRadius = kCELL_CORNER_RADIUS;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton addTarget:viewController action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.frame = cancelButtonView.frame;
    
    UIImageView *cancelButtonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kCANCEL_BUTTON]];
    cancelButtonImageView.frame = CGRectMake(5, 5, 20, 20);
    
    [cancelButtonView addSubview:cancelButton];
    [cancelButtonView addSubview:cancelButtonImageView];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButtonView];
    
    
    viewController.navigationItem.leftBarButtonItem = barButtonItem;
}

+ (void)addSaveButtonToViewController:(UIViewController *)viewController
{
    UIView *saveButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    saveButtonView.backgroundColor = kVIEW_FOREGROUND_COLOR;
    saveButtonView.layer.cornerRadius = kCELL_CORNER_RADIUS;
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton addTarget:viewController action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    saveButton.frame = saveButtonView.frame;
    
    UIImageView *saveButtonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kSAVE_BUTTON]];
    saveButtonImageView.frame = CGRectMake(5, 5, 20, 20);
    
    [saveButtonView addSubview:saveButton];
    [saveButtonView addSubview:saveButtonImageView];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButtonView];
    
    
    viewController.navigationItem.rightBarButtonItem = barButtonItem;
}
+ (void)addSaveButtonToEditViewController:(UIViewController *)viewController
{
    UIView *saveButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    saveButtonView.backgroundColor = kVIEW_FOREGROUND_COLOR;
    saveButtonView.layer.cornerRadius = kCELL_CORNER_RADIUS;
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton addTarget:viewController action:@selector(saveEdit:) forControlEvents:UIControlEventTouchUpInside];
    saveButton.frame = saveButtonView.frame;
    
    UIImageView *saveButtonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kSAVE_BUTTON]];
    saveButtonImageView.frame = CGRectMake(5, 5, 20, 20);
    
    [saveButtonView addSubview:saveButton];
    [saveButtonView addSubview:saveButtonImageView];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButtonView];
    
    
    viewController.navigationItem.rightBarButtonItem = barButtonItem;
}

+ (void)updateSettingsLockedIconToViewController:(UIViewController *)viewController
{
    UIView *lockButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    lockButtonView.backgroundColor = [UIColor clearColor];
    lockButtonView.layer.cornerRadius = kCELL_CORNER_RADIUS;
    
    UIButton *lockButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    lockButton.frame = lockButtonView.frame;
    
    UIImage* lockIcon;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"PasscodeSet"]) // Settings are Unlocked
    {
        lockIcon = [UIImage imageNamed:@"unlockIconSmall"];
    } else // Settings are Locked
    {
        lockIcon = [UIImage imageNamed:@"lockIconSmall"];
    }
    
    
    UIImageView *lockButtonImageView = [[UIImageView alloc] initWithImage:lockIcon];
    lockButtonImageView.frame = CGRectMake(5, 5, 20, 20);
    
    [lockButtonView addSubview:lockButton];
    [lockButtonView addSubview:lockButtonImageView];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:lockButtonView];
    
    
    viewController.navigationItem.rightBarButtonItem = barButtonItem;
}
@end
