//
//  ContactViewController.m
//  DistressProto
//
//  Created by Andyy Hope on 6/05/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "ContactViewController.h"
#import "AppDelegate.h"
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
    [self updateTableFooterString];
}

- (void)createTableHeader
{
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    tableHeader.backgroundColor = [UIColor clearColor];
    
    addContactsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rearrangeContactsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    addContactsButton.frame = CGRectMake(10,
                                         10,
                                         self.view.frame.size.width / 2 - 15,
                                         50);
    [Appearance applySkinToSettingsButton:addContactsButton withTitle:@"ADD"];
    [addContactsButton addTarget:self action:@selector(createContact) forControlEvents:UIControlEventTouchUpInside];
    [tableHeader addSubview:addContactsButton];
    
    rearrangeContactsButton.frame = CGRectMake(addContactsButton.frame.size.width + addContactsButton.frame.origin.x + 10,
                                               10,
                                               self.view.frame.size.width / 2 - 15,
                                               50);
    [tableHeader addSubview:rearrangeContactsButton];

    [Appearance applySkinToSettingsButton:rearrangeContactsButton withTitle:@"ORGANISE"];
    [rearrangeContactsButton addTarget:self action:@selector(editItems) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.tableView.tableHeaderView = tableHeader;
}

- (void)createTableFooter {

    UIView *tableFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    
    footerNoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, 110)];
    [Appearance applySkinToLocationLabel:footerNoteLabel];
    
    [self updateTableFooterString];
    
    
    [tableFooter addSubview:footerNoteLabel];
    self.tableView.tableFooterView = tableFooter;
}

- (void)updateTableFooterString
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([appDelegate.contactsArray count] == 0) {
        footerNoteLabel.text = @"To add contacts to the app, press the 'ADD' button";
    } else if (isEditing)
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

    // CBF subclassing UITableViewCell to round corners of thumbnail imae >_>
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
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    NSString *item = [self.items objectAtIndex:fromIndexPath.row];
    [self.items removeObject:item];
    [self.items insertObject:item atIndex:toIndexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
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
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ContactItem *contact = [self.items objectAtIndex:[indexPath row]];
        
    ContactEditViewController *contactEditViewController = [[ContactEditViewController alloc] initWithContact:contact andDelegate:self];
    contactEditViewController.navigationItem.title = @"Edit Contact";
    
    [self.parentViewController.navigationController pushViewController:contactEditViewController animated:YES];
    
}


-(void)createContact
{
    ContactAddViewController *contactAddViewController = [[ContactAddViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:contactAddViewController];
    [contactAddViewController setDelegate:self];
    contactAddViewController.navigationItem.title = @"Add Contact";
    [self.parentViewController.navigationController presentViewController:navController animated:YES completion:^{
    }];
}


- (void)editItems{
    if (isEditing)
    {
        [rearrangeContactsButton setTitle:@"ORGANISE" forState:UIControlStateNormal];
        [rearrangeContactsButton setBackgroundColor:kVIEW_FOREGROUND_COLOR];
        [rearrangeContactsButton setTitleColor:kCELL_HEADER_FONT_COLOR forState:UIControlStateNormal];
        [self.view addSubview:addContactsButton];
        isEditing = FALSE;
    } else
    {
        [rearrangeContactsButton setTitle:@"SAVE" forState:UIControlStateNormal];
        [rearrangeContactsButton setBackgroundColor:kVIEW_ALT2_BACKGROUND_COLOR];
        [rearrangeContactsButton setTitleColor:kVIEW_FOREGROUND_COLOR forState:UIControlStateNormal];
        [addContactsButton removeFromSuperview];
        isEditing = TRUE;
    }
    [self updateTableFooterString];
    [self.tableView setEditing:![self.tableView isEditing] animated:YES];
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
- (void)loadContacts {
    NSString *filePath = [self pathForItems];
    NSLog(@"loading");
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        self.items = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    } else {
        self.items = [NSMutableArray array];
    }
}

- (void)saveContacts {
    NSString *filePath = [self pathForItems];
    [NSKeyedArchiver archiveRootObject:self.items toFile:filePath];
    
    // Post Notification
    // We need this for other views to use * remove comment later
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ContactListDidChangeNotification" object:self];
    
    [self updateTableFooterString];
}

- (NSString *)pathForItems {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths lastObject];
    
    return [documents stringByAppendingPathComponent:@"items.plist"];
}
- (void)updateContactsList
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    [appDelegate retrieveContacts];
}
@end
