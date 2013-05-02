//
//  AddContactViewController.m
//  assistance
//
//  Created by Adrian Jurcevic on 9/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "AddContactViewController.h"

@interface AddContactViewController () <UIActionSheetDelegate, UITextFieldDelegate>

@end

@implementation AddContactViewController
@synthesize imageView;

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
    self.nameTextField.delegate = self;
    self.phoneTextField.delegate = self;
}

- (void)viewDidUnload {
    [self setImageView:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Save and Cancel
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    // Extract User Input
    NSString *name = [self.nameTextField text];
    NSString *phone = [self.phoneTextField text];
    //NSString *image = [[NSString alloc] initWithData:UIImagePNGRepresentation(self.imageView.image) encoding:NSASCIIStringEncoding];

    NSData *pngData = UIImagePNGRepresentation(self.imageView.image);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.png"]; //Add the file name
    [pngData writeToFile:filePath atomically:YES]; //Write the file
    
        NSData *pData = [NSData dataWithContentsOfFile:filePath];
        UIImage *image = [UIImage imageWithData:pData];

    NSLog(@"4$: %@",filePath);
    // Notify Delegate: name and phone
    //[self.delegate controller:self didSaveContactWithName:name andPhone:phone];

    // Notify Delegate: name, phone and image
    [self.delegate controller:self didSaveContactWithName:name andPhone:phone andImage:image];
    
    // Dismiss View Controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}

-(IBAction)addPhoto:(id)sender{ 
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
	[picker dismissModalViewControllerAnimated:YES];
	imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
}


#pragma mark - UITextfield Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}



@end
