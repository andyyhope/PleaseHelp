//
//  ContactEditViewController.m
//  Please Help
//
//  Created by Adrian Jurcevic & Andyy Hope on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "ContactEditViewController.h"
#import "Appearance.h"

//Define the private variables for this class
@interface ContactEditViewController ()

@property ContactItem *contact;
@property (weak) id<ContactEditViewControllerDelegate> delegate;

@end

@implementation ContactEditViewController

- (id)initWithContact:(ContactItem *)item andDelegate:(id<ContactEditViewControllerDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        // Set Item
        self.contact = item;
        
        // Set Delegate
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Add a customised back button and save button
    [Appearance addBackButtonToViewController:self];
    [Appearance addSaveButtonToEditViewController:self];
    
    //Populate the fields based on the contact selected
    if (self.contact)
    {
        [self.nameTextField setText:[self.contact name]];
        [self.phoneTextField setText:[self.contact phone]];
        [self.relationTextField setText:[self.contact relation]];
        [self.imageView setImage:[self.contact image]];
    }
}

#pragma mark Save an Edit
- (void)saveEdit:(id)sender
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
        [errorSaving show];
    }
    else
    {    
    // Update Item
    [self.contact setName:[self.nameTextField text]];
    [self.contact setPhone:[[self.phoneTextField text] stringByReplacingOccurrencesOfString:@" " withString:@""]]; // Remove White Spaces from phone number 
    [self.contact setRelation:[self.relationTextField text]];
    [self.contact setImage:[self.imageView image]];
    
    // Notify Delegate
    [self.delegate controller:self didUpdateContact:self.contact];
        
    // Pop View Controller
    [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Dismiss the editing view
- (void)dismissView
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
