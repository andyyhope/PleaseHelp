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
    NSArray *contacts;
    NSArray *contactsNames;
    NSArray *contactsRelation;
    NSArray *contactsImages;
    NSString *locationAddressString;
    UILabel *locationAddressLabel;
    
    NSInteger cycleStartIndex;
    NSInteger cycleCurrentIndex;
}

@property (nonatomic, retain) NSString *locationAddressString;

@property (nonatomic, retain) NSArray *contacts;
@property (nonatomic, retain) NSArray *contactsNames;
@property (nonatomic, retain) NSArray *contactsRelation;
@property (nonatomic, retain) NSArray *contactsImages;

@property (nonatomic, readwrite) NSInteger cycleStartIndex;
@property (nonatomic, readwrite) NSInteger cycleCurrentIndex;

- (void)updateLocationLabel;
- (void) pushSettingsView;

@end
