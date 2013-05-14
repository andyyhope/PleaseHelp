//
//  AppDelegate.m
//  DistressProto
//
//  Created by Adrian Jurcevic on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "AppDelegate.h"

#import "ContactItem.h"

#import "MainContactViewController.h"
#import "CallingViewController.h"
#import "OptionViewController.h"

//Constants
#define kHELP_MESSAGE_TEXT @"I'm in the vicinity of %@\n\nLat:%@\nLong%@"

@implementation AppDelegate

@synthesize userHasStartedCall, currentIndex;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Check for contacts in saved plist
    [self checkContactItems];
    
    contacts = @[@"0488544186", @"0421523454",@"0488544186", @"0421523454",@"0488544186", @"0421523454"];
    contactsNames = @[@"Adrian Jurcevic", @"Andyy Hope", @"Marissa Mayer", @"Steve Jobs", @"Bill Gates", @"Steve Ballmer"];
    contactsRelation = @[@"Father", @"Brother", @"Friend", @"Mother", @"Caretaker", @"Sister"];
    contactsImages = @[[UIImage imageNamed:@"Contact01"],
                       [UIImage imageNamed:@"Contact02"],
                       [UIImage imageNamed:@"Contact03"],
                       [UIImage imageNamed:@"Contact04"],
                       [UIImage imageNamed:@"Contact05"],
                       [UIImage imageNamed:@"Contact06"]];
    
    currentIndex = 0;
    phoneHasEnteredBackground = false;
    
    callCenter = [[CTCallCenter alloc] init];
    
    // Init location
    locationManager = [[CLLocationManager alloc]init];
    geocoder = [[CLGeocoder alloc] init];
    [self getCurrentLocation];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    contactsViewController = [[MainContactViewController alloc] init];
    
    contactsViewController.contacts = contacts;
    contactsViewController.contactsNames = contactsNames;
    contactsViewController.contactsRelation = contactsRelation;
    contactsViewController.contactsImages = contactsImages;
    
    callingViewController = [[CallingViewController alloc] init];
    optionViewController = [[OptionViewController alloc] init];
    
    navController = [[UINavigationController alloc] initWithRootViewController:contactsViewController];
    
    [self updateAppearanceOfUIKit];
    
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    return YES;

    
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma Contact List

-(void)checkContactItems{
    NSLog(@"checking");
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([ud boolForKey:@"UserDefaultContacts"]) { // change to NOT to make it only occur once
        
        // Initialise AlertView
        UIAlertView *addContact = [[UIAlertView alloc]
                                   initWithTitle:@"Contacts Empty"
                                   message:@"In case of an emergency, contacts need to be set beforehand"
                                   delegate:self
                                   cancelButtonTitle:nil
                                   otherButtonTitles:@"Add Contacts", nil];
        [addContact show];
        
        // Load contacts from plist
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"contacts" ofType:@"plist"];
        NSArray *contactItems = [NSArray arrayWithContentsOfFile:filePath];
        NSLog(@"array: %@", contactItems);
        
        // Initiate items array
        NSMutableArray *items = [NSMutableArray array];
        
        // Create list of items
        for (int i = 0; i < [contactItems count]; i++) {
            NSDictionary *dictionary = [contactItems objectAtIndex:i];
            
            // Create an item
            // ContactItem *item = [ContactItem createUserWithName:[dictionary objectForKey:@"name"] andPhone:[dictionary objectForKey:@"phone"]];
            // NSLog(@"items::%@",items);
            ContactItem *item = [ContactItem createUserWithName:[dictionary objectForKey:@"name"] andPhone:[dictionary objectForKey:@"phone"] andImage:[dictionary objectForKey:@"image"]];
            NSLog(@"item::%@",item);
            
            // Add item to array
            [items addObject:item];
            NSLog(@"items::%@",items);

        }
        
        // Items directory path
        NSString *itemsPath = [[self documentsDirectory] stringByAppendingPathComponent:@"items.plist"];
        
        // Write to file
        if ([NSKeyedArchiver archiveRootObject:items toFile:itemsPath]) {
            [ud setBool:YES forKey:@"UserDefaultContacts"];
        }
    }
}

#pragma Alert View
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self pushToSettings];
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

#pragma mark Calling Functions

- (void)ctCallStateDidChange:(NSNotification *)notification
{
    NSString *call = [[notification userInfo] objectForKey:@"callState"];
    
    
    if ([call isEqualToString:CTCallStateDisconnected])
    {
        NSLog(@"Call has been disconnected");
        
    }
    else if([call isEqualToString:CTCallStateDialing])
    {
        
        NSLog(@"Call start");
    }
    else if ([call isEqualToString:CTCallStateConnected])
    {
        NSLog(@"Call has just been connected");
    }
    else if([call isEqualToString:CTCallStateIncoming])
    {
        NSLog(@"Call is incoming");
    }
    else
    {
        NSLog(@"None");
    }
}

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
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    CLLocation *currentLocation = newLocation;
    
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            locationAddressString = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                     placemark.subThoroughfare, placemark.thoroughfare,
                                     placemark.postalCode, placemark.locality,
                                     placemark.administrativeArea,
                                     placemark.country];
            contactsViewController.locationAddressString = locationAddressString;
            latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
            [contactsViewController updateLocationLabel];
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
    currentIndex = startIndex;
    callingViewController.contactNameLabel.text = [contactsNames objectAtIndex:startIndex];
    callingViewController.contactImage = [contactsImages objectAtIndex:startIndex];
    callingViewController.locationAddressLabel.text = locationAddressString;
    callingViewController.contactNumber = [contacts objectAtIndex:startIndex];
    [callingViewController updateContactImageWith:[contactsImages objectAtIndex:startIndex]];
    [contactsViewController presentViewController:callingViewController animated:YES completion:^{
        //startingIndex = startIndex;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                    [NSString stringWithFormat:@"telprompt:%@", [contacts objectAtIndex:startIndex]]]];
        
    }];
}

- (void)callNextPerson
{
    // Check all contacts have been cycled through
    if (currentIndex < [contacts count])
    {
        // Contacts remain in cycle.
        NSLog(@"Still contacts left in cycle");
        currentIndex++;
        [self startCallCycleAt:currentIndex];
        NSLog(@"%d", currentIndex);
    } else {
        // No contacts remaining
        // Call the police
        NSLog(@"Call the police");
    }
    
}

-(void)presentOptionViewWithIndex:(NSInteger)positionIndex
{
    optionViewController.contactNameLabel.text = [contactsNames objectAtIndex:positionIndex];
    optionViewController.nextContactNameLabel.text = [contactsNames objectAtIndex:positionIndex + 1];
    optionViewController.locationAddressLabel.text = locationAddressString;
    
    [optionViewController updateContactImageWith:[contactsImages objectAtIndex:positionIndex]
                         andNextContactImageWith:[contactsImages objectAtIndex:positionIndex + 1]];
    
    [contactsViewController presentViewController:optionViewController animated:YES completion:^{
        
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
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NavigationBarBG"] forBarMetrics:UIBarMetricsDefault];
    
    // Navigation Bar Text
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], UITextAttributeTextColor,
      [UIColor colorWithWhite:0 alpha:0.5], UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:22], UITextAttributeFont,
      nil]];
}

@end
