//
//  CallingViewController.h
//  Please Help
//
//  Created by Adrian Jurcevic & Anddy Hope on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CallingViewController : UIViewController
{
    UIImageView *contactImageView;
    UIImage *contactImage;
    UILabel *locationHeaderLabel;
    UILabel *locationAddressLabel;
    UILabel *contactNameLabel;
    UILabel *stopLabel;
    UIButton *stopButton;
    NSString *contactNumber;
    NSString *contactName;
    NSString *contactRelation;
    NSInteger contactIndex;
}

@property (nonatomic, readwrite) NSInteger contactIndex;
@property (nonatomic, retain) UILabel *locationHeaderLabel;
@property (nonatomic, retain) UILabel *locationAddressLabel;
@property (nonatomic, retain) UILabel *contactNameLabel;
@property (nonatomic, retain) NSString *contactName;
@property (nonatomic, retain) UIImage *contactImage;
@property (nonatomic, retain) NSString *contactNumber;
@property (nonatomic, retain) NSString *contactRelation;

- (void)updateContactImageWith:(UIImage *)newImage;

@end
