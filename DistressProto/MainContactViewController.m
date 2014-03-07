//
//  MainContactViewController.m
//  Please Help
//
//  Created by Adrian Jurcevic & Andyy Hope on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "AppDelegate.h"
#import "ContactsTableViewCell.h"
#import "CallingViewController.h"
#import "OptionViewController.h"
#import "MainContactViewController.h"
#import "ContactViewController.h"
#import "PasscodeSettingsViewController.h"
#import "SettingsViewController.h"
#import "ContactItem.h"
#import "TextToSpeech.h"
#import "SVProgressHUD.h"

//Define the private variables and methods for this class
@interface MainContactViewController () 
{
    int attempt;
    NSString *message;
    UIActivityIndicatorView *_activityIndicator;
    ContactItem *contact;
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
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    // Setup Appearance
    attempt = 0;
    self.navigationItem.title = @"Please Help";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.backgroundColor = kVIEW_BACKGROUND_COLOR;
    
    // Create a Settings button
    [self createSettingsButton];
    
    // Creatr Table Header
    [self createTableHeader];
    
}

-(void)viewWillAppear:(BOOL)animated{
   [self retrieveContacts];
    [SVProgressHUD dismiss];
}

#pragma mark - Settings Button

- (void)createSettingsButton
{
    
    // Turn Box into Button Item
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kSETTING_BUTTON] style:UIBarButtonItemStyleBordered target:self action:@selector(pushSettingsView)];
    barButtonItem.tintColor = [UIColor whiteColor];
    // Place inside Navigation Bar
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void) pushSettingsView
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // If - no Passcode set, show Settings Panel
    // Else - display Passcode Panel
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
    // Push Settings Panel onto view stack
    SettingsViewController *settingsViewController = [[SettingsViewController alloc]  init];
    [self.navigationController pushViewController:settingsViewController animated:YES];
}

-(void)enterPasscode
{
    // Get User Settings for Admin key
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"Admin"];
    [defaults synchronize];

    // Instantiate Passcode Panel
    KVPasscodeViewController *passcodeController = [[KVPasscodeViewController alloc] init];
    passcodeController.passDelegate = self;
    
    // Place it inside a Navigation Controller
    UINavigationController *passcodeNavigationController = [[UINavigationController alloc] initWithRootViewController:passcodeController];
    
    // Present Passcode Panel
    [self presentViewController:passcodeNavigationController animated:YES completion:^{
        //code here
    }];

}

#pragma mark - Retrieve contacts
-(void)retrieveContacts
{
    // Get the Contacts from App Delegate
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate retrieveContacts];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return [appDelegate.contactsArray count];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Table Row Height
    return 120;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ContactsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    // Fetch Item
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ContactItem *cellItem = [appDelegate.contactsArray objectAtIndex:[indexPath row]];
    
    // Configure Cell
    cell.contactName.text = cellItem.name;
    cell.contactRelation.text = cellItem.relation;
    
    
    // If - No Image for Contact, show default placeholder
    // Else - Show the Contact's Image
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
    // If row was pressed
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TextMsgOnly"]) { // Text Message Only
        contact = [self.contactsArray objectAtIndex:indexPath.row];
        [self messageContact];
        

    } else
    {
        AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate startCallCycleAt:indexPath.row withAnimation:YES];
        
    }
    // Start Call Cycle
    
    

}

- (void)createTableHeader
{
    // Create Table Header View
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    
    // Create Location Header Label
    UILabel *locationHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 25)];
    
    // Create Location Label
    locationAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, locationHeaderLabel.frame.size.height + locationHeaderLabel.bounds.origin.y, self.view.frame.size.width, 70)];
    
    // Skin Location Header Label
    locationHeaderLabel.text = @"YOU ARE NEAR";
    locationHeaderLabel.font = kLOCATION_HEADER_FONT;
    locationHeaderLabel.textColor = kLOCATION_HEADER_FONT_COLOR;
    locationHeaderLabel.textAlignment = NSTextAlignmentCenter;
    locationHeaderLabel.backgroundColor = [UIColor clearColor];
    
    // Skin Location Label
    locationAddressLabel.text = @"";
    locationAddressLabel.font = kLOCATION_TEXT_FONT;
    locationAddressLabel.textColor = kLOCATION_TEXT_FONT_COLOR;
    locationAddressLabel.textAlignment = NSTextAlignmentCenter;
    locationAddressLabel.backgroundColor = [UIColor clearColor];
    locationAddressLabel.numberOfLines = 0;
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:locationAddressLabel.frame];
    [_activityIndicator startAnimating];
    [tableHeaderView addSubview:_activityIndicator];
    
    // Place Labels inside view container
    [tableHeaderView addSubview:locationHeaderLabel];
    [tableHeaderView addSubview:locationAddressLabel];
    
    // Make container view the Table Header
    self.tableView.tableHeaderView = tableHeaderView;
    
    // Create a Table Footer to create a separation between last row and bottom of screen
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 5)];
    tableFooterView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = tableFooterView;
}

//Update the users current location text
- (void)updateLocationLabel
{
    [_activityIndicator removeFromSuperview];
    locationAddressLabel.text = locationAddressString;
    
}

//Cycle through the contacts
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
//This method refers to when the user enters any passcode, validation occurs and next steps occur based on passcode being valid or not
-(void)passcodeController:(KVPasscodeViewController *)controller passcodeEntered:(NSString *)passCode{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *string = [defaults valueForKey:@"Passcode"];
    NSString *recoveryString = [defaults valueForKey:@"RecoveryHint"];
    message = [[NSString alloc] initWithFormat:@"Hint: %@", recoveryString];

    if (recoveryString == nil)
    {
        message = kPASSCODE_NOT_SET;
    }

    if ([passCode isEqualToString:string])
    {
        //User authorised
        [self displaySettingsController];
        attempt = 0;
        [controller dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        controller.instructionLabel.text = [NSString
                                            stringWithFormat:@"You entered: '%@'. Please try again.\n\n%@", passCode, message];
        [controller resetWithAnimation:KVPasscodeAnimationStyleInvalid];
        attempt = attempt + 1;
        
        if (attempt >= 3)
        {
            controller.instructionLabel.text = message;
            [self displayAttemptsAlert];
            [self performSelector:@selector(resetAttempt) withObject:nil afterDelay:kTIME_INTERVAL_ATTEMPTS];
        }
    }
}

//Display an alert regarding how many incorrect attempts the user has had
-(void)displayAttemptsAlert
{
     UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:nil message:kINCORRECT_ATTEMPTS_ALERT delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
     [alertError show];
}

//reset the number of attempts
-(void)resetAttempt
{
    attempt = 0;    
}

#pragma mark -
#pragma mark Path to items.plist
//Define the path of the list of contacts, list of contacts for user are stored in the items.plist
- (NSString *)pathForItems {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths lastObject];
    
    return [documents stringByAppendingPathComponent:@"items.plist"];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)messageContact
{
    //Initilise the message composer view
    [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    NSDictionary *titleTextAttr = @{[UIColor greenColor]: NSForegroundColorAttributeName};
    [[UINavigationBar appearance] setTitleTextAttributes:titleTextAttr];
    MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
    
    //Set delegate
    messageComposeViewController.messageComposeDelegate = self;
    
    messageComposeViewController.navigationBar.tintColor = [UIColor redColor];
    //Check if SMS Text can be sent from device
    
    if ([MFMessageComposeViewController canSendText]) {
        //If enabled, clear the recipients
        recipient = nil;
        
        //Add the recipient of the current contact user
        recipient = [[NSString alloc] initWithString:contact.phone];
        [messageComposeViewController setRecipients:@[recipient]];
        
        //Define the message for assistance to the recipient
        NSString *messageString = [[NSString alloc]
                                   initWithFormat:@"Im within the vicinity of:\n%@\n\nShow in Maps:\n%@\n\nLatitude: %@\nLongitude: %@",
                                   locationAddressLabel.text,
                                   self.googleMapsString,
                                   self.userLatitude,
                                   self.userLongitude];
        
        NSString *completeString = [[NSString alloc]
                                    initWithFormat:@"%@ %@",
                                    kSMS_MESSAGE_TEXT,
                                    messageString];
        
        //Add message defined into the body of the SMS Text
        [messageComposeViewController setBody:completeString];
        //Initiate Text to Speech
        TextToSpeech *texToSpeech = [[TextToSpeech alloc] init];
        [texToSpeech textMessageInstructionToContact:contact.name];

        
        //Present the SMS Message Composer View
        [self presentViewController:messageComposeViewController animated:YES completion:^{
            
        }];
        
    } else
    {
        //Display Error
        [SVProgressHUD showErrorWithStatus:@"Cannot send Messages"];
    }
}

//A delegate method when initialising a message composer view
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    // Show HUD based on Message send status
    switch (result) {
        case MessageComposeResultCancelled:
            [SVProgressHUD showErrorWithStatus:@"Message cancelled"];
            break;
        case MessageComposeResultSent:
            [SVProgressHUD showSuccessWithStatus:@"Message sent"];
            break;
        case MessageComposeResultFailed:
            [SVProgressHUD showErrorWithStatus:@"Message failed"];
            break;
        default:
            
            break;
    }
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate updateAppearanceOfUIKit];
    
    // Dismiss Message UI View
    [controller dismissViewControllerAnimated:YES completion:^{


    }];
}

@end
