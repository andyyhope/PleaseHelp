//
//  MainContactViewController.m
//  DistressProto
//
//  Created by Andyy Hope on 22/04/13.
//  Copyright (c) 2013 Andyy Hope. All rights reserved.
//
#import "AppDelegate.h"
#import "ContactsTableViewCell.h"
#import "CallingViewController.h"
#import "OptionViewController.h"
#import "MainContactViewController.h"
#import "ContactViewController.h"
#import "PasscodeViewController.h"
#import "SettingsViewController.h"
#import "ContactItem.h"
#import "SVProgressHUD.h"

@interface MainContactViewController () 
{
    int attempt;
    NSTimer *theTimer;
    NSString *message;
}

@property NSMutableArray *items;

@end

@implementation MainContactViewController

@synthesize locationAddressString;
@synthesize cycleCurrentIndex, cycleStartIndex;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     attempt = 0;

    self.navigationItem.title = @"Please Help";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kVIEW_BACKGROUND_COLOR;
    
    [self createSettingsButton];
    
    // create table header
    [self createTableHeader];
    
}

-(void)viewWillAppear:(BOOL)animated{
   [self retrieveContacts];
}

#pragma mark - Settings Button

- (void)createSettingsButton
{
    UIView *settingsButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    settingsButtonView.backgroundColor = kVIEW_FOREGROUND_COLOR;
    settingsButtonView.layer.cornerRadius = kCELL_CORNER_RADIUS;
    
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsButton addTarget:self action:@selector(pushSettingsView) forControlEvents:UIControlEventTouchUpInside];
    settingsButton.frame = settingsButtonView.frame;
    

    UIImageView *settingsButtonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kSETTING_BUTTON]];
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
    
    [self presentViewController:passcodeNavigationController animated:YES completion:^{
        //code here
    }];

}

#pragma mark - Retrieve contacts
-(void)retrieveContacts
{
    
    /*NSString *filePath = [self pathForItems];
    //NSLog(@"loading");
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        self.items = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    } else {
        self.items = [NSMutableArray array];
    }*/
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate retrieveContacts];
    
    [self.tableView reloadData];
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
    //return [contacts count];
//    return [self.items count];
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return [appDelegate.contactsArray count];
    
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
    
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ContactItem *cellItem = [appDelegate.contactsArray objectAtIndex:[indexPath row]];

    // Fetch Item
   //ContactItem *cellItem = [self.items objectAtIndex:[indexPath row]];
    
    // Configure Cell
    cell.contactName.text = cellItem.name;
    cell.contactRelation.text = cellItem.relation;
    
    if (cellItem.image == nil)
    {
        cell.imageView.image = [UIImage imageNamed:kIMAGE_PLACEHOLDER];
    }
    else
    {
        cell.imageView.image = cellItem.image;
    }
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
    
    UILabel *locationHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 25)];
    
    locationAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, locationHeaderLabel.frame.size.height + locationHeaderLabel.bounds.origin.y, self.view.frame.size.width, 70)];
    
    locationHeaderLabel.text = @"YOU ARE NEAR";
    locationHeaderLabel.font = kLOCATION_HEADER_FONT;
    locationHeaderLabel.textColor = kLOCATION_HEADER_FONT_COLOR;
    locationHeaderLabel.textAlignment = NSTextAlignmentCenter;
    locationHeaderLabel.shadowColor = [UIColor colorWithWhite:255.0f alpha:0.2f];
    locationHeaderLabel.shadowOffset = CGSizeMake(1, 1);
    locationHeaderLabel.backgroundColor = [UIColor clearColor];
    
    
    locationAddressLabel.text = @"Loading...";
    locationAddressLabel.font = kLOCATION_TEXT_FONT;
    locationAddressLabel.textColor = kLOCATION_TEXT_FONT_COLOR;
    locationAddressLabel.textAlignment = NSTextAlignmentCenter;
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
        NSLog(@"Not call next person");
    }
}

#pragma mark - KVPasscodeViewControllerDelegate

-(void)passcodeController:(KVPasscodeViewController *)controller passcodeEntered:(NSString *)passCode{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [defaults valueForKey:@"Passcode"];
    NSString *recoveryString = [defaults valueForKey:@"RecoveryHint"];
    message = [[NSString alloc] initWithFormat:@"Your recovery hint is: %@", recoveryString];

    if (recoveryString == nil) {
        message = kPASSCODE_NOT_SET;
    }

    if ([passCode isEqualToString:string]) {
        //User authorised
        [self displaySettingsController];
        [controller resetWithAnimation:KVPasscodeAnimationStyleNone];
        attempt = 0;
        //[controller dismissModalViewControllerAnimated:YES];
        [controller dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        controller.instructionLabel.text = [NSString stringWithFormat:NSLocalizedString(@"You entered: '%@'. Please try again.\n\n%@", @""), passCode, message];
        [controller resetWithAnimation:KVPasscodeAnimationStyleInvalid];
        attempt = attempt + 1;
        
        if (attempt >= 3) {
            controller.instructionLabel.text = nil; 
            [SVProgressHUD showWithStatus:@"Please wait"];
            [self incorrectAttempts];
        }
    }
    //NSLog(@"attempt: %d", attempt);
}

-(void)incorrectAttempts
{
    UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:nil message:kINCORRECT_ATTEMPTS_ALERT delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertError show];
    
    theTimer = [NSTimer scheduledTimerWithTimeInterval:kTIME_INTERVAL_ATTEMPTS target:self selector:@selector(resetAttempt) userInfo:nil repeats:NO];
}

-(void)resetAttempt
{
    NSString *resetMessage = [[NSString alloc] initWithFormat:@"Please try again.\n\n%@",message];
    [SVProgressHUD showImage:nil status:resetMessage];
    attempt = 0;
    //NSLog(@"done");
}


#pragma mark -
#pragma mark Path to items.plist

- (NSString *)pathForItems {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths lastObject];
    
    return [documents stringByAppendingPathComponent:@"items.plist"];
}


@end

