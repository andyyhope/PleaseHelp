//
//  ContactsViewController.m
//  assistance
//
//  Created by Adrian Jurcevic on 26/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactItem.h"



@interface ContactsViewController () <UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate, ABPeoplePickerNavigationControllerDelegate>

@property IBOutlet UIButton *addContactButton;
@property IBOutlet UITableView *tableView;
@property NSMutableArray *items;

//Import Contacts - AddressBookUI
@property NSString *fullName;
@property NSString *lastName;
@property NSString *phoneNumber;
@property NSString *relationship;
@property UIImage *contactImage;

@property (nonatomic, retain) ABPeoplePickerNavigationController *contacts;

@property AddContactViewController *addContactViewController;

-(IBAction)addContact:(id)sender;

@end

@implementation ContactsViewController
@synthesize fullName = _fullName;
@synthesize phoneNumber = _phoneNumber;
@synthesize relationship = _relationship;
@synthesize contactImage = _contactImage;
@synthesize addContactViewController = _addContactViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    self.tableView.layer.borderWidth = 0;
    NSLog(@"Items > %@", self.items);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 -(IBAction)addContact:(id)sender{
     [[[UIActionSheet alloc] initWithTitle:nil
     delegate:self
     cancelButtonTitle:@"Cancel"
     destructiveButtonTitle:nil
     otherButtonTitles:@"Import from Contacts", @"Create New", nil] showInView:self.view];
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
 
 
 -(void)importContact{
     _contacts = [[ABPeoplePickerNavigationController alloc] init];
     
     // Set the delegate.
     [_contacts setPeoplePickerDelegate:self];
     
     // Set the phone property as the one that we want to be displayed in the Address Book.
     
     [_contacts setDisplayedProperties:[NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonPhoneProperty]]];
     
     [self presentModalViewController:_contacts animated:YES];

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
    [_contacts dismissModalViewControllerAnimated:YES];
    
	return NO;
}

// Implement this delegate method to make the Cancel button of the Address Book working.
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
	[_contacts dismissModalViewControllerAnimated:YES];
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person{
    return YES;
}

-(void)importSaveContact{
    
    // Extract User Input
    NSString *name = self.fullName;
    NSString *phone = self.phoneNumber;
    UIImage *image = self.contactImage;

    // Notify Delegate: name and phone
   //[self controller:_addContactViewController didSaveContactWithName:name andPhone:phone];
    [self controller:_addContactViewController didSaveContactWithName:name andPhone:phone andImage:image];

}

 -(void)createNewContact{
     // Initialize Add View Controller
     AddContactViewController *addContactViewController = [[AddContactViewController alloc] init];
     
     // Set Delegate
     [addContactViewController setDelegate:self];
     
     addContactViewController.title = @"ADD CONTACT";
     
     // Present View Controller

     [self presentViewController:addContactViewController animated:YES completion:NULL];

 }


- (IBAction)editItems:(id)sender {
    [self.tableView setEditing:![self.tableView isEditing] animated:YES];
}

 
 #pragma UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // Fetch Item
    ContactItem *item = [self.items objectAtIndex:[indexPath row]];
    
    // Configure Cell
    [cell.textLabel setText:[item name]];
    [cell.detailTextLabel setText:[item phone]];
    [cell.imageView setImage:[item image]];

    
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ContactItem *contact = [self.items objectAtIndex:[indexPath row]];
    
    // Initialize Edit View Controller
    EditContactViewController *editContactViewController = [[EditContactViewController alloc] initWithContact:contact andDelegate:self];
    
    // Push View Controller onto Navigation Stack
    [self.navigationController pushViewController:editContactViewController animated:YES];
    
}

#pragma mark Add name/phone Delegate Methods
- (void)controller:(AddContactViewController *)controller didSaveContactWithName:(NSString *)name andPhone:(NSString *)phone {
    // Create Item
    ContactItem *item = [ContactItem createUserWithName:name andPhone:phone];
    
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
- (void)controller:(AddContactViewController *)controller didSaveContactWithName:(NSString *)name andPhone:(NSString *)phone andImage:(UIImage *)image {
    // Create Item
//    ContactItem *item = [ContactItem createUserWithName:name andPhone:phone];
    ContactItem *item = [ContactItem createUserWithName:name andPhone:phone andImage:image];
    
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
