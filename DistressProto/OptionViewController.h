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
}

@property (nonatomic, retain) UILabel *locationAddressLabel;

@property (nonatomic, retain) UILabel *contactNameLabel;
@property (nonatomic, retain) UIImage *contactImage;
@property (nonatomic, retain) NSString *contactNumber;

@property (nonatomic, retain) UILabel *nextContactNameLabel;
@property (nonatomic, retain) UIImage *nextContactImage;
@property (nonatomic, retain) NSString *nextContactNumber;

- (void)updateContactImageWith:(UIImage *)newImage andNextContactImageWith:(UIImage *)nextImage;
@end
