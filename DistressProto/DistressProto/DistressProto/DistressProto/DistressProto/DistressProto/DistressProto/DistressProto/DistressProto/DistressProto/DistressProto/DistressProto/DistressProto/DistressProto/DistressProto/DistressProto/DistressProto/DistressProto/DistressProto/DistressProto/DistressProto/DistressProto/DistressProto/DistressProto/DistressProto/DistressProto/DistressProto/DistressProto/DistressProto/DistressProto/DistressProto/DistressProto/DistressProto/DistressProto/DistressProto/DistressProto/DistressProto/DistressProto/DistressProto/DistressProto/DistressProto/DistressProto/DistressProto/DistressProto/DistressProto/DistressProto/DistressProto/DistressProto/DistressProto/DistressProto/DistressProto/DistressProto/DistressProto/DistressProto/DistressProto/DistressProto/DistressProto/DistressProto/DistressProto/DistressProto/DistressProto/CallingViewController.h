//
//  CallingViewController.h
//  PhoneCycleTest
//
//  Created by Andyy Hope on 22/04/13.
//  Copyright (c) 2013 Andyy Hope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CallingViewController : UIViewController
{
    UIImageView *contactImageView;
    
    UILabel *locationHeaderLabel;
    UILabel *locationAddressLabel;
    
    UILabel *contactNameLabel;
    UIImage *contactImage;
    
    UILabel *stopLabel;
    UIButton *stopButton;
    
    NSString *contactNumber;
}

@property (nonatomic, retain) UILabel *locationHeaderLabel;
@property (nonatomic, retain) UILabel *locationAddressLabel;
@property (nonatomic, retain) UILabel *contactNameLabel;
@property (nonatomic, retain) UIImage *contactImage;
@property (nonatomic, retain) NSString *contactNumber;

- (void)updateContactImageWith:(UIImage *)newImage;
@end
