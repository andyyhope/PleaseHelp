//
//  ContactViewController.m
//  Please Help
//
//  Created by Adrian Jurcevic & Andyy Hope on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "ContactViewController.h"
#import "AppDelegate.h"
#import "Appearance.h"

//Define the private variables and methods for this class
@interface ContactViewController () <UIActionSheetDelegate>
{
    UILabel *footerNoteLabel;
    UIButton *rearrangeContactsButton;
    UIButton *addContactsButton;
    BOOL isEditing;
}

@property UIButton *addContactButton;
@property NSMutableArray *items;
@property ContactAddViewController *contactAddViewController;

-(void)createContact;

@end


@implementation ContactViewController

@synthesize contactAddViewController = _contactAddViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Load contacts
    [self loadContacts];
    
    // Setup the table
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self createTableHeader];
    [self createTableFooter];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = kVIEW_BACKGROUND_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = kVIEW_BACKGROUND_COLOR;
    self.tableView.layer.borderWidth = 0;
    self.tableView.layer.shadowColor = [UIColor clearColor].CGColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    // Update the Footer to show the right instruction message
    [self updateTableFooterString];
}

- (void)createTableHeader
{
    // Create a Table Header view 
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    tableHeader.backgroundColor = [UIColor clearColor];
    
    // Create Add and Organise Buttons
    addContactsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rearrangeContactsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // Size and Skin Add Button
    addContactsButton.frame = CGRectMake(10,
                                         10,
                                         self.view.frame.size.width / 2 - 15,
                                         50);
    [Appearance applySkinToSettingsButton:addContactsButton withTitle:@"Add Contact"];
    [addContactsButton addTarget:self action:@selector(createContact) forControlEvents:UIControlEventTouchUpInside];
    [tableHeader addSubview:addContactsButton];
    
    // Size and Skin Organise Buttons
    rearrangeContactsButton.frame = CGRectMake(addContactsButton.frame.size.width + addContactsButton.frame.origin.x + 10,
                                               10,
                                               self.view.frame.size.width / 2 - 15,
                                               50);
    [tableHeader addSubview:rearrangeContactsButton];
    [Appearance applySkinToSettingsButton:rearrangeContactsButton withTitle:@"Organise / Delete"];
    [rearrangeContactsButton addTarget:self action:@selector(editItems) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableHeaderView = tableHeader;
}

- (void)createTableFooter {

    // Create a Table Footer view
    UIView *tableFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    
    // Create and Skin Footer Label
    footerNoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, 110)];
    [Appearance applySkinToLocationLabel:footerNoteLabel];
    
    // Update the Footer to show the right instruction message
    [self updateTableFooterString];
    
    [tableFooter addSubview:footerNoteLabel];
    // Assign Table Footer view to table footer
    self.tableView.tableFooterView = tableFooter;
}

- (void)updateTableFooterString
{
    // Table Footer Instruction Label
    // If there are no Contacts - Tell them to add contacts
    // Else if they are rearranging contacts - tell them how to, as well as how to delete
    // Else - Tell them they can rearrange contacts
    
    if ([self.items count] <= 0) {
        footerNoteLabel.text = @"To add contacts to the app, press the 'ADD' button";
    }
    else if (isEditing)
    {
        footerNoteLabel.text = @"Rearrange contacts by dragging the '≡' icon \n\nDelete contacts by pressing the '-' icon\n\nPress 'SAVE' when complete";
    }
    else
    {
        footerNoteLabel.text = @"You can edit a contact's details by tapping on their name. \n\nTo delete or rearrange contacts, \npress the 'ORGANISE' button";
    }
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
    return [self.items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Table row height
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Fetch Item
    ContactItem *item = [self.items objectAtIndex:[indexPath row]];
    
    // Configure Cell
    [cell.textLabel setText:[item name]];
    [cell.detailTextLabel setText:[item phone]];
    [cell.imageView setImage:[UIImage imageNamed:@"transparentSquare.png"]];

    // Created a quick workaround for displaying contact image
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    imgView.backgroundColor=[UIColor clearColor];
    [imgView.layer setCornerRadius:kCELL_CORNER_RADIUS];
    [imgView.layer setMasksToBounds:YES];
    [imgView setImage:[item image]];
    [cell.contentView addSubview:imgView];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Enable user row rearrange
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    // Update rows based on how they were rearranged
    NSString *item = [self.items objectAtIndex:fromIndexPath.row];
    [self.items removeObject:item];
    [self.items insertObject:item atIndex:toIndexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Enable user to delete rows
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete Contacts
        [self.items removeObjectAtIndex:[indexPath row]];
        
        // Update Table View
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // Save Changes
        [self saveContacts];
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Deselect Row
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Create instance of selected Contact
    ContactItem *contact = [self.items objectAtIndex:[indexPath row]];
    
    // Instantiate Edit Contact view
    ContactEditViewController *contactEditViewController = [[ContactEditViewController alloc] initWithContact:contact andDelegate:self];
    contactEditViewController.navigationItem.title = @"Edit Contact";
    
    // Push Edit Contact View onto stack
    [self.parentViewController.navigationController pushViewController:contactEditViewController animated:YES];
}

-(void)createContact
{
    // Add Contact Button was pressed
    // Create Instance of Add Contact View
    ContactAddViewController *contactAddViewController = [[ContactAddViewController alloc] init];
    
    // Create Navigatio Controller and place Add Contact view inside
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:contactAddViewController];
    
    // Set delegates
    [contactAddViewController setDelegate:self];
    
    // Set title
    contactAddViewController.navigationItem.title = @"Add Contact";
    
    // Push Add Contact view onto stack
    [self.parentViewController.navigationController presentViewController:navController animated:YES completion:^{
    }];
}

- (void)editItems
{
    // When Organise button is pressed, it changes its appearance to indicate that the user can revert the table back to normal
    // If editing - Change button title to Organise
    // Else - Change button title to "Save"
    if (isEditing)
    {
        [rearrangeContactsButton setTitle:@"Organise / Delete" forState:UIControlStateNormal];
        [rearrangeContactsButton setBackgroundColor:kVIEW_FOREGROUND_COLOR];
        [rearrangeContactsButton setTitleColor:kCELL_HEADER_FONT_COLOR forState:UIControlStateNormal];
        [self.view addSubview:addContactsButton];
        isEditing = FALSE;
    } else
    {
        [rearrangeContactsButton setTitle:@"Save" forState:UIControlStateNormal];
        [rearrangeContactsButton setBackgroundColor:kVIEW_ALT2_BACKGROUND_COLOR];
        [rearrangeContactsButton setTitleColor:kVIEW_FOREGROUND_COLOR forState:UIControlStateNormal];
        
        // Update the Footer to show the right instruction message
        [self updateTableFooterString];
        [addContactsButton removeFromSuperview];
        isEditing = TRUE;
    }

    // Revert Table back to normal mode
    [self.tableView setEditing:![self.tableView isEditing] animated:YES];
    
    [self updateTableFooterString];

    // Update Contacts
    [self saveContacts];
}

#pragma mark Add name/phone/image Delegate Methods
-(void)controller:(ContactAddViewController *)controller didSaveContactWithName:(NSString *)name andPhone:(NSString *)phone andRelation:(NSString *)relation andImage:(UIImage *)image {
    // Create Item
    ContactItem *item = [ContactItem createUserWithName:name andPhone:phone andRelation:relation andImage:image];

    // Add Item to Data Source
    [self.items addObject:item];
    
    // Add Row to Table View
    [self.tableView beginUpdates];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:([self.items count] - 1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationRight];

    [self.tableView endUpdates];
    
    // Save Items
    [self saveContacts];
    [self updateTableFooterString];
}

#pragma mark -
#pragma mark Edit Item Delegate Methods
- (void)controller:(ContactEditViewController *)controller didUpdateContact:(ContactItem *)contact {
    // Fetch Item
    for (int i = 0; i < [self.items count]; i++) {
        ContactItem *aContact = [self.items objectAtIndex:i];
        
        if ([[aContact uuid] isEqualToString:[contact uuid]]) {
            
            // Update Table View Row
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    // Save Items
    [self saveContacts];
    [self updateTableFooterString];
}

#pragma mark -
#pragma mark Loading
- (void)loadContacts
{
    // Retrieve the path of the contacts
    NSString *filePath = [self pathForItems];
    //NSLog(@"loading");
    //check if the file path exists, if so unarchive it to a local array
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        self.items = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }
    else
    // if not then initialise the local array
    {
        self.items = [NSMutableArray array];
    }
}

- (void)saveContacts
{
    // Retrieve the path of the contacts
    NSString *filePath = [self pathForItems];
    
    // Archive the contacts in mutablearray to the filepath
    [NSKeyedArchiver archiveRootObject:self.items toFile:filePath];
    
    // Post Notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ContactListDidChangeNotification" object:self];
    
    // Update the table footer string
    [self updateTableFooterString];
}

- (NSString *)pathForItems
{
    // Define the path of the list of contacts, list of contacts for user are stored in the items.plist
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths lastObject];
    
    return [documents stringByAppendingPathComponent:@"items.plist"];
}

- (void)updateContactsList
{
    // Update the Contacts
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate retrieveContacts];
    
}

@end
