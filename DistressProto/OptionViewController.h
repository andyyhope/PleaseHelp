//
//  OptionViewController.h
//  DistressProto
//
//  Created by Andyy Hope on 22/04/13.
//  Copyright (c) 2013 Andyy Hope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>

@interface OptionViewController : UIViewController
<MFMessageComposeViewControllerDelegate>
{
    UIImageView *contactImageView;
    UIImageView *nextContactImageView;
    
    UILabel *locationHeaderLabel;
    UILabel *locationAddressLabel;
    
    UILabel *textPersonLabel;
    UILabel *callNextLabel;
    
    UILabel *contactNameLabel;
    UIImage *contactImage;
    NSString *contactNumber;
    
    UILabel *stopLabel;
    UIButton *stopButton;
    
    UILabel *nextContactNameLabel;
    UIImage *nextContactImage;
    NSString *nextContactNumber;
    
    NSString *userName;
    NSString *userNumber;
    NSString *userLatitude;
    NSString *userLongitude;
    NSString *recipient;
}

@property (nonatomic, retain) UILabel *locationAddressLabel;

@property (nonatomic, retain) UILabel *contactNameLabel;
@property (nonatomic, retain) UIImage *contactImage;
@property (nonatomic, retain) NSString *contactNumber;

@property (nonatomic, retain) UILabel *nextContactNameLabel;
@property (nonatomic, retain) UIImage *nextContactImage;
@property (nonatomic, retain) NSString *nextContactNumber;

@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *userNumber;
@property (nonatomic, retain) NSString *userLatitude;
@property (nonatomic, retain) NSString *userLongitude;
@property (nonatomic, retain) NSString *recipient;

- (void)updateContactImageWith:(UIImage *)newImage andNextContactImageWith:(UIImage *)nextImage;
-(void)updateUserName:(NSString *)name andNumber:(NSString *)number;
-(void)updateLat:(NSString *)latitude andLong:(NSString *)longitude;

@end
