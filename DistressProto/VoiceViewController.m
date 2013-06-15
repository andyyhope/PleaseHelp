//
//  VoiceViewController.m
//  DistressProto
//
//  Created by Andyy Hope on 15/06/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "VoiceViewController.h"
#import "TextToSpeech.h"

@interface VoiceViewController ()
{
    TextToSpeech *textToSpeech;
    UISwitch *onOffSwitch;
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
    
    // Instantiate TextToSpeech class
    textToSpeech = [[TextToSpeech alloc] init];
    
    // Create View for Button
    UIView *textToSpeechView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 50)];
    textToSpeechView.backgroundColor = [UIColor whiteColor];
    textToSpeechView.layer.cornerRadius = kCELL_CORNER_RADIUS;
    [self.view addSubview:textToSpeechView];
    
    // Create Label
    UILabel *textToSpeechLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 50)];
    textToSpeechLabel.text = @"Text To Speech";
    [textToSpeechView addSubview:textToSpeechLabel];
    textToSpeechLabel.backgroundColor = [UIColor clearColor];
    textToSpeechLabel.font = kCELL_TEXT_FONT;
    textToSpeechLabel.textColor = kCELL_HEADER_FONT_COLOR;
    
    // Create On/Off Switch
    onOffSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(210, 11, 30, 30)];
    [onOffSwitch addTarget:self action:@selector(toggleSpeach) forControlEvents:UIControlEventAllEvents];
    [textToSpeechView addSubview:onOffSwitch];
    
    [self toggleSpeach];
    

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
        // Switch is On
        [defaults setBool:TRUE forKey:@"TextToSpeechEnabled"];
        [textToSpeech textToSpeechEnabled];
    } else
    {
        // Switch is Off
        [defaults setBool:FALSE forKey:@"TextToSpeechEnabled"];
    }
}
@end
