//
//  MainContactViewController.h
//  DistressProto
//
//  Created by Andyy Hope on 22/04/13.
//  Copyright (c) 2013 Andyy Hope. All rights reserved.

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "KVPasscodeViewController.h"

@interface MainContactViewController : UITableViewController <KVPasscodeViewControllerDelegate>
{
    NSString *locationAddressString;
    UILabel *locationAddressLabel;
    
    NSInteger cycleStartIndex;
    NSInteger cycleCurrentIndex;
}

@property (nonatomic, retain) NSString *locationAddressString;
@property (nonatomic, readwrite) NSInteger cycleStartIndex;
@property (nonatomic, readwrite) NSInteger cycleCurrentIndex;

- (void)updateLocationLabel;
- (void) pushSettingsView;

@end
