//
//  AppDelegate.m
//  DistressProto
//
//  Created by Adrian Jurcevic on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "AppDelegate.h"

#import "MainViewController.h"
#import "ContactItem.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Check for contacts in saved plist
    [self checkContactItems];
    
    // create window and view which is to be the launch view
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.mainViewController];
    self.window.rootViewController = self.navigationController;
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
//            ContactItem *item = [ContactItem createUserWithName:[dictionary objectForKey:@"name"] andPhone:[dictionary objectForKey:@"phone"]];
  //          NSLog(@"items::%@",items);
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
    [self.mainViewController settingsView];
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
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
