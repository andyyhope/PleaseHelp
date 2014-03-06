//
//  ContactAddViewController.m
//  Please Help
//
//  Created by Adrian Jurcevic & Andyy Hope on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

//Import the relavant Class Header files that are linked to this Class
#import "ContactAddViewController.h"
#import "ContactEditViewController.h"
#import "BSKeyboardControls.h"
#import "ContactItem.h"
#import "SVProgressHUD.h"
#import "ImportInstructionsViewController.h"
#import "Appearance.h"

//Define the private variables and methods for this class
@interface ContactAddViewController ()
<UIActionSheetDelegate, UIAlertViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, BSKeyboardControlsDelegate, ABPeoplePickerNavigationControllerDelegate, UIAlertViewDelegate>
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
    NSUserDefaults *defaults;
}

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
    if (self)
    {
        //Initilise UIImage variable
        image = [[UIImage alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Initialise NSUserDefaults
    defaults = [NSUserDefaults standardUserDefaults];
    
    //If there is no value for InstructionShowCount then set to 0
    if(![defaults objectForKey:@"InstructionShowCount"])
    {
        [defaults setInteger:0 forKey:@"InstructionShowCount"];
        //NSLog(@"%i", [defaults integerForKey:@"InstructionShowCount"]);
    }
    
    //Set image to default image
    image = [UIImage imageNamed:kIMAGE_PLACEHOLDER];
    
    //Set background view to defined colour
    self.view.backgroundColor = kVIEW_BACKGROUND_COLOR;
    
    //Create scrollview and add to the view
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, SCROLLVIEW_CONTENT_HEIGHT);
    scrollView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:scrollView];
    
    //Create each label
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 260, 20)];
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 110, 260, 20)];
    UILabel *relationLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 190, 260, 20)];
    UILabel *photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 270, 260, 20)];
    
    //Name Label Properties
    nameLabel.font = kLOCATION_TEXT_FONT;
    nameLabel.textColor = kVIEW_FOREGROUND_COLOR;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = @"Name";
    
    //Phone Label Properties
    phoneLabel.font = nameLabel.font;
    phoneLabel.textColor = nameLabel.textColor;
    phoneLabel.backgroundColor = nameLabel.backgroundColor;
    phoneLabel.text = @"Phone";
    
    //Relationship Label Properties
    relationLabel.font = nameLabel.font;
    relationLabel.textColor = nameLabel.textColor;
    relationLabel.backgroundColor = nameLabel.backgroundColor;
    relationLabel.text = @"Relation";
    
    //Photo Label Properties
    photoLabel.font = nameLabel.font;
    photoLabel.textColor = nameLabel.textColor;
    photoLabel.backgroundColor = nameLabel.backgroundColor;
    photoLabel.text = @"Photo";
    
    //Add these labels to the Scrollview
    [scrollView addSubview:nameLabel];
    [scrollView addSubview:phoneLabel];
    [scrollView addSubview:relationLabel];
    [scrollView addSubview:photoLabel];
    
    //This creates the button for the Photo Label 
    UIView *photoView = [[UIView alloc] initWithFrame:CGRectMake(30, 295, 260, 110)];
    photoView.backgroundColor = kVIEW_FOREGROUND_COLOR;
    photoView.layer.cornerRadius = kCELL_CORNER_RADIUS;
    
    //Create UIImageView for Photo button
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 100, 100)];
    imageView.image = [UIImage imageNamed:kIMAGE_PLACEHOLDER];
    imageView.layer.cornerRadius = kCELL_CORNER_RADIUS;
    
    //Create label for Photo button  
    UILabel *changeImageLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 150, photoView.frame.size.height)];
    changeImageLabel.font = nameLabel.font;
    changeImageLabel.textColor = kCELL_HEADER_FONT_COLOR;
    changeImageLabel.backgroundColor = nameLabel.backgroundColor;
    changeImageLabel.text = @"Change Photo";
    changeImageLabel.textAlignment = NSTextAlignmentCenter;

    //Add both UIImage and UILabel to UIView
    [photoView addSubview:changeImageLabel];
    [photoView addSubview:imageView];
    
    //Add UIView to ScrollView
    [scrollView addSubview:photoView];
    
    //Create button which performs an action when user selects the photo UIView
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoButton.frame = photoView.frame;
    [photoButton addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:photoButton];
    
    //Create the three textfields for user to input data
    nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 55, 260, 30)];
    phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 135, 260, 30)];
    relationTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 215, 260, 30)];

    //Apply the skin to text fields
    [Appearance applySkinToTextField:nameTextField withPlaceHolderText:@"Tap here to start typing"];
    [Appearance applySkinToTextField:phoneTextField withPlaceHolderText:@""];
    [Appearance applySkinToTextField:relationTextField withPlaceHolderText:@""];
    
    //Define the keyboard type for phone number
    [phoneTextField setKeyboardType:UIKeyboardTypePhonePad];
    
    //Add textfields to ScrollView
    [scrollView addSubview:nameTextField];
    [scrollView addSubview:phoneTextField];
    [scrollView addSubview:relationTextField];
    
    //Set Delegates for each UITextfield
    nameTextField.delegate = self;
    phoneTextField.delegate = self;
    relationTextField.delegate = self;
    
    //Define the tag number for relationship textfield
    relationTextField.tag = 3;
    
    //Keyboard controls init
    NSArray *keyboardFields = @[self.nameTextField, self.phoneTextField, self.relationTextField];
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:keyboardFields]];
    [self.keyboardControls setDelegate:self];
    
    //Perform the setup nav bar method
    [self setupNavBar];
}

//Setup the navigation bar at the top for this view
-(void)setupNavBar
{
    //If function is adding a contact then it performs the following
    if ([self.navigationItem.title isEqualToString:@"Add Contact"])
    {
        
        //Create two buttons at the top (left and right side)
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                       target:self
                                       action:@selector(save)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                         target:self
                                         action:@selector(cancel)];
        self.navigationItem.leftBarButtonItem = cancelButton;
        self.navigationItem.rightBarButtonItem = saveButton;
        
        //Change the appearance to icons
        [Appearance addCancelButtonToViewController:self];
        [Appearance addSaveButtonToViewController:self];
        
        //Alert the user with an actionsheet regarding what they want to perform
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"Import from Contacts", @"Create New", nil];
        sheet.tag = 200;
        //show the actionsheet in the view
        [sheet showInView:[[UIApplication sharedApplication].delegate window] ];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

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

-(void) viewWillDisappear:(BOOL)animated
{
    // Unregister for keyboard events
    [[NSNotificationCenter defaultCenter]
     removeObserver:self];
}

-(void) keyboardDidShow: (NSNotification *)notif
{
    //NSLog(@"Keyboard is visible");
}

-(void) keyboardDidHide: (NSNotification *)notif
{
    //NSLog(@"KeyboardDidHide");
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
    //Remove view from the stack
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - UITextField Delegate
//This method is a UITextField delegate method for control of the keyboard when texting
-(BOOL) textFieldShouldBeginEditing:(UITextField*)textField
{
    UIView *keyView = [[UIView alloc] initWithFrame:textField.frame];
    [self keyboardControls:aKeyboardControls selectedField:keyView inDirection:BSKeyboardControlsDirectionNext];
    if (textField.tag == 3) {
        
    } else
    {
        [self textFieldDidBeginEditing:textField];
    }
    return YES;
}

//Keyboard displays to the user
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.keyboardControls setActiveField:textField];
}

//
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, SCROLLVIEW_CONTENT_HEIGHT + field.frame.origin.y);
    CGRect scrollRect = CGRectMake(0, field.frame.origin.y, 320, 380);
    [scrollView scrollRectToVisible:scrollRect animated:YES];
}

//Keyboard is removed from view
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [keyboardControls.activeField resignFirstResponder];
}


#pragma mark - Image Compression
//Image compression for large image files imported or photos taken
- (UIImage *)imageWithImage:(UIImage *)aImage scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [aImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)save
{
    /*
     Data Validation
     If Name Text Field is empty - Show Alert
     Else If Phone Text Field is empty - Show Alert
     Else If Relation Text Field is empty - Show Alert
     */
    if (nameTextField.text == nil || [nameTextField.text isEqualToString:@""])
    {
        UIAlertView *errorSaving = [[UIAlertView alloc]
                                    initWithTitle:@"Name Required"
                                    message:@"Please fill in the Name for the contact"
                                    delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles: nil];
        errorSaving.tag = 300;
        [errorSaving show];
    }
    else if (phoneTextField.text == nil || [phoneTextField.text isEqualToString:@""])
    {
        UIAlertView *errorSaving = [[UIAlertView alloc]
                                    initWithTitle:@"Phone Number Required"
                                    message:@"Please fill in the Phone number for the contact"
                                    delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles: nil];
        errorSaving.tag = 300;
        [errorSaving show];
    }
    else if(relationTextField.text == nil || [relationTextField.text isEqualToString:@""])
    {
        UIAlertView *errorSaving = [[UIAlertView alloc]
                                    initWithTitle:@"Relation Required"
                                    message:@"Please fill in the Relation for the contact"
                                    delegate:self
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles: nil];
        errorSaving.tag = 300;
        [errorSaving show];
    }
    else
    {
    // Extract the data the user entered
    NSString *name = [nameTextField text];
    NSString *phone = [[phoneTextField text]stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *relation = [relationTextField text];

    //Check if the image has been provided, if not use default image
    if (!self.contactImage)
    {
    NSData *jpgData = UIImageJPEGRepresentation(image, 1);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.jpg"];
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
    [self dismissViewControllerAnimated:YES completion:^{
        [SVProgressHUD showSuccessWithStatus:@"Contact Added"];
    }];
    
    }
}

//Provide user with UIalertview to add a new photo options
-(IBAction)addPhoto
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Choose From Library", nil];
    actionSheet.tag = 100;
    [actionSheet showInView:self.view];
}

//ImagePickerController allows access to users phones Camera Roll to select image from library
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    image = [self imageWithImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"] scaledToSize:CGSizeMake(200, 200)];
	imageView.image = image;
}

#pragma mark - UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    
	picker.delegate = self;
    if (actionSheet.tag == 100)
    {
        
    // 0 = Take Photo
    if (buttonIndex == 0)
    {
        //NSLog(@"Take Photo");
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }
    // 1 = Choose From Library
    if (buttonIndex == 1)
    {
        //NSLog(@"Choose From Library");
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
        
    }
    // 2 = Cancel
    if (buttonIndex == 2)
    {
        //NSLog(@"Cancel");
    }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 200)
    {
    if (buttonIndex == 0)
    {
        //Import Contact from address book button selected
        [self importContact];
    }
    if (buttonIndex == 1)
    {
        //removes the Actionsheet but keeps the ContactAddViewController
    }
        if (buttonIndex == 2)
        {
            [self cancel];
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
    
    // Present the Contact Picker or Instructions for Importing
    [self presentViewController:_contacts animated:YES completion:^{
    
        // Check to see if the Instructions has been shown less times than the Instruction Limit
        if ([defaults integerForKey:@"InstructionShowCount"] < kINSTRUCTION_SHOW_LIMIT)
        {
            
            // If it has been shown LESS times than the limit, present the instructions.
            // Else just show the Contact Picker View as normal
            ImportInstructionsViewController *importInstructionsViewController = [[ImportInstructionsViewController alloc] init];
            UINavigationController *instructionsNavController = [[UINavigationController alloc] initWithRootViewController:importInstructionsViewController];
            
            [_contacts presentViewController:instructionsNavController animated:YES completion:^{
                
                NSInteger count = [defaults integerForKey:@"InstructionShowCount"] + 1;
                [defaults setInteger:count forKey:@"InstructionShowCount"];
            
            }];
        }
        
    }];
}

//Method to gather the information about the contact from the users address book
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    
    //Define the first and last name
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    //Concatenate first name and last name together
    NSString *fullName = @"";
    if (firstName != nil)
    {
        fullName = [fullName stringByAppendingString:firstName];
    }
    if (lastName != nil)
    {
        fullName = [fullName stringByAppendingString:@" "];
        fullName = [fullName stringByAppendingString:lastName];
    }
    
    self.fullName = fullName;
    
    //Capture the number of the user
    CFTypeRef multivalue = ABRecordCopyValue(person, property);
    CFIndex index = ABMultiValueGetIndexForIdentifier(multivalue, identifier);
    NSString *phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(multivalue, index);
    
    //Remove any spaces in the number
    self.phoneNumber = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //Capture the image if any from the address book of the contact selected
    UIImage *imageImport = [UIImage imageWithData:(__bridge NSData *)ABPersonCopyImageDataWithFormat (person, kABPersonImageFormatOriginalSize)];
    
    self.imageView.image = imageImport;
    self.contactImage = imageImport;
    
    //perform the importSaveContact method
    [self importSaveContact];
    
    //Dismiss the addressbook contact selection view
    [_contacts dismissViewControllerAnimated:YES completion:^{
    }];
    
	return NO;
}

// Implement this delegate method to make the Cancel button of the Address Book working
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    [peoplePicker dismissViewControllerAnimated:YES completion:^{
        [self dismissView];
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
}

//Define the location of the documents folder
- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}

//Dismiss the ContactAddViewController
- (void)dismissView
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
