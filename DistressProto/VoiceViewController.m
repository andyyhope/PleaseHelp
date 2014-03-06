//
//  VoiceViewController.m
//  Please Help
//
//  Created by Adrian Jurcevic & Andyy Hope on 15/06/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "VoiceViewController.h"
#import "TextToSpeech.h"
#import "Appearance.h"

//Define the private variables for this class
@interface VoiceViewController ()
{
    UIScrollView *scrollView;
    TextToSpeech *textToSpeech;
    UISwitch *onOffSwitch;
    UILabel *warningLabel;
}
@end

@implementation VoiceViewController

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
	self.view.backgroundColor = kVIEW_BACKGROUND_COLOR;
    
    // Create a Scroll View to make the view non-static
    // ie, user can scroll and the view will bounce back to its original position
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 1);
    [self.view addSubview:scrollView];
    
    // Instantiate TextToSpeech class
    textToSpeech = [[TextToSpeech alloc] init];
    
    // Create View for Button
    UIView *textToSpeechView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 50)];
    textToSpeechView.backgroundColor = [UIColor whiteColor];
    textToSpeechView.layer.cornerRadius = kCELL_CORNER_RADIUS;
    [scrollView addSubview:textToSpeechView];
    
    // Create Label
    UILabel *textToSpeechLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 50)];
    textToSpeechLabel.text = @"Voice Assistance";
    [textToSpeechView addSubview:textToSpeechLabel];
    textToSpeechLabel.backgroundColor = [UIColor clearColor];
    textToSpeechLabel.font = kCELL_TEXT_FONT;
    textToSpeechLabel.textColor = kCELL_HEADER_FONT_COLOR;
    
    // Create On/Off Switch
    onOffSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(textToSpeechView.frame.size.width - 60, 11, 30, 30)];
    [onOffSwitch addTarget:self action:@selector(toggleSpeach) forControlEvents:UIControlEventValueChanged];
    [textToSpeechView addSubview:onOffSwitch];
    
    // Create a warning label for Text To Speech
    warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 70, 300, 60)];
    warningLabel.text = @"WARNING: Voice Assistance  can affect the phone's performance and response time.";
    [Appearance applySkinToLocationLabel:warningLabel];
    [scrollView addSubview:warningLabel];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TextToSpeechEnabled"])
    {
        onOffSwitch.on = TRUE;
        warningLabel.hidden = FALSE;
    } else
    {
        onOffSwitch.on = FALSE;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)toggleSpeach
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    
    // Update Switch based on User Settings
    if (onOffSwitch.on)
    {
        warningLabel.hidden = FALSE;
        // Switch is On
        [defaults setBool:TRUE forKey:@"TextToSpeechEnabled"];
        [textToSpeech textToSpeechEnabled];
        
    } else
    {
        // Switch is Off
        [defaults setBool:FALSE forKey:@"TextToSpeechEnabled"];
        warningLabel.hidden = TRUE;
    }
}

@end
