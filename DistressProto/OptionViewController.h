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
    UILabel *locationHeaderLabel;
    UILabel *locationAddressLabel;
    
    UILabel *textPersonLabel;
    UILabel *callNextLabel;
    
    UIImage *contactImage;
    NSString *contactName;
    NSString *contactNumber;
    NSString *contactRelation;
    
    UILabel *stopLabel;
    UIButton *stopButton;
    
    UIImage *nextContactImage;
    NSString *nextContactName;
    NSString *nextContactNumber;
    NSString *nextContactRelation;
    
    NSString *userName;
    NSString *userNumber;
    NSString *userLatitude;
    NSString *userLongitude;
    NSString *recipient;
}

@property (nonatomic, retain) UILabel *locationAddressLabel;

@property (nonatomic, retain) UIImage *contactImage;
@property (nonatomic, retain) NSString *contactName;
@property (nonatomic, retain) NSString *contactNumber;
@property (nonatomic, retain) NSString *contactRelation;

@property (nonatomic, retain) UIImage *nextContactImage;
@property (nonatomic, retain) NSString *nextContactName;
@property (nonatomic, retain) NSString *nextContactNumber;
@property (nonatomic, retain) NSString *nextContactRelation;

@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *userNumber;
@property (nonatomic, retain) NSString *userLatitude;
@property (nonatomic, retain) NSString *userLongitude;
@property (nonatomic, retain) NSString *recipient;

-(void)updateUserName:(NSString *)name andNumber:(NSString *)number;
-(void)updateLat:(NSString *)latitude andLong:(NSString *)longitude;

@end
