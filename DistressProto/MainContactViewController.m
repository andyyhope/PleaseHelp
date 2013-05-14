//
//  MainContactViewController.m
//  DistressProto
//
//  Created by Andyy Hope on 22/04/13.
//  Copyright (c) 2013 Andyy Hope. All rights reserved.
//
#import "AppDelegate.h"
#import "AppearanceConstants.h"
#import "ContactsTableViewCell.h"
#import "CallingViewController.h"
#import "OptionViewController.h"
#import "MainContactViewController.h"
#import "ContactsViewController.h"
#import "ContactViewController.h"
#import "PasscodeViewController.h"
#import "JCMSegmentPageController.h"
#import "SettingsViewController.h"

@interface MainContactViewController () <JCMSegmentPageControllerDelegate>

@end

@implementation MainContactViewController

@synthesize locationAddressString;
@synthesize contacts, contactsNames, contactsRelation, contactsImages;
@synthesize cycleCurrentIndex, cycleStartIndex;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        contacts = [[NSArray alloc] init];
        contactsNames = [[NSArray alloc] init];
        contactsRelation = [[NSArray alloc] init];
        contactsImages = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"DISTRESS";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kVIEW_BACKGROUND_COLOR;
    
    [self createSettingsButton];
    
    // create table header
    [self createTableHeader];
    
    /// TESTING
    //[self pushSettingsView];
}

- (void)createSettingsButton
{
    UIView *settingsButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    settingsButtonView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8f];
    settingsButtonView.layer.cornerRadius = kCELL_CORNER_RADIUS;
    
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsButton addTarget:self action:@selector(pushSettingsView) forControlEvents:UIControlEventTouchUpInside];
    settingsButton.frame = settingsButtonView.frame;
    
    UIImageView *settingsButtonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settingsButton"]];
    settingsButtonImageView.frame = CGRectMake(5, 5, 20, 20);
    
    [settingsButtonView addSubview:settingsButton];
    [settingsButtonView addSubview:settingsButtonImageView];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingsButtonView];
    
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void) pushSettingsView
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults boolForKey:@"PasscodeSet"])
    {
        [self displaySettingsController];
    }
    else
    {
        [self enterPasscode];
    }
}

-(void)displaySettingsController{
    SettingsViewController *settingsViewController = [[SettingsViewController alloc]  init];
    
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

-(void)enterPasscode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"Admin"];
    [defaults synchronize];

    KVPasscodeViewController *passcodeController = [[KVPasscodeViewController alloc] init];
    passcodeController.passDelegate = self;
    UINavigationController *passcodeNavigationController = [[UINavigationController alloc] initWithRootViewController:passcodeController];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
    [self.navigationController presentModalViewController:passcodeNavigationController animated:YES];
#else
    [self presentViewController:passcodeNavigationController animated:YES completion:^{
        //code here
    }];
#endif

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [contacts count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ContactsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    
    cell.contactName.text = [contactsNames objectAtIndex:indexPath.row];
    cell.contactRelation.text = [contactsRelation objectAtIndex:indexPath.row];
    cell.imageView.image = [contactsImages objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate startCallCycleAt:indexPath.row];
}
- (void)createTableHeader
{
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    
    UILabel *locationHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    
    locationAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, locationHeaderLabel.frame.size.height + locationHeaderLabel.bounds.origin.y, self.view.frame.size.width, 70)];
    
    locationHeaderLabel.text = @"YOU ARE NEAR";
    locationHeaderLabel.font = kLOCATION_HEADER_FONT;
    locationHeaderLabel.textColor = kLOCATION_HEADER_FONT_COLOR;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
    locationHeaderLabel.textAlignment = UITextAlignmentCenter;
#else
    locationHeaderLabel.textAlignment = NSTextAlignmentCenter;
#endif
    //locationHeaderLabel.textAlignment = NSTextAlignmentCenter;
    locationHeaderLabel.shadowColor = [UIColor colorWithWhite:255.0f alpha:0.2f];
    locationHeaderLabel.shadowOffset = CGSizeMake(1, 1);
    locationHeaderLabel.backgroundColor = [UIColor clearColor];
    
    
    locationAddressLabel.text = @"Loading...";
    locationAddressLabel.font = kLOCATION_TEXT_FONT;
    locationAddressLabel.textColor = kLOCATION_TEXT_FONT_COLOR;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
    locationAddressLabel.textAlignment = UITextAlignmentCenter;
#else
    locationAddressLabel.textAlignment = NSTextAlignmentCenter;
#endif
    //locationAddressLabel.textAlignment = NSTextAlignmentCenter;
    locationAddressLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
    locationAddressLabel.shadowOffset = CGSizeMake(1, 1);
    locationAddressLabel.backgroundColor = [UIColor clearColor];
    locationAddressLabel.numberOfLines = 0;
    
    [tableHeaderView addSubview:locationHeaderLabel];
    [tableHeaderView addSubview:locationAddressLabel];
    
    
    self.tableView.tableHeaderView = tableHeaderView;
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 5)];
    tableFooterView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = tableFooterView;
    
}

- (void)updateLocationLabel
{
    locationAddressLabel.text = locationAddressString;
}

- (void) cycleContacts
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (appDelegate.userHasStartedCall)
    {
        NSLog(@"Call next person");
        [appDelegate callNextPerson];
    } else {
        NSLog(@"Not call next perso");
    }
}

#pragma mark - KVPasscodeViewControllerDelegate

-(void)passcodeController:(KVPasscodeViewController *)controller passcodeEntered:(NSString *)passCode{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [defaults valueForKey:@"Passcode"];

    if ([passCode isEqualToString:string]) {
        //User authorised
        NSLog(@"Authorised");
        [self displaySettingsController];
        [controller dismissModalViewControllerAnimated:YES];
    }
    else
    {
    //Add Number of attempts action here
    }
}

@end

