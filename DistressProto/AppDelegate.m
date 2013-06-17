//
//  AppDelegate.m
//  Please Help
//
//  Created by Adrian Jurcevic & Andyy Hope on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "AppDelegate.h"
#import "MainContactViewController.h"
#import "CallingViewController.h"
#import "OptionViewController.h"
#import "ContactItem.h"

@implementation AppDelegate

@synthesize userHasStartedCall, currentIndex;
@synthesize contactsArray;
@synthesize latitude, longitude;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Police Info Dictionary
    policeDictionary = [[NSDictionary alloc] initWithObjects:@[@"Police", @"131444", [UIImage imageNamed:@"PoliceImage.png"]]
                                                     forKeys:@[@"name", @"phone", @"image"]];
    // Call Cycle Base Values
    currentIndex = 0;
    phoneHasEnteredBackground = false;

    // Initialize Call Center
    callCenter = [[CTCallCenter alloc] init];
    
    // Initialize Location Objects
    locationManager = [[CLLocationManager alloc]init];
    geocoder = [[CLGeocoder alloc] init];
    [self getCurrentLocation];
    
    // Initialize Views
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    contactsViewController = [[MainContactViewController alloc] init];
    navController = [[UINavigationController alloc] initWithRootViewController:contactsViewController];
    
    // Update UIKit Appearance
    [self updateAppearanceOfUIKit];
    
    // Register Default Keys
    NSDictionary *userDefaultsDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithBool:NO], @"TextToSpeechEnabled",
                                          [NSNumber numberWithBool:NO], @"PasscodeSet",
                                          [NSNumber numberWithBool:NO], @"RecoverSet",
                                          @"", @"RecoverHint",
                                          @"", @"Passcode",
                                          [NSNumber numberWithBool:NO], @"Admin",
                                          nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsDefaults];
    
    // Set up Window
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma Contact List
//This methods retrieves any contacts within the array to display on the main view
-(void)retrieveContacts
{
    NSString *filePath = [self pathForItems];
    
    //check if the file path exists, if so unarchive it to a local array
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        contactsArray = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        NSLog(@"count of objects: %d", [contactsArray count]);
    }
    else
    // if not then initialise the local array
    {
        contactsArray = [NSMutableArray array];
    }
    
    //Present an alert advising there is no contacts
    if ([contactsArray count] == 0)
    {
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

//Define the path of the list of contacts, list of contacts for user are stored in the items.plist
- (NSString *)pathForItems {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths lastObject];
    
    return [documents stringByAppendingPathComponent:@"items.plist"];
}

#pragma Alert View
//This method defines what actions the buttons in the alertview perform
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    // If there are no contacts set up, force the user to settings panel
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
}

#pragma DocumentDirectory
- (NSString *)documentsDirectory {
    // Defines the applications document path - NSDocumentDirectory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths lastObject];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"Application: Will resign active");
    //Perform the callStateIdentifier method
    [self callStateIdentifier];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"Application: Did Enter Background");
    phoneHasEnteredBackground = true;
    //Perform the callStateIdentifier method
    [self callStateIdentifier];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // If the phone is returning from a Phone Call and Call Cycle has started
    // Dismiss the Calling View and show OptionViewController when the App enters foreground
    if (phoneHasEnteredBackground && userHasStartedCall) {
        phoneHasEnteredBackground = false;
        NSLog(@"Phone has just come back to view, with call cycle active");
        [callingViewController dismissViewControllerAnimated:YES completion:^{
            [self presentOptionViewWithIndex:currentIndex];
        }];
    }
    [self callStateIdentifier];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"Application: Did Become Active");
    //Perform the callStateIdentifier method
    [self callStateIdentifier];
    //Gather current location information
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
    NSLog(@"Location: Updating");
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location: Error Message - %@", error);
    // Show an Error alert
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    errorAlert.tag = kALERT_VIEW_ERROR;
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    
    // Reverse Geocode the Lat/Long into an address 
    NSLog(@"Location: Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            
            NSString *subThoroughfare = @"";
            NSString *thoroughfare = @"";
            
            // Stop the label from showing (null) when the application cannot find a nearby street
            if (placemark.subThoroughfare) {
                subThoroughfare = [NSString stringWithFormat:@"%@", placemark.subThoroughfare];
            }
            
            // Stop the label from showing (null) when the application cannot find a nearby street
            if (placemark.thoroughfare) {
                thoroughfare = [NSString stringWithFormat:@"%@\n", placemark.thoroughfare];
            }
            
            // Turn the Lat/Long into a readable address
            locationAddressString = [NSString stringWithFormat:@"%@ %@%@, %@\n%@",
                                     subThoroughfare, thoroughfare,
                                     placemark.locality, placemark.postalCode, 
                                     placemark.administrativeArea];
            
            // Update the view to show address
            contactsViewController.locationAddressString = locationAddressString;
            latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
            longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
            [contactsViewController updateLocationLabel];
            
            // Shorten URL
            UrlShortener *urlShortener = [[UrlShortener alloc] initWithDelegate:self];
            [urlShortener shortenUrl:[[NSString alloc] initWithFormat:@"http://maps.apple.com/maps?q=%@,%@", latitude, longitude] withService:UrlShortenerServiceGoogle];
            
            // Hide Activity Indicator
            [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
    [locationManager stopUpdatingLocation];
}

#pragma URL Shortening
- (void)urlShortenerSucceededWithShortUrl:(NSString *)shortUrl
{
    shortenedURL = shortUrl;
}
- (void)urlShortenerFailedWithError:(NSError *)error
{
    shortenedURL = [[NSString alloc] initWithFormat:kMAPS_URL, latitude, longitude];
}

#pragma Call Cycle
- (void)startCallCycle:(BOOL)boolValue
{
    userHasStartedCall = boolValue;
    [locationManager startUpdatingLocation];
}

-(void)startCallCycleAt:(NSInteger)startIndex withAnimation:(BOOL)animation
{
    // Update Calling View
    currentIndex = startIndex;
    contactItem = [contactsArray objectAtIndex:startIndex];
    callingViewController = [[CallingViewController alloc] init];
    callingViewController.contactName = contactItem.name;
    callingViewController.locationAddressLabel.text = locationAddressString;
    callingViewController.contactNumber = contactItem.phone;
    callingViewController.contactImage = contactItem.image;
    callingViewController.contactRelation = contactItem.relation;
    callingViewController.contactIndex = currentIndex;
    [callingViewController updateContactImageWith:contactItem.image];
//    [textToSpeech doYouWantToCall:contactItem.name];
    // Push Calling View
    [contactsViewController presentViewController:callingViewController animated:animation completion:^{

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                    [NSString stringWithFormat:@"telprompt:%@", contactItem.phone]]];
    }];
}


-(void)presentOptionViewWithIndex:(NSInteger)positionIndex
{
    // Update Option View
    contactItem = [contactsArray objectAtIndex:positionIndex];
    optionViewController = [[OptionViewController alloc] init];
    optionViewController.contactName = contactItem.name;
    optionViewController.contactRelation = contactItem.relation;
    optionViewController.contactImage = contactItem.image;
    optionViewController.locationAddressLabel.text = locationAddressString;
    optionViewController.googleMapsString = shortenedURL;
    NSString *nameString = [[NSString alloc] initWithFormat:@"%@",contactItem.name];
    NSString *numberString = [[NSString alloc] initWithFormat:@"%@", contactItem.phone];
    [optionViewController updateLat:self.latitude andLong:self.longitude];
    [optionViewController updateUserName:nameString andNumber:numberString];
    
    if (positionIndex + 1 < [contactsArray count])
    { 
        // Call cycle still running
        // Show next contact
        ContactItem *nextContactItem = [contactsArray objectAtIndex:positionIndex + 1];
        optionViewController.nextContactName = nextContactItem.name;
        optionViewController.nextContactRelation = nextContactItem.relation;
        optionViewController.nextContactImage = nextContactItem.image;
        
    } else
    { 
        // End of call cycle
        // Show Police option
        optionViewController.nextContactName = [policeDictionary objectForKey:@"name"];
        optionViewController.nextContactImage = [policeDictionary objectForKey:@"image"];
        
    }
    
    // Present OptionView
    [contactsViewController presentViewController:optionViewController animated:NO completion:^{
    }];
}

- (void)callNextPerson
{    
    // Check all contacts have been cycled through
    if ((currentIndex + 1) < [contactsArray count])
    {
        // Contacts remain in cycle.
        currentIndex++;
        [self startCallCycleAt:currentIndex withAnimation:YES];
        NSLog(@"%d", currentIndex);
    } else {
        // No contacts remaining
        // Call the police
        [self callPolice];
    }
}

-(void)callPolice
{
    // This feature will be added once WA Police have approved an appropriate number to call
    UIAlertView *policeAlert = [[UIAlertView alloc]
                               initWithTitle:@"Call Police"
                               message:@"This feature has been disabled for the testing devices."
                               delegate:self
                               cancelButtonTitle:@"OK"
                               otherButtonTitles: nil];
    policeAlert.tag = kALERT_VIEW_POLICE;
    [policeAlert show];
}



- (void)endCallCycle
{
    // Reset to base values
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
    
    // Green tint for Sending Text
    [[UINavigationBar appearanceWhenContainedIn:[MFMessageComposeViewController class], nil] setBackgroundImage:[UIImage imageNamed:kNAVIGATIONBAR_BACKGROUND] forBarMetrics:UIBarMetricsDefault];
}

@end
