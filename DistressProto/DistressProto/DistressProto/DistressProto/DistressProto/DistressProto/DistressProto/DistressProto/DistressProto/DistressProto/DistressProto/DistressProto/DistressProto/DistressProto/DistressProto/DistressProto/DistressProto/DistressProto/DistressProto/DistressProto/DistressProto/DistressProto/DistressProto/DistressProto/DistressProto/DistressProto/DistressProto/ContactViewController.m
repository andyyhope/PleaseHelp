//
//  ContactViewController.m
//  DistressProto
//
//  Created by Andyy Hope on 6/05/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "ContactViewController.h"
#import "ContactItem.h"

#import "AppearanceConstants.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ContactViewController () <UIActionSheetDelegate, ABPeoplePickerNavigationControllerDelegate>

@property UIButton *addContactButton;
@property NSMutableArray *items;

//Import Contacts - AddressBookUI
@property NSString *fullName;
@property NSString *lastName;
@property NSString *phoneNumber;
@property NSString *relationship;
@property UIImage *contactImage;

@property (nonatomic, retain) ABPeoplePickerNavigationController *contacts;
@property AddContactViewController *addContactViewController;

- (void)addContact;

@end


@implementation ContactViewController
@synthesize fullName = _fullName;
@synthesize phoneNumber = _phoneNumber;
@synthesize relationship = _relationship;
@synthesize contactImage = _contactImage;
@synthesize addContactViewController = _addContactViewController;

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
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self createTableHeader];
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = kVIEW_BACKGROUND_COLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = kVIEW_BACKGROUND_COLOR;
    self.tableView.layer.borderWidth = 0;
    self.tableView.layer.shadowColor = [UIColor clearColor].CGColor;
}

- (void)createTableHeader
{
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    tableHeader.backgroundColor = [UIColor clearColor];
    
    UIButton *addContactsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *rearrangeContactsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    addContactsButton.frame = CGRectMake(10,
                                         10,
                                         self.view.frame.size.width / 2 - 15,
                                         50);
    
    addContactsButton.backgroundColor = [UIColor whiteColor];
    [addContactsButton setTitle:@"ADD" forState:UIControlStateNormal];
    [addContactsButton setTitle:@"ADD" forState:UIControlStateSelected];
    [addContactsButton setTitleColor:kCELL_HEADER_FONT_COLOR forState:UIControlStateNormal];
    [addContactsButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [addContactsButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    addContactsButton.titleLabel.font = kCELL_TEXT_FONT;
    addContactsButton.titleLabel.textColor = kCELL_HEADER_FONT_COLOR;
    addContactsButton.layer.cornerRadius = kCELL_CORNER_RADIUS;
    [addContactsButton addTarget:self action:@selector(addContact) forControlEvents:UIControlEventTouchUpInside];
    [tableHeader addSubview:addContactsButton];
    
    rearrangeContactsButton.frame = CGRectMake(addContactsButton.frame.size.width + addContactsButton.frame.origin.x + 10,
                                               10,
                                               self.view.frame.size.width / 2 - 15,
                                               50);
    
    rearrangeContactsButton.backgroundColor = [UIColor whiteColor];
    [rearrangeContactsButton setTitle:@"REARRANGE" forState:UIControlStateNormal];
    [rearrangeContactsButton setTitle:@"REARRANGE" forState:UIControlStateSelected];
    [rearrangeContactsButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [rearrangeContactsButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [rearrangeContactsButton setTitleColor:kCELL_HEADER_FONT_COLOR forState:UIControlStateNormal];
    rearrangeContactsButton.titleLabel.font = kCELL_TEXT_FONT;
    rearrangeContactsButton.titleLabel.textColor = kCELL_HEADER_FONT_COLOR;
    rearrangeContactsButton.layer.cornerRadius = kCELL_CORNER_RADIUS;
    [rearrangeContactsButton addTarget:self action:@selector(editItems) forControlEvents:UIControlEventTouchUpInside];
    [tableHeader addSubview:rearrangeContactsButton];
    
    self.tableView.tableHeaderView = tableHeader;
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
    return 40;
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
    [cell.imageView setImage:[item image]];
    
    cell.imageView.frame = CGRectMake(5, 5, 30, 30);
    cell.imageView.layer.cornerRadius = 2;

    
    
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
    
    // Initialize Edit View Controller
    EditContactViewController *editContactViewController = [[EditContactViewController alloc] initWithContact:contact andDelegate:self];
    
    // Push View Controller onto Navigation Stack
    [self.navigationController pushViewController:editContactViewController animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //Import Contact from address book button selected
        [self importContact];
    }
    if (buttonIndex == 1) {
        //Create New Contact button selected
        [self createNewContact];
    }
}

-(void)addContact
{
    [[[UIActionSheet alloc] initWithTitle:nil
                                 delegate:self
                        cancelButtonTitle:@"Cancel"
                   destructiveButtonTitle:nil
                        otherButtonTitles:@"Import from Contacts", @"Create New", nil] showInView:self.view];
}

-(void)createNewContact{
    // Initialize Add View Controller
    AddContactViewController *addContactViewController = [[AddContactViewController alloc] init];
    
    // Set Delegate
    [addContactViewController setDelegate:self];
    
    // Present View Controller
    //[self setModalPresentationStyle:UIModalPresentationFullScreen];
    addContactViewController.navigationItem.title = @"ADD CONTACT";
    [self.navigationController presentViewController:addContactViewController animated:YES completion:NULL];
    
}

-(void)importContact{
    _contacts = [[ABPeoplePickerNavigationController alloc] init];
    
    // Set the delegate.
    [_contacts setPeoplePickerDelegate:self];
    
    // Set the phone property as the one that we want to be displayed in the Address Book.
    
    [_contacts setDisplayedProperties:[NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonPhoneProperty]]];
    

    [self presentViewController:_contacts animated:YES completion:^{
         //cod here
     }];
    
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    NSString *fullName = @"";
    if (firstName != nil) {
        fullName = [fullName stringByAppendingString:firstName];
    }
    if (lastName != nil) {
        fullName = [fullName stringByAppendingString:@" "];
        fullName = [fullName stringByAppendingString:lastName];
    }
    
    self.fullName = fullName;
    
    CFTypeRef multivalue = ABRecordCopyValue(person, property);
    CFIndex index = ABMultiValueGetIndexForIdentifier(multivalue, identifier);
    NSString *phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multivalue, index);
    
    self.phoneNumber = phone;
    
    UIImage *image = [UIImage imageWithData:(__bridge NSData *)ABPersonCopyImageDataWithFormat (person, kABPersonImageFormatOriginalSize)];
    
    self.contactImage = image;
    
    [self importSaveContact];

    [_contacts dismissViewControllerAnimated:YES completion:^{
        // code
    }];
    
	return NO;
}

// Implement this delegate method to make the Cancel button of the Address Book working.
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
	[_contacts dismissViewControllerAnimated:YES completion:^{
        // code
    }];
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    return YES;
}

-(void)importSaveContact{
    
    // Extract User Input
    NSString *name = self.fullName;
    NSString *phone = self.phoneNumber;
    NSString *relation = self.relationship;
    UIImage *image = self.contactImage;
    
    // Notify Delegate: name and phone
    //[self controller:_addContactViewController didSaveContactWithName:name andPhone:phone];
    [self controller:_addContactViewController didSaveContactWithName:name phone:phone relation:relation andImage:image];
    
}

- (void)editItems{
    [self.tableView setEditing:![self.tableView isEditing] animated:YES];
}

#pragma mark Add name/phone Delegate Methods
- (void)controller:(AddContactViewController *)controller didSaveContactWithName:(NSString *)name phone:(NSString *)phone {
    // Create Item
//    ContactItem *item = [ContactItem createUserWithName:name andPhone:phone];
    ContactItem *item = [ContactItem createUserWithName:name phone:phone];
    
    // Add Item to Data Source
    [self.items addObject:item];
    
    // Add Row to Table View
    //needs to change for iOS5 phones
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:([self.items count] - 1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    // Save Items
    [self saveContacts];
}

#pragma mark Add name/phone/image Delegate Methods
- (void)controller:(AddContactViewController *)controller didSaveContactWithName:(NSString *)name phone:(NSString *)phone relation:(NSString *)relation andImage:(UIImage *)image {
    // Create Item
    //    ContactItem *item = [ContactItem createUserWithName:name andPhone:phone];
//    ContactItem *item = [ContactItem createUserWithName:name andPhone:phone andImage:image];
    ContactItem *item = [ContactItem createUserWithName:name phone:phone relation:relation andImage:image];
    // Add Item to Data Source
    [self.items addObject:item];
    
    // Add Row to Table View
    //needs to change for iOS5 phones
    [self.tableView beginUpdates];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:([self.items count] - 1) inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationRight];
    //[self.tableView reloadData];
    [self.tableView endUpdates];
    
    // Save Items
    [self saveContacts];
}

#pragma mark -
#pragma mark Edit Item Delegate Methods
- (void)controller:(EditContactViewController *)controller didUpdateContact:(ContactItem *)contact {
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
    
    // Post Notification // We need this for other views to use * remove comment later
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ContactListDidChangeNotification" object:self];
}

- (NSString *)pathForItems {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths lastObject];
    
    return [documents stringByAppendingPathComponent:@"items.plist"];
}

@end
