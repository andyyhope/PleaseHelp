//
//  ContactAddViewController.m
//  DistressProto
//
//  Created by Andyy Hope on 7/05/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "ContactAddViewController.h"
#import "ContactEditViewController.h"
//#import "AppearanceConstants.h"
#import "Appearance.h"
#import "BSKeyboardControls.h"
#import "ContactItem.h"

@interface ContactAddViewController ()
<UIActionSheetDelegate, UIAlertViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, BSKeyboardControlsDelegate, ABPeoplePickerNavigationControllerDelegate>
{
    BSKeyboardControls *aKeyboardControls;
    ContactItem *contact;
    ContactEditViewController *contactEditViewController;
    
    UIButton *addPhotoButton;
    
    UIScrollView *scrollView;
    
    UITextField *activeField;
    BOOL keyboardVisible;
    CGPoint offset;
    CGRect textFieldRect;
}

//Import Contacts - AddressBookUI
@property NSString *fullName;
@property NSString *lastName;
@property NSString *phoneNumber;
@property NSString *relationship;
@property UIImage *contactImage;

@property (nonatomic, retain) ABPeoplePickerNavigationController *contacts;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

-(void)save;

@end

@implementation ContactAddViewController
@synthesize phoneTextField, nameTextField, relationTextField;
@synthesize imageView, image;
@synthesize capImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        image = [[UIImage alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    image = [UIImage imageNamed:kIMAGE_PLACEHOLDER];
    self.view.backgroundColor = kVIEW_BACKGROUND_COLOR;
        
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, SCROLLVIEW_CONTENT_HEIGHT);
    scrollView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:scrollView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 260, 20)];
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 110, 260, 20)];
    UILabel *relationLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 190, 260, 20)];
    UILabel *photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 270, 260, 20)];
    
    nameLabel.font = kLOCATION_TEXT_FONT;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = @"Name";
    
    phoneLabel.font = nameLabel.font;
    phoneLabel.textColor = nameLabel.textColor;
    phoneLabel.backgroundColor = nameLabel.backgroundColor;
    phoneLabel.text = @"Phone";
    
    relationLabel.font = nameLabel.font;
    relationLabel.textColor = nameLabel.textColor;
    relationLabel.backgroundColor = nameLabel.backgroundColor;
    relationLabel.text = @"Relation";
    
    photoLabel.font = nameLabel.font;
    photoLabel.textColor = nameLabel.textColor;
    photoLabel.backgroundColor = nameLabel.backgroundColor;
    photoLabel.text = @"Photo";
    
    [scrollView addSubview:nameLabel];
    [scrollView addSubview:phoneLabel];
    [scrollView addSubview:relationLabel];
    [scrollView addSubview:photoLabel];
    
    UIView *photoView = [[UIView alloc] initWithFrame:CGRectMake(30, 295, 260, 110)];
    photoView.backgroundColor = [UIColor whiteColor];
    photoView.layer.cornerRadius = kCELL_CORNER_RADIUS;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 100, 100)];
    imageView.image = [UIImage imageNamed:kIMAGE_PLACEHOLDER];
    imageView.layer.cornerRadius = kCELL_CORNER_RADIUS;
    
    UILabel *changeImageLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 150, photoView.frame.size.height)];
    changeImageLabel.font = nameLabel.font;
    changeImageLabel.textColor = kCELL_HEADER_FONT_COLOR;
    changeImageLabel.backgroundColor = nameLabel.backgroundColor;
    changeImageLabel.text = @"Change Photo";
    changeImageLabel.textAlignment = NSTextAlignmentCenter;

    [photoView addSubview:changeImageLabel];
    [photoView addSubview:imageView];
    
    [scrollView addSubview:photoView];
    
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoButton.frame = photoView.frame;
    [photoButton addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:photoButton];
    
    nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 55, 260, 30)];
    phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 135, 260, 30)];
    relationTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 215, 260, 30)];

    [Appearance applySkinToTextField:nameTextField withPlaceHolderText:@"Enter name here"]; // maybe change to 'tap here to type name'
    [Appearance applySkinToTextField:phoneTextField withPlaceHolderText:@"Enter phone number here"];
    [Appearance applySkinToTextField:relationTextField withPlaceHolderText:@"Enter the relation here"];
    [phoneTextField setKeyboardType:UIKeyboardTypePhonePad];
    [scrollView addSubview:nameTextField];
    [scrollView addSubview:phoneTextField];
    [scrollView addSubview:relationTextField];
    
    nameTextField.delegate = self;
    phoneTextField.delegate = self;
    relationTextField.delegate = self;
    
    // keyboard controls init
    NSArray *keyboardFields = @[self.nameTextField, self.phoneTextField, self.relationTextField];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:keyboardFields]];
    [self.keyboardControls setDelegate:self];
    [self setupNavBar];
    
}

-(void)setupNavBar
{
    if ([self.navigationItem.title isEqualToString:@"ADD CONTACT"]) {
        // Nav Bar Init
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(save)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
        self.navigationItem.leftBarButtonItem = cancelButton;
        self.navigationItem.rightBarButtonItem = saveButton;
        
        [Appearance addCancelButtonToViewController:self];
        [Appearance addSaveButtonToViewController:self];

        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"Import from Contacts", @"Create New", nil];
        sheet.tag = 200;
        [sheet showInView:self.view];
    }
    else
    {
        //Show no buttons for edit screen
    }
}



- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //setup Nav bar
    //[self setupNavBar];

    // Register for the events
    [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector (keyboardDidShow:)
         name: UIKeyboardDidShowNotification
         object:nil];
    [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector (keyboardDidHide:)
         name: UIKeyboardDidHideNotification
         object:nil];
    
    // Setup content size
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width,
                                        SCROLLVIEW_CONTENT_HEIGHT);
    
    //Initially the keyboard is hidden
    keyboardVisible = NO;

}
-(void) viewWillDisappear:(BOOL)animated {
    // Unregister for keyboard events
    [[NSNotificationCenter defaultCenter]
     removeObserver:self];
}

-(void) keyboardDidShow: (NSNotification *)notif {
    NSLog(@"Keyboard is visible");
}

-(void) keyboardDidHide: (NSNotification *)notif {
    NSLog(@"KeyboardDidHide");
    // Reset the frame scroll view to its original value
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, SCROLLVIEW_CONTENT_HEIGHT);
    
    // Reset the scrollview to previous location
    scrollView.contentOffset = offset;
    
    // Keyboard is no longer visible
    keyboardVisible = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancel
{
    NSLog(@"Dismissing view");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UITextfield Delegate

-(BOOL) textFieldShouldBeginEditing:(UITextField*)textField {
    UIView *keyView = [[UIView alloc] initWithFrame:textField.frame];
    [self keyboardControls:aKeyboardControls selectedField:keyView inDirection:BSKeyboardControlsDirectionNext];
    [self textFieldDidBeginEditing:textField];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.keyboardControls setActiveField:textField];
}

- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, SCROLLVIEW_CONTENT_HEIGHT + field.frame.origin.y);
    CGRect scrollRect = CGRectMake(0, field.frame.origin.y, 320, 380);
    [scrollView scrollRectToVisible:scrollRect animated:YES];

}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [keyboardControls.activeField resignFirstResponder];
}

#pragma mark - Image Compression

- (UIImage *)imageWithImage:(UIImage *)aImage scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [aImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)save
{
    if (nameTextField.text == nil ||
        phoneTextField.text == nil ||
        relationTextField.text == nil ||
        [nameTextField.text isEqualToString:@""] ||
        [phoneTextField.text isEqualToString:@""] ||
        [relationTextField.text isEqualToString:@""]) {
        UIAlertView *errorSaving = [[UIAlertView alloc]
                                    initWithTitle:@"Error"
                                    message:@"Please fill in the Name, Phone and Relation for the contact"
                                    delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles: nil];
        errorSaving.tag = 300;
        [errorSaving show];
    }
    else
    {
    // Extract User Input
    NSString *name = [nameTextField text];
    NSString *phone = [phoneTextField text];
    NSString *relation = [[relationTextField text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    //UIImage *capImage = self.contactImage;
        if (!self.contactImage) {
    NSData *jpgData = UIImageJPEGRepresentation(image, 1);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.jpg"]; //Add the file name
    [jpgData writeToFile:filePath atomically:YES]; //Write the file
    NSData *pData = [NSData dataWithContentsOfFile:filePath];
    capImage = [UIImage imageWithData:pData];
        }
            else
    {
        capImage = self.contactImage;
    }
        
        
    // Notify Delegate: name, phone, relation and image
    [self.delegate controller:self didSaveContactWithName:name andPhone:phone andRelation:relation andImage:capImage];
    
    // Dismiss View Controller
    [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(IBAction)addPhoto{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Choose From Library", nil];
    actionSheet.tag = 100;
    [actionSheet showInView:self.view];
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //[picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
    image = [self imageWithImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"] scaledToSize:CGSizeMake(200, 200)];
	imageView.image = image;
}
#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    
	picker.delegate = self;
    if (actionSheet.tag == 100) {
        
    // 0 = Take Photo
    if (buttonIndex == 0) {
        NSLog(@"Take Photo");
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:picker animated:YES];
    }
    // 1 = Choose From Library
    if (buttonIndex == 1) {
        NSLog(@"Choose From Library");
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:picker animated:YES];
        
    }
    // 2 = Cancel
    if (buttonIndex == 2) {
        NSLog(@"Cancel");
    }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 200) {
    if (buttonIndex == 0) {
        //Import Contact from address book button selected
        [self importContact];
    }
    if (buttonIndex == 1) {
        //Create New Contact button selected
        //[self createNewContact];
    }
        if (buttonIndex == 2) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}


-(void)importContact
{
    _contacts = [[ABPeoplePickerNavigationController alloc] init];
    
    // Set the delegate.
    [_contacts setPeoplePickerDelegate:self];
    
    // Set the phone property as the one that we want to be displayed in the Address Book.
    [_contacts setDisplayedProperties:[NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonPhoneProperty]]];
    
    [self presentViewController:_contacts animated:YES completion:^{
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
    
    self.phoneNumber = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    UIImage *imageImport = [UIImage imageWithData:(__bridge NSData *)ABPersonCopyImageDataWithFormat (person, kABPersonImageFormatOriginalSize)];
    
    //if (!imageImport && !imageView.image) {
    //    self.contactImage = [UIImage imageNamed:kIMAGE_PLACEHOLDER];
    //}
    //else
    //{
    self.imageView.image = imageImport;
    self.contactImage = imageImport;
    //}
                         
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
    UIImage *imageSave = self.contactImage;
    
    // Set the text fields with the imported names
    self.nameTextField.text = name;
    self.phoneTextField.text = phone;
    self.relationTextField.text = relation;
    self.imageView.image = imageSave;
    
    //[self.delegate controller:self didSaveContactWithName:name andPhone:phone andRelation:relation andImage:imageSave];
}

- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}

- (void)dismissView
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        //code
    }];
}

@end
