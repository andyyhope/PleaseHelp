//
//  AppDelegate.h
//  DistressProto
//
//  Created by Adrian Jurcevic on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

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
    bool phoneHasEnteredBackground;
    
    
    NSInteger currentIndex;
    
    NSInteger startingIndex;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readwrite) BOOL userHasStartedCall;

@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;

           
@property (nonatomic, readwrite) NSInteger *testInt;
@property (nonatomic, readonly) NSInteger currentIndex;
@property (nonatomic, retain) NSMutableArray *contactsArray;

-(void)getCurrentLocation;
-(void)startCallCycleAt:(NSInteger)startIndex withAnimation:(BOOL)animation;
-(void)callNextPerson;
-(void)presentOptionViewWithIndex:(NSInteger)positionIndex;
-(void)endCallCycle;

-(void)retrieveContacts;

@end
