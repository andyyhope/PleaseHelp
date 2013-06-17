//
//  PasscodeViewController.m
//  Please Help
//
//  Created by Adrian Jurcevic & Andyy Hope on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "PasscodeSettingsViewController.h"
#import "SVProgressHUD.h" 
#import "Appearance.h"

//Define the private variables and methods for this class
@interface PasscodeSettingsViewController () <UIAlertViewDelegate>
{
    UIScrollView *scrollView;
    UIView *blockRecoverButtonView;
    UITextField *textField;
    UIButton *passcodeButton;
    UIButton *recoverButton;
    UILabel *passcodeInfoLabel;
}

-(void)setPasscode;
-(void)setRecoveryHint;

@end

@implementation PasscodeSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialize
        passcodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        recoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        passcodeInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 300, 60)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Skin View
    self.view.backgroundColor = kVIEW_BACKGROUND_COLOR;
    
    // Create a Scroll View to make the view non-static
    // ie, user can scroll and the view will bounce back to its original position
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 1);
    [self.view addSubview:scrollView];
}

-(void)viewWillAppear:(BOOL)animated
{
    // Everytime this view appears it will perform the setupButtons Method
    [self setupButtons];
}

-(void)viewDidDisappear:(BOOL)animated
{
    
}

-(void)setupButtons
{
    // Create Passcode Button
    [Appearance applySkinToSettingsButton:passcodeButton withTitle:nil];
    [passcodeButton addTarget:self action:@selector(setPasscode) forControlEvents:UIControlEventTouchUpInside];
    passcodeButton.frame = CGRectMake(10, 10, 300, 50);
    [scrollView addSubview:passcodeButton];
    
    // Create Recovery Button
    [Appearance applySkinToSettingsButton:recoverButton withTitle:nil];
    [recoverButton addTarget:self action:@selector(checkRecoveryHint) forControlEvents:UIControlEventTouchUpInside];
    recoverButton.frame = CGRectMake(10, 90, 300, 50);
    [scrollView addSubview:recoverButton];
    
    // Create and populate the Info label
    [Appearance applySkinToLocationLabel:passcodeInfoLabel];
    passcodeInfoLabel.text = kPASSCODE_INFOLABEL;
    [scrollView addSubview:passcodeInfoLabel];
    
    //Perform validation on what buttons/labels to display
    [self updateButtons];
    
    // Update the Passcode Lock icon
    [Appearance updateSettingsLockedIconToViewController:self.parentViewController];
}

-(void)updateButtons
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"PasscodeSet"])
    {
        // Passcode is set
        [passcodeButton setBackgroundColor:kVIEW_ALT_BACKGROUND_COLOR];
        [passcodeButton setTitleColor:kVIEW_FOREGROUND_COLOR forState:UIControlStateNormal];
        [passcodeButton setTitle:kPASSCODE_BUTTON_EDIT forState:UIControlStateNormal];
        [passcodeButton setTitle:kPASSCODE_BUTTON_EDIT forState:UIControlStateSelected];
        passcodeInfoLabel.hidden = true;
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"RecoveryHint"] == nil)
        {
            // Recovery not set
            [Appearance applySkinToSettingsButton:recoverButton withTitle:nil];
            [recoverButton setTitle:kPASSCODE_BUTTON_RECOVERY forState:UIControlStateNormal];
            [recoverButton setTitle:kPASSCODE_BUTTON_RECOVERY forState:UIControlStateSelected];
            recoverButton.hidden = false;
            passcodeInfoLabel.hidden = true;
            
        } else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"RecoverSet"])
        {
            // Recovery Set
            [recoverButton setBackgroundColor:kVIEW_ALT_BACKGROUND_COLOR];
            [recoverButton setTitleColor:kVIEW_FOREGROUND_COLOR forState:UIControlStateNormal];
            [recoverButton setTitle:kPASSCODE_BUTTON_CHANGE_HINT forState:UIControlStateNormal];
            [recoverButton setTitle:kPASSCODE_BUTTON_CHANGE_HINT forState:UIControlStateSelected];
            passcodeInfoLabel.hidden = TRUE;
            recoverButton.hidden = false;
        }
    } else
    {
        // Passcode is not set
        [passcodeButton setTitle:kPASSCODE_BUTTON_SETPASSCODE forState:UIControlStateNormal];
        [passcodeButton setTitle:kPASSCODE_BUTTON_SETPASSCODE forState:UIControlStateSelected];
        
        recoverButton.hidden = true;
        passcodeInfoLabel.hidden = false;
        
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"RecoverSet"];
        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"RecoveryHint"];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Passcode Button Function
-(void)setPasscode
{
    //Set Admin value to yes 
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"Admin"];
    [defaults synchronize];

    //launch the framework from KVPasscodeViewController into the current view
    KVPasscodeViewController *passcodeController = [[KVPasscodeViewController alloc] init];
    passcodeController.passDelegate = self;
    UINavigationController *passcodeNavigationController = [[UINavigationController alloc]
                                                            initWithRootViewController:passcodeController];
    [self presentViewController:passcodeNavigationController animated:YES completion:^{
        }];
}

#pragma Recovery Hint Button Functions
-(void)checkRecoveryHint
{
    //Check if there is recovery hint set.
    //if not then set recovery hint button
    //else display to change the hint
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults boolForKey:@"RecoverSet"])
    {
        [self setRecoveryHint];
    }
    else
    {
        [self displayRecoveryHint];
    }
}

-(void)setRecoveryHint
{
    //UIAlertview to display to user
    UIAlertView *recoveryAlert = [[UIAlertView alloc]
                                  initWithTitle:@"Set Passcode Hint"
                                  message:@"\n"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:@"OK", nil];
    recoveryAlert.tag = 1;
    
    //Embeded an UITextField into the UIalertview for a user to input a recovery hint
    textField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
    textField.placeholder = @"Enter hint for the passcode";
    [textField becomeFirstResponder];
    textField.backgroundColor = kVIEW_FOREGROUND_COLOR;
    textField.textAlignment = NSTextAlignmentCenter;
    
    //Add TextField to UIAlertview
    [recoveryAlert addSubview:textField];
    
    //Display the UIAlertview
    [recoveryAlert show];
}


-(void)displayRecoveryHint
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //define the current recoveryhint
    NSString *recoveryMessage= [[NSString alloc] initWithFormat:@"'%@'\n\n\n",
                                [defaults valueForKey:@"RecoveryHint"]];
    
    //Display alertview with the current recovery hint and the option to change it
    UIAlertView *displayAlert = [[UIAlertView alloc]
                                  initWithTitle:@"Your Current Recovery Hint"
                                  message:recoveryMessage
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:@"Reset", nil];
    displayAlert.tag = 2;
    
    //Embeded an UITextField into the UIalertview for a user to input a recovery hint
    textField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 80.0, 260.0, 25.0)];
    textField.placeholder = kPASSCODE_TEXTFIELD_PLACEHOLDER;
    [textField becomeFirstResponder];
    textField.backgroundColor = kVIEW_FOREGROUND_COLOR;
    textField.textAlignment = NSTextAlignmentCenter;
    
    //Add TextField to UIAlertview
    [displayAlert addSubview:textField];
    
    //Display the UIAlertview
    [displayAlert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *recoveryHint = textField.text;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //Define the notify passcode alertview
    if (alertView.tag == 0)
    {
        switch (buttonIndex)
        {
            case 1:
                [self setRecoveryHint];
                break;
                
            case 2:
                [self setPasscode];
                break;
                
            default:
                break;
        }
    }
    //Define the set recovery hint alertview
    else if (alertView.tag == 1)
    {
        switch (buttonIndex)
        {
            case 1:
                if (textField.text == nil || [textField.text isEqualToString: @""])
                {
                    
                }
                else
                {
                    [defaults setValue:recoveryHint forKey:@"RecoveryHint"];
                    [defaults setBool:YES forKey:@"RecoverSet"];
                    [defaults synchronize];
                    
                    //Display successful HUD message
                    [SVProgressHUD showSuccessWithStatus:@"Recovery Hint Set"];
                    
                    [self setupButtons];
                }
                //NSLog(@"Reset");
                break;
            case 0:
                //NSLog(@"Cancel");
                break;
            default:
                break;
        }
    }
}

#pragma mark - KVPasscodeViewControllerDelegate
//This method refers to when the user enters any passcode
- (void)passcodeController:(KVPasscodeViewController *)controller passcodeEntered:(NSString *)passCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:passCode forKey:@"Passcode"];
    [defaults setBool:YES forKey:@"PasscodeSet"];
    [defaults synchronize];
    
    //UIAlertview displays to user what passcode was set
    UIAlertView *notifyPasscode = [[UIAlertView alloc]
                                   initWithTitle:[NSString stringWithFormat:@"Passcode set to: \n\n%@", passCode]
                                   message:kPASSCODE_NOTIFY_PASSCODE
                                   delegate:self
                                   cancelButtonTitle:@"Done"
                                   otherButtonTitles:@"Set Passcode Hint", @"Change Passcode", nil];
    notifyPasscode.tag = 0;
    [notifyPasscode show];
    
    //Performs the updateButtons method
    [self updateButtons];
    
    //remove the PasscodeViewController
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
