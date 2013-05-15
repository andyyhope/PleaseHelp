//
//  ContactEditViewController.m
//  DistressProto
//
//  Created by Andyy Hope on 7/05/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "ContactEditViewController.h"
#import "ContactItem.h"
#import "Appearance.h"

@interface ContactEditViewController ()

@property ContactItem *contact;
@property (weak) id<ContactEditViewControllerDelegate> delegate;

@end

@implementation ContactEditViewController

- (id)initWithContact:(ContactItem *)item andDelegate:(id<ContactEditViewControllerDelegate>)delegate
{
    self = [super init];
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
    
    [Appearance addBackButtonToViewController:self];
    [Appearance addSaveButtonToEditViewController:self];
    
    if (self.contact) {
        [self.nameTextField setText:[self.contact name]];
        [self.phoneTextField setText:[self.contact phone]];
        [self.relationTextField setText:[self.contact relation]];
        [self.imageView setImage:[self.contact image]];
    }
    
}

/*
 - (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}
*/

#pragma mark Save an Edit
- (void)saveEdit:(id)sender {
    NSString *name = [self.nameTextField text];
    NSString *phone = [[self.phoneTextField text] stringByReplacingOccurrencesOfString:@" " withString:@""]; // Remove white spaces
    NSString *relation = [self.relationTextField text];
    UIImage *imageEdit = [self.imageView image];
    
    // Update Item
    [self.contact setName:name];
    [self.contact setPhone:phone];
    [self.contact setRelation:relation];
    [self.contact setImage:imageEdit];
    
    // Notify Delegate
    [self.delegate controller:self didUpdateContact:self.contact];
    
    // Pop View Controller
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dismissView
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
