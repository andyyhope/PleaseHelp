//
//  Appearance.h
//  Please Help
//
//  Created by Adrian Jurcevic & Andyy Hope on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//
// This class file defines the skin/theme of the application
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface Appearance : NSObject

+ (void)addStopButtonToView:(UIViewController *)viewController;
+ (void)applySkinToSettingsButton:(UIButton *)button withTitle:(NSString *)title;
+ (void)applySkinToLocationLabel:(UILabel *)label;
+ (void)applySkinToContactFrame:(UIView *)frame withName:(NSString *)name relation:(NSString *)relation  andImage:(UIImage *)image;
+ (void)applySkinToOptionsContactFrame:(UIView *)frame withName:(NSString *)name  relation:(NSString *)relation image:(UIImage *)image andIcon:(UIImage *)icon;
+ (void)applySkinToTextField:(UITextField *)textField withPlaceHolderText:(NSString *)placeHolderText;
+ (void)addBackButtonToViewController:(UIViewController *)viewController;
+ (void)addCancelButtonToViewController:(UIViewController *)viewController;
+ (void)addSaveButtonToViewController:(UIViewController *)viewController;
+ (void)addSaveButtonToEditViewController:(UIViewController *)viewController;
+ (void)updateSettingsLockedIconToViewController:(UIViewController *)viewController;

@end
