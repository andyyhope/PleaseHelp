//
//  PasscodeViewController.m
//  Please Help
//
//  Created by Adrian Jurcevic & Anddy Hope on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "PasscodeSettingsViewController.h"
#import "SVProgressHUD.h" 

@interface PasscodeSettingsViewController () <UIAlertViewDelegate>
{
    UIView *blockRecoverButtonView;
    UITextField *textField;
}

@property (nonatomic, retain) UIButton *passcodeButton;
@property (nonatomic, retain) UIButton *recoveryButton;

-(void)setPasscode;
-(void)setRecoveryHint;

@end

@implementation PasscodeSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Skin View
    self.view.backgroundColor = kVIEW_BACKGROUND_COLOR;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setupButtons];
}

-(void)viewDidDisappear:(BOOL)animated
{
    
}

-(void)setupButtons
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UILabel *passcodeInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 60)];
    
    //Setup and skin the Recovery Hint Button
    _recoveryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [Appearance applySkinToSettingsButton:_recoveryButton withTitle:nil];
    _recoveryButton.frame = CGRectMake(10, 90, 300, 50);
    
    if (![defaults boolForKey:@"PasscodeSet"])
    {
        
    }
    else if ([defaults boolForKey:@"PasscodeSet"] && ![defaults boolForKey:@"RecoverSet"])
    {
        [Appearance applySkinToSettingsButton:_recoveryButton withTitle:nil];
        [_recoveryButton setTitle:@"Set A Recovery Hint" forState:UIControlStateNormal];
        [_recoveryButton setTitle:@"Set A Recovery Hint" forState:UIControlStateSelected];
        [self.view addSubview:_recoveryButton];
        [passcodeInfoLabel removeFromSuperview];
        
    }
    else if ([defaults boolForKey:@"RecoverSet"])
    {
        [_recoveryButton setBackgroundColor:kVIEW_ALT_BACKGROUND_COLOR];
        [_recoveryButton setTitleColor:kVIEW_FOREGROUND_COLOR forState:UIControlStateNormal];
        [_recoveryButton setTitle:@"Change Recovery Hint" forState:UIControlStateNormal];
        [_recoveryButton setTitle:@"Change Recovery Hint" forState:UIControlStateSelected];
        [passcodeInfoLabel removeFromSuperview];
    }
    
    [_recoveryButton addTarget:self action:@selector(checkRecoveryHint) forControlEvents:UIControlEventTouchUpInside];
    
    //Setup and skin the Passcode Button
    _passcodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [Appearance applySkinToSettingsButton:_passcodeButton withTitle:nil];
    _passcodeButton.frame = CGRectMake(10, 10, 300, 50);

    if (![defaults boolForKey:@"PasscodeSet"]) {
        [_passcodeButton setTitle:@"Set Passcode" forState:UIControlStateNormal];
        [_passcodeButton setTitle:@"Set Passcode" forState:UIControlStateSelected];

        blockRecoverButtonView = [[UIView alloc] initWithFrame:_recoveryButton.frame];
        blockRecoverButtonView.backgroundColor = kVIEW_BACKGROUND_COLOR;
        [self.view addSubview:blockRecoverButtonView];
        
        _recoveryButton.backgroundColor = [UIColor clearColor];
        _recoveryButton.enabled = false;
        [_recoveryButton removeFromSuperview];
        
        [Appearance applySkinToLocationLabel:passcodeInfoLabel];
        passcodeInfoLabel.text = @"A passcode is recommended to stop a person from entering the settings panel and editing contacts information.";
        [blockRecoverButtonView addSubview:passcodeInfoLabel];
    }
    else
    {
        [_passcodeButton setBackgroundColor:kVIEW_ALT_BACKGROUND_COLOR];
        [_passcodeButton setTitleColor:kVIEW_FOREGROUND_COLOR forState:UIControlStateNormal];
        [_passcodeButton setTitle:@"Change/Remove Passcode" forState:UIControlStateNormal];
        [_passcodeButton setTitle:@"Change/Remove Passcode" forState:UIControlStateSelected];
        [blockRecoverButtonView removeFromSuperview];
        [self.view addSubview:_recoveryButton];
        [passcodeInfoLabel removeFromSuperview];
        
    } 
    [_passcodeButton addTarget:self action:@selector(setPasscode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_passcodeButton];

    // Update the Passcode Lock icon
    [Appearance updateSettingsLockedIconToViewController:self.parentViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Passcode Button Function
-(void)setPasscode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"Admin"];
    [defaults synchronize];

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
    UIAlertView *recoveryAlert = [[UIAlertView alloc]
                                  initWithTitle:@"Set Passcode Hint"
                                  message:@"\n"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:@"OK", nil];
    recoveryAlert.tag = 1;
    textField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
    textField.placeholder = @"Enter hint for the passcode";
    [textField becomeFirstResponder];
    textField.backgroundColor = kVIEW_FOREGROUND_COLOR;
    textField.textAlignment = NSTextAlignmentCenter;
    [recoveryAlert addSubview:textField];
    [recoveryAlert show];

}

-(void)displayRecoveryHint
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *recoveryMessage= [[NSString alloc] initWithFormat:@"'%@'\n\n\n",
                                [defaults valueForKey:@"RecoveryHint"]];
    
    UIAlertView *displayAlert = [[UIAlertView alloc]
                                  initWithTitle:@"Your Current Recovery Hint"
                                  message:recoveryMessage
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:@"Reset", nil];
    displayAlert.tag = 2;
    textField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 80.0, 260.0, 25.0)];
    textField.placeholder = @"Change hint for the passcode";
    [textField becomeFirstResponder];
    textField.backgroundColor = kVIEW_FOREGROUND_COLOR;
    textField.textAlignment = NSTextAlignmentCenter;
    [displayAlert addSubview:textField];
    [displayAlert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *recoveryHint = textField.text;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (alertView.tag == 0)
    {
        switch (buttonIndex) {
            case 1:
                [self setRecoveryHint];
                break;
                
            case 2:
                [self setPasscode];
                break;
                
            default:
                break;
        }
    } else if (alertView.tag == 1){
        switch (buttonIndex) {
            case 1:
                if (textField.text == nil || [textField.text isEqualToString: @""]) {
                }
                else{
                    [defaults setValue:recoveryHint forKey:@"RecoveryHint"];
                    [defaults setBool:YES forKey:@"RecoverSet"];
                    [defaults synchronize];
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
- (void)passcodeController:(KVPasscodeViewController *)controller passcodeEntered:(NSString *)passCode {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:passCode forKey:@"Passcode"];
    [defaults setBool:YES forKey:@"PasscodeSet"];
    [defaults synchronize];

    UIAlertView *notifyPasscode = [[UIAlertView alloc]
                                   initWithTitle:[NSString stringWithFormat:@"Passcode set to: \n\n%@", passCode]
                                   message:@"You should also set a Recovery Hint in case you forget your passcode"
                                   delegate:self
                                   cancelButtonTitle:@"Neither"
                                   otherButtonTitles:@"Set Passcode Hint", @"Change Passcode", nil];
    notifyPasscode.tag = 0;
    [notifyPasscode show];
    
    //remove the PasscodeViewController
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
