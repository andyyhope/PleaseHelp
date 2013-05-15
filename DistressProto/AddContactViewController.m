//
//  AddContactViewController.m
//  assistance
//
//  Created by Adrian Jurcevic on 9/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "AddContactViewController.h"
#import "UIImage+Resize.h"
#import "AppearanceConstants.h"

@interface AddContactViewController () <UIActionSheetDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation AddContactViewController
//@synthesize image;

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
    
    
    self.view.backgroundColor = kVIEW_BACKGROUND_COLOR;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 75, 260, 20)];
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 155, 260, 20)];
    UILabel *relationLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 235, 260, 20)];
    UILabel *photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 315, 260, 20)];
    
    
    
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
    
    [self.view addSubview:nameLabel];
    [self.view addSubview:phoneLabel];
    [self.view addSubview:relationLabel];
    [self.view addSubview:photoLabel];
    
    UIView *photoView = [[UIView alloc] initWithFrame:CGRectMake(30, 340, 260, 110)];
    photoView.backgroundColor = [UIColor whiteColor];
    photoView.layer.cornerRadius = kCELL_CORNER_RADIUS;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 100, 100)];
    imageView.image = [UIImage imageNamed:@"default_profile_image.gif"];
    imageView.layer.cornerRadius = kCELL_CORNER_RADIUS;
    
    UILabel *changeImageLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 150, photoView.frame.size.height)];
    changeImageLabel.font = nameLabel.font;
    changeImageLabel.textColor = kCELL_HEADER_FONT_COLOR;
    changeImageLabel.backgroundColor = nameLabel.backgroundColor;
    changeImageLabel.text = @"Change Photo";
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
    changeImageLabel.textAlignment = UITextAlignmentCenter;
#else
    changeImageLabel.textAlignment = NSTextAlignmentCenter;
#endif

//    changeImageLabel.textAlignment = UITextAlignmentCenter;
    [photoView addSubview:changeImageLabel];
    [photoView addSubview:imageView];
    [self.view addSubview:photoView];
    
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoButton.frame = photoView.frame;
    [photoButton addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoButton];
    
    
    nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 100, 260, 30)];
    nameTextField.backgroundColor = [UIColor whiteColor];
    nameTextField.borderStyle = UITextBorderStyleLine;
    nameTextField.layer.masksToBounds = YES;
    nameTextField.layer.borderColor = [UIColor whiteColor].CGColor;
    nameTextField.layer.cornerRadius = 3;
    nameTextField.layer.borderWidth = 1.0f;
    [self.view addSubview:nameTextField];
    
    phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 180, 260, 30)];
    phoneTextField.backgroundColor = [UIColor whiteColor];
    phoneTextField.borderStyle = UITextBorderStyleLine;
    phoneTextField.layer.masksToBounds = YES;
    phoneTextField.layer.borderColor = [UIColor whiteColor].CGColor;
    phoneTextField.layer.cornerRadius = 3;
    phoneTextField.layer.borderWidth = 1.0f;
    [phoneTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [self.view addSubview:phoneTextField];
    
    relationTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 260, 260, 30)];
    relationTextField.backgroundColor = [UIColor whiteColor];
    relationTextField.borderStyle = UITextBorderStyleLine;
    relationTextField.layer.masksToBounds = YES;
    relationTextField.layer.borderColor = [UIColor whiteColor].CGColor;
    relationTextField.layer.cornerRadius = 3;
    relationTextField.layer.borderWidth = 1.0f;
    [self.view addSubview:relationTextField];
    
    nameTextField.delegate = self;
    phoneTextField.delegate = self;
    relationTextField.delegate = self;
}

- (void)viewDidUnload {
//    [self setImageView:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Save and Cancel
- (IBAction)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)save:(id)sender {
    // Extract User Input
    NSString *name = [nameTextField text];
    NSString *phone = [phoneTextField text];
    NSString *relation = [relationTextField text];
    //NSString *image = [[NSString alloc] initWithData:UIImagePNGRepresentation(self.imageView.image) encoding:NSASCIIStringEncoding];

    
    // Compress the image to 1/10 size
//    UIImage *small = [UIImage imageWithCGImage:self.imageView.image.CGImage scale:0.1 orientation:self.imageView.image.imageOrientation];
    
    NSData *jpgData = UIImageJPEGRepresentation(image, 1);
//    NSData *pngData = UIImagePNGRepresentation(small);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.jpg"]; //Add the file name
    [jpgData writeToFile:filePath atomically:YES]; //Write the file
    
        NSData *pData = [NSData dataWithContentsOfFile:filePath];
        UIImage *capImage = [UIImage imageWithData:pData];
        
    

    NSLog(@"4$: %@",filePath);
    // Notify Delegate: name and phone
    //[self.delegate controller:self didSaveContactWithName:name andPhone:phone];

    // Notify Delegate: name, phone and image
//    [self.delegate controller:self didSaveContactWithName:name andPhone:phone andImage:capImage];
    [self.delegate controller:self didSaveContactWithName:name phone:phone relation:relation andImage:capImage];
    
    // Dismiss View Controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)documentsPathForFileName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:name];
}

-(IBAction)addPhoto{ 
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
    image = [self imageWithImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"] scaledToSize:CGSizeMake(200, 200)];

    
    
	imageView.image = image;
    //imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
}


#pragma mark - UITextfield Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (UIImage *)imageWithImage:(UIImage *)aImage scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [aImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
