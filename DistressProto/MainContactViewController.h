//
//  MainContactViewController.h
//  Please Help
//
//  Created by Adrian Jurcevic & Andyy Hope on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//
//  This class file refers to the initial main screen that the user views when launching the application
//  It is the view that the user will utilise mostly with (e.g. the user sees the list of contacts)
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "KVPasscodeViewController.h"
#import <MessageUI/MessageUI.h>

@interface MainContactViewController : UITableViewController <KVPasscodeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
{
    NSString *locationAddressString;
    UILabel *locationAddressLabel;
    NSInteger cycleStartIndex;
    NSInteger cycleCurrentIndex;
    
    NSString *recipient;
    
}

@property (nonatomic, retain) NSString *locationAddressString;
@property (nonatomic, readwrite) NSInteger cycleStartIndex;
@property (nonatomic, readwrite) NSInteger cycleCurrentIndex;

@property (nonatomic, retain) NSString *userNumber;
@property (nonatomic, retain) NSString *googleMapsString;
@property (nonatomic, retain) NSString *userLongitude;
@property (nonatomic, retain) NSString *userLatitude;
@property (nonatomic, retain) NSMutableArray *contactsArray;


- (void)updateLocationLabel;
- (void) pushSettingsView;

@end
