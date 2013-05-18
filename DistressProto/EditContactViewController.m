//
//  EditContactViewController.m
//  assistance
//
//  Created by Adrian Jurcevic on 9/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "EditContactViewController.h"
#import "AddContactViewController.h"

#import "ContactItem.h"

@interface EditContactViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property ContactItem *contact;
@property AddContactViewController *addContactView;
@property (weak) id<EditContactViewControllerDelegate> delegate;

@end

@implementation EditContactViewController

- (id)initWithContact:(ContactItem *)item andDelegate:(id<EditContactViewControllerDelegate>)delegate {
    self = [super initWithNibName:@"EditContactViewController" bundle:nil];
    
    if (self) {
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
    
    self.nameTextField.delegate = self;
    self.phoneTextField.delegate = self;

    // Populate Text Fields
    if (self.contact) {
        [self.nameTextField setText:[self.contact name]];
        [self.phoneTextField setText:[self.contact phone]];
        [self.imageView setImage:[self.contact image]];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Edit Photo

-(IBAction)editPhoto:(id)sender
{
    [self setUpActionSheet];

}

- (void)setUpActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take Photo", @"Choose From Library", nil];
    
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	//[picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
	_imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
}

#pragma mark Save
- (void)save:(id)sender {
    NSString *name = [self.nameTextField text];
    NSString *phone = [self.phoneTextField text];
    UIImage *image = [self.imageView image];
    
    // Update Item
    [self.contact setName:name];
    [self.contact setPhone:phone];
    [self.contact setImage:image];
    
    // Notify Delegate
    [self.delegate controller:self didUpdateContact:self.contact];
    
    // Pop View Controller
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextfield Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
