//
//  AppDelegate.m
//  DistressProto
//
//  Created by Adrian Jurcevic on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "AppDelegate.h"
//#import "AppearanceConstants.h"

#import "MainContactViewController.h"
#import "CallingViewController.h"
#import "OptionViewController.h"
#import "ContactItem.h"

@implementation AppDelegate

@synthesize userHasStartedCall, currentIndex;
@synthesize contactsArray;
@synthesize latitude, longitude;

#define kALERT_VIEW_POLICE 1
#define kALERT_VIEW_CONTACTS 2
#define kALERT_VIEW_ERROR 3

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Check for contacts in saved plist
    
    policeDictionary = [[NSDictionary alloc] initWithObjects:@[@"Police", @"131444", [UIImage imageNamed:@"PoliceImage.png"]]
                                                     forKeys:@[@"name", @"phone", @"image"]];
   
    
    currentIndex = 0;
    phoneHasEnteredBackground = false;
        
    callCenter = [[CTCallCenter alloc] init];
    
    // Init location
    locationManager = [[CLLocationManager alloc]init];
    geocoder = [[CLGeocoder alloc] init];
    [self getCurrentLocation];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    contactsViewController = [[MainContactViewController alloc] init];
    
    navController = [[UINavigationController alloc] initWithRootViewController:contactsViewController];
    
    [self updateAppearanceOfUIKit];
    //[self retrieveContacts];

    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    return YES;
}
#pragma Contact List

-(void)retrieveContacts
{
    NSString *filePath = [self pathForItems];
    //NSLog(@"loading");
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        contactsArray = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        NSLog(@"count of objects: %d", [contactsArray count]);
    } else {
        contactsArray = [NSMutableArray array];
    }
    
    if ([contactsArray count] == 0){
        UIAlertView *contactAlert = [[UIAlertView alloc]
                                     initWithTitle:@"Contacts Empty"
                                     message:@"This app requires a contact list to be defined before it can be used."
                                     delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:@"Add Contacts", nil];
        contactAlert.tag = kALERT_VIEW_CONTACTS;
        [contactAlert show];
    }

}



- (NSString *)pathForItems {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths lastObject];
    
    return [documents stringByAppendingPathComponent:@"items.plist"];
}


#pragma Alert View
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == kALERT_VIEW_CONTACTS)
    {
        if (buttonIndex == 0) {
            [self pushToSettings];
        }
    } 
}

-(void)pushToSettings{
    // View is pushed to settings view
    [contactsViewController pushSettingsView];
    NSLog(@"Implement push to settings view");
}

#pragma DocumentDirectory
- (NSString *)documentsDirectory {
    // Defines applications document path - NSDocumentDirectory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths lastObject];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"Will resign active");
    [self callStateIdentifier];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"did enter bg");
    phoneHasEnteredBackground = true;
    [self callStateIdentifier];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if (phoneHasEnteredBackground && userHasStartedCall) {
        phoneHasEnteredBackground = false;
        NSLog(@"Phone has just come back to view, with call cycle active");
        [callingViewController dismissViewControllerAnimated:YES completion:^{
            [self presentOptionViewWithIndex:currentIndex];
        }];
    }
    
    NSLog(@"Will enter foreground");
    
    [self callStateIdentifier];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"Did become active");
    [self callStateIdentifier];
    [self getCurrentLocation];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

#pragma mark Calling Functions
- (void)callStateIdentifier
{
    __block id selfDelegate = self;
    [callCenter setCallEventHandler: ^(CTCall *call) {
        if ([call callState] == CTCallStateConnected){
            NSLog(@"CALL STATE: Connected");
        } else if ([call callState] == CTCallStateDialing){
            NSLog(@"CALL STATE: Dialing");
            [selfDelegate startCallCycle:YES];
            
        } else if ([call callState] == CTCallStateDisconnected){
            NSLog(@"CALL STATE: Disconnected");
        } else {
            NSLog(@"CALL STATE: Neither has happenned");
        }
    }];
}


#pragma LOCATION METHODS
- (void) getCurrentLocation
{
    NSLog(@"AppDelegate: getCurrentLocation called");
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    errorAlert.tag = kALERT_VIEW_ERROR;
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    CLLocation *currentLocation = newLocation;
    
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            
            NSString *subThoroughfare = @"";
            NSString *thoroughfare = @"";
            
            if (placemark.subThoroughfare) {
                subThoroughfare = [NSString stringWithFormat:@"%@", placemark.subThoroughfare];
            }
            
            if (placemark.thoroughfare) {
                thoroughfare = [NSString stringWithFormat:@"%@\n", placemark.thoroughfare];
            }
            
            locationAddressString = [NSString stringWithFormat:@"%@ %@%@, %@\n%@",
                                     subThoroughfare, thoroughfare,
                                     placemark.locality, placemark.postalCode, 
                                     placemark.administrativeArea];
            contactsViewController.locationAddressString = locationAddressString;
            latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
            [contactsViewController updateLocationLabel];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
    [locationManager stopUpdatingLocation];
    

}

- (void)startCallCycle:(BOOL)boolValue
{
    userHasStartedCall = boolValue;
    NSLog(@"startCallCycle");
    NSLog(@"%d", currentIndex);
}

-(void)startCallCycleAt:(NSInteger)startIndex
{

    contactItem = [contactsArray objectAtIndex:startIndex];

    callingViewController = [[CallingViewController alloc] init];
     NSLog(@"Start calling cycle\n locationaddressstring: %@", locationAddressString);
    
    currentIndex = startIndex;
    callingViewController.contactName = contactItem.name;
    callingViewController.locationAddressLabel.text = locationAddressString;
    callingViewController.contactNumber = contactItem.phone;
    callingViewController.contactImage = contactItem.image;
    callingViewController.contactRelation = contactItem.relation;
    [callingViewController updateContactImageWith:contactItem.image];
    
    [contactsViewController presentViewController:callingViewController animated:YES completion:^{
        //startingIndex = startIndex;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                    [NSString stringWithFormat:@"telprompt:%@", contactItem.phone]]];
        
    }];

}

- (void)callNextPerson
{
    NSLog(@"Current Index: %d, \ncontactsArray count: %d", currentIndex, [contactsArray count]);
    
    // Check all contacts have been cycled through
    if ((currentIndex + 1) < [contactsArray count])
    {
        // Contacts remain in cycle.
        NSLog(@"Still contacts left in cycle");
        currentIndex++;
        [self startCallCycleAt:currentIndex];
        NSLog(@"%d", currentIndex);
    } else {
        // No contacts remaining
        // Call the police
        [self callPolice];
        NSLog(@"Call the police");
    }
    
}

-(void)callPolice
{
    UIAlertView *policeAlert = [[UIAlertView alloc]
                               initWithTitle:@"Call Police"
                               message:@"This feature has been disabled for the testing devices."
                               delegate:self
                               cancelButtonTitle:@"OK"
                               otherButtonTitles: nil];
    policeAlert.tag = kALERT_VIEW_POLICE;
    [policeAlert show];
}

-(void)presentOptionViewWithIndex:(NSInteger)positionIndex
{
    //this gets called and then crashes
    //because police data is not in the contactsArray 
    
    contactItem = [contactsArray objectAtIndex:positionIndex];
        
    optionViewController = [[OptionViewController alloc] init];
    optionViewController.contactName = contactItem.name;
    optionViewController.contactRelation = contactItem.relation;
    optionViewController.contactImage = contactItem.image;
    optionViewController.locationAddressLabel.text = locationAddressString;
    
    NSString *nameString = [[NSString alloc] initWithFormat:@"%@",contactItem.name];
    NSString *numberString = [[NSString alloc] initWithFormat:@"%@", contactItem.phone];
    [optionViewController updateLat:self.latitude andLong:self.longitude];
    [optionViewController updateUserName:nameString andNumber:numberString];
    
    if (positionIndex + 1 < [contactsArray count])
    { // Call cycle still running
        ContactItem *nextContactItem = [contactsArray objectAtIndex:positionIndex + 1];

        optionViewController.nextContactName = nextContactItem.name;
        optionViewController.nextContactRelation = nextContactItem.relation;
        optionViewController.nextContactImage = nextContactItem.image;
        
    } else
    { // End of call cycle
        
        optionViewController.nextContactName = [policeDictionary objectForKey:@"name"];
        optionViewController.nextContactImage = [policeDictionary objectForKey:@"image"];

    }
    [contactsViewController presentViewController:optionViewController animated:NO completion:^{

    }];
}

- (void)endCallCycle
{
    NSLog(@"Calling cycle has ended");
    userHasStartedCall = false;
    currentIndex = 0;
}
- (void)updateAppearanceOfUIKit
{
    
    // Navigation Bar Background Image
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:kNAVIGATIONBAR_BACKGROUND] forBarMetrics:UIBarMetricsDefault];
    
    // Navigation Bar Text
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], UITextAttributeTextColor,
      [UIColor colorWithWhite:0 alpha:0.2], UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:22], UITextAttributeFont,
      nil]];
    [[UIBarButtonItem appearance] setTintColor:kVIEW_ALT_BACKGROUND_COLOR];
}

@end
