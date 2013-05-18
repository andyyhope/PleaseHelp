//
//  PasscodeViewController.m
//  DistressProto
//
//  Created by Adrian Jurcevic on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "PasscodeViewController.h"
#import "AppearanceConstants.h"
#import "Appearance.h"

@interface PasscodeViewController () <UIAlertViewDelegate>
{
    UITextField *textField;
}

@property (nonatomic, retain) UIButton *passcodeButton;
@property (nonatomic, retain) UIButton *recoveryButton;

-(void)setPasscode;
-(void)setRecoveryHint;

@end

@implementation PasscodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kVIEW_BACKGROUND_COLOR;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self checkStatus];
    [self setupButtons];
}

-(void)setupButtons
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    //Setup the Passcode Button
    _passcodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [Appearance applySkinToSettingsButton:_passcodeButton withTitle:nil];
    _passcodeButton.frame = CGRectMake(20, 20, 280, 50);
    if (![defaults boolForKey:@"PasscodeSet"]) {
    [_passcodeButton setTitle:@"Set Passcode" forState:UIControlStateNormal];
    [_passcodeButton setTitle:@"Set Passcode" forState:UIControlStateSelected];
    }
    else
    {
    [_passcodeButton setTitle:@"Reset Passcode" forState:UIControlStateNormal];
    [_passcodeButton setTitle:@"Reset Passcode" forState:UIControlStateSelected];
    } 
    [_passcodeButton addTarget:self action:@selector(setPasscode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_passcodeButton];

    //Setup the Recovery Hint Button
    _recoveryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [Appearance applySkinToSettingsButton:_recoveryButton withTitle:nil];
    _recoveryButton.frame = CGRectMake(20, 90, 280, 50);
    [_recoveryButton setTitle:@"Set Recovery Hint" forState:UIControlStateNormal];
    [_recoveryButton setTitle:@"Set Recovery Hint" forState:UIControlStateSelected];
    [_recoveryButton addTarget:self action:@selector(checkRecoveryHint) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recoveryButton];
}

-(void)checkStatus //METHOD FOR TESTING ONLY // WILL REMOVE AT END
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if ([defaults boolForKey:@"PasscodeSet"])
    {
        NSString *string = [defaults valueForKey:@"Passcode"];
        NSLog(@"Passcode.%@", string);
        
    }
    else
    {
        
    }
    
    if ([defaults boolForKey:@"RecoverSet"])
    {
        NSString *string = [defaults valueForKey:@"RecoveryHint"];
        NSLog(@"Recovery.%@", string);

    }
    else
    {
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"Admin"];
    [defaults synchronize];

    KVPasscodeViewController *passcodeController = [[KVPasscodeViewController alloc] init];
    passcodeController.passDelegate = self;
    UINavigationController *passcodeNavigationController = [[UINavigationController alloc]
                                                            initWithRootViewController:passcodeController];

        [self presentViewController:passcodeNavigationController animated:YES completion:^{
            //code here
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
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
    textField.placeholder = @"Enter hint for the passcode";
    [textField becomeFirstResponder];
    textField.backgroundColor = [UIColor whiteColor];
    textField.textAlignment = NSTextAlignmentCenter;
    [recoveryAlert addSubview:textField];
    [recoveryAlert show];

}

-(void)displayRecoveryHint
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *recoveryMessage= [[NSString alloc] initWithFormat:@"%@\n\n\n",
                                [defaults valueForKey:@"RecoveryHint"]];
    
    UIAlertView *displayAlert = [[UIAlertView alloc]
                                  initWithTitle:@"Your Current Recovery Hint"
                                  message:recoveryMessage
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  otherButtonTitles:@"Reset", nil];
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 80.0, 260.0, 25.0)];
    textField.placeholder = @"Change hint for the passcode";
    [textField becomeFirstResponder];
    textField.backgroundColor = [UIColor whiteColor];
    textField.textAlignment = NSTextAlignmentCenter;
    [displayAlert addSubview:textField];
    [displayAlert show];

}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *recoveryHint = textField.text;
    //NSLog(@"Recover Hint: %@", recoveryHint);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    switch (buttonIndex) {
        case 1:
            if (textField.text == nil || [textField.text isEqualToString: @""]) {
            }
            else{
                [defaults setValue:recoveryHint forKey:@"RecoveryHint"];
                [defaults setBool:YES forKey:@"RecoverSet"];
                [defaults synchronize];
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


#pragma mark - KVPasscodeViewControllerDelegate

- (void)passcodeController:(KVPasscodeViewController *)controller passcodeEntered:(NSString *)passCode {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:passCode forKey:@"Passcode"];
    [defaults setBool:YES forKey:@"PasscodeSet"];
    [defaults synchronize];
    
    //Display Alert to user regarding what passcode they entered
    NSString *message = [[NSString alloc]
                         initWithFormat:@"Your Passcode is now set to: %@",
                         passCode];
    
    UIAlertView *notifyPasscode = [[UIAlertView alloc]
                                   initWithTitle:@"Confirmation"
                                   message:message
                                   delegate:self
                                   cancelButtonTitle:nil
                                   otherButtonTitles:@"OK", nil];
    [notifyPasscode show];
    
    //remove the PasscodeViewController
    [controller dismissModalViewControllerAnimated:YES];
}

@end
