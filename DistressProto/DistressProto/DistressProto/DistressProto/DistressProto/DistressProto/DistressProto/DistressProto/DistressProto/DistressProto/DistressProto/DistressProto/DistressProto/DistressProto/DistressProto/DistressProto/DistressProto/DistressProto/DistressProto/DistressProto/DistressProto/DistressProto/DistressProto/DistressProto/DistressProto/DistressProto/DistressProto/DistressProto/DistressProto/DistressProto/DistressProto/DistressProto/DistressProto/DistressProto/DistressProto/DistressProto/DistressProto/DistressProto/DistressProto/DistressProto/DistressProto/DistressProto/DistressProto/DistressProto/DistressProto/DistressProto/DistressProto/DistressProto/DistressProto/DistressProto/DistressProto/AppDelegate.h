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

@class CallingViewController;
@class OptionViewController;
@class MainContactViewController;


@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate, CLLocationManagerDelegate>
{
    UINavigationController *navController;
    MainContactViewController *contactsViewController;
    CallingViewController *callingViewController;
    OptionViewController *optionViewController;
    CTCallCenter *callCenter;
    
    NSArray *contacts;
    NSArray *contactsNames;
    NSArray *contactsRelation;
    NSArray *contactsImages;
    NSString *locationAddressString;
    
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString *latitude;
    NSString *longitude;
    
    BOOL userHasStartedCall;
    bool phoneHasEnteredBackground;
    
    
    NSInteger currentIndex;
    
    NSInteger startingIndex;
}

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, readwrite) BOOL userHasStartedCall;

@property (nonatomic, readwrite) NSInteger *testInt;
@property (nonatomic, readonly) NSInteger currentIndex;

-(void)startCallCycleAt:(NSInteger)startIndex;
-(void)callNextPerson;
-(void)presentOptionViewWithIndex:(NSInteger)positionIndex;
-(void)endCallCycle;

@end
