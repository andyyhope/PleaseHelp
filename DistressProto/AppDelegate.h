//
//  AppDelegate.h
//  Please Help
//
//  Created by Adrian Jurcevic & Andyy Hope on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//
//  This is the intial class that runs for an iOS application
//

//Import the relavant Class Header files that are linked to this Class
#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreLocation/CoreLocation.h>
#import "ContactItem.h"
#import "UrlShortener.h"

@class CallingViewController;
@class OptionViewController;
@class MainContactViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate, CLLocationManagerDelegate, UrlShortenerDelegate>
{
    //Define all the variables
    UINavigationController *navController;
    MainContactViewController *contactsViewController;
    CallingViewController *callingViewController;
    OptionViewController *optionViewController;
    ContactItem *contactItem;
    CTCallCenter *callCenter;
    NSMutableArray *contactsArray;
    NSDictionary *policeDictionary;
    NSString *locationAddressString;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString *latitude;
    NSString *longitude;
    NSString *shortenedURL;
    BOOL userHasStartedCall;
    BOOL phoneHasEnteredBackground;
    NSInteger currentIndex;
    NSInteger startingIndex;
}

//Variables are given the 'getter' and 'setter' functionality
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readwrite) BOOL userHasStartedCall;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (nonatomic, readwrite) NSInteger *testInt;
@property (nonatomic, readonly) NSInteger currentIndex;
@property (nonatomic, retain) NSMutableArray *contactsArray;


//Methods defined here allow other classes to utilise them
-(void)getCurrentLocation;
-(void)startCallCycleAt:(NSInteger)startIndex withAnimation:(BOOL)animation;
-(void)callNextPerson;
-(void)presentOptionViewWithIndex:(NSInteger)positionIndex;
-(void)endCallCycle;
-(void)retrieveContacts;

@end
