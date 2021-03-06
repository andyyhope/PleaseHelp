//
//  AppearanceConstants
//  Please Help
//
//  Created by Adrian Jurcevic & Andyy Hope on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//
// This Class is used to perform custom changes without having to dive into the code and search
//

//#import "Appearance.h"

#define kCELL_HEADER_FONT           [UIFont fontWithName:@"Arial-BoldMT" size:22]
#define kCELL_HEADER_FONT_COLOR     [UIColor colorWithRed:7/255.0f green:55/255.0f blue:87/255.0f alpha:1]

#define kCELL_TEXT_FONT             [UIFont boldSystemFontOfSize:14]
#define kCELL_TEXT_FONT_COLOR       [UIColor grayColor]

#define kLOCATION_HEADER_FONT       [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:18]
#define kLOCATION_HEADER_FONT_COLOR [UIColor colorWithRed:7/255.0f green:55/255.0f blue:87/255.0f alpha:1]

#define kLOCATION_TEXT_FONT         [UIFont boldSystemFontOfSize:16]
#define kLOCATION_TEXT_FONT_COLOR   [UIColor whiteColor];

#define kVIEW_BACKGROUND_COLOR      [UIColor colorWithRed:14/255.0f green:122/255.0f blue:195/255.0f alpha:1]
#define kVIEW_FOREGROUND_COLOR      [UIColor whiteColor]
#define kVIEW_ALT_BACKGROUND_COLOR  [UIColor colorWithRed:65/255.0f green:169/255.0f blue:240/255.0f alpha:1]
#define kVIEW_ALT2_BACKGROUND_COLOR [UIColor colorWithRed:7/255.0f green:55/255.0f blue:87/255.0f alpha:1]
#define kCELL_BACKGROUND_COLOR      [UIColor colorWithHue:192/255.0f saturation:2/255.0f brightness:95/255.0f alpha:0]
#define kSTOP_BACKGROUND_COLOR      [UIColor colorWithRed:193/255.0f green:57/255.0f blue:43/255.0f alpha:1]
#define kVIEW_SHADOW_COLOR          [UIColor blackColor].CGColor
#define kVIEW_SHADOW_OPACITY        0.5f
#define kVIEW_SHADOW_OFFSET         CGSizeMake(0,0)

#define kCELL_CORNER_RADIUS         3
#define SCROLLVIEW_CONTENT_HEIGHT   510

#define kSMS_MESSAGE_TEXT           @"I need help, could you please get in contact with me."
#define kHELP_MESSAGE_TEXT          @"I'm in the vicinity of %@\n\nLat:%@\nLong%@"

#define kIMAGE_PLACEHOLDER          @"defaultProfile"
#define kNAVIGATIONBAR_BACKGROUND   @"NavigationBarBG"
//#define kNAVIGATIONBAR_BACKGROUND_ALT   @"NavigationBarAltBG"
#define kBACK_BUTTON                @"backButton"
#define kCANCEL_BUTTON              @"cancelButton"
#define kSAVE_BUTTON                @"saveButton"
#define kSETTING_BUTTON             @"settingsButton"

#define kCLEAR_PASSCODE             @"Passcode and recovery hint has been cleared"

#define kPASSCODE_NOT_SET           @"You have not set a hint for your passcode."
#define kINCORRECT_ATTEMPTS_ALERT   @"Too many incorrect attempts have been entered.\n\n Please wait until you can try again."
#define kTIME_INTERVAL_ATTEMPTS     10.0

#define kALERT_VIEW_POLICE          1
#define kALERT_VIEW_CONTACTS        2
#define kALERT_VIEW_ERROR           3
#define kMAPS_URL                   @"http://maps.apple.com/maps?q=%@,%@"

#define kINSTRUCTION_SHOW_LIMIT     3

#define kSETTINGS_ALERT_MSG         @"You haven't set a passcode for the settings panel.\n\nIt's highly recommended to set a passcode for the Settings panel."

#define kPASSCODE_INFOLABEL         @"A passcode is recommended to stop a person from entering the settings panel and editing contacts information"
#define kPASSCODE_BUTTON_EDIT       @"Change/Remove Passcode"
#define kPASSCODE_BUTTON_RECOVERY   @"Set A Recovery Hint"
#define kPASSCODE_BUTTON_CHANGE_HINT @"Change Recovery Hint"
#define kPASSCODE_BUTTON_SETPASSCODE @"Set Passcode"

#define kPASSCODE_TEXTFIELD_PLACEHOLDER     @"Change hint for the passcode"
#define kPASSCODE_NOTIFY_PASSCODE   @"You should also set a Recovery Hint in case you forget your passcode"
