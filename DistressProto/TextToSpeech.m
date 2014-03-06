//
//  TextToSpeech.m
//  OpenEarsTest
//
//  Created by Andyy Hope on 15/06/13.
//  Copyright (c) 2013 Andyy Hope. All rights reserved.
//

#import "TextToSpeech.h"

@implementation TextToSpeech

-(id)init
{
    if (self = [super init])
    {

    }
    return self;
}


- (void)doYouWantToCall:(NSString *)contact
{
    // Perform Voice on new thread for performance optimization
    NSString *speechString = [NSString stringWithFormat:@"PRESS THE CALL BUTTON, TO PHONE, '%@'", contact];
    [self textToSpeech:speechString];
}
- (void)nowCalling:(NSString *)contact
{
    // Perform Voice on new thread for performance optimization
    NSString *speechString = [NSString stringWithFormat:@"CALLING %@", contact];
  [self textToSpeech:speechString];
}
- (void)optionWithContact:(NSString *)contact andNextContact:(NSString *)nextContact
{
    // Perform Voice on new thread for performance optimization
    NSString *speechString = [NSString stringWithFormat:@"DO YOU WANT TO TEXT MESSAGE, %@, OR CALL, %@", contact, nextContact];
    [self textToSpeech:speechString];
}
- (void)textMessageSentTo:(NSString *)contact
{
    // Perform Voice on new thread for performance optimization
    NSString *speechString = [NSString stringWithFormat:@"TEXT MESSAGE, SENT TO, %@", contact];
    [self textToSpeech:speechString];
}

-(void)textToSpeechEnabled
{
    NSString *speechString = @"VOICE ASSISTANCE, HAS BEEN ACTIVATED";
    [self textToSpeech:speechString];
}

- (void)say:(NSString *)message
{
    // Perform Voice on new thread for performance optimization
    [self textToSpeech:message];
}

-(void)textToSpeech:(NSString *)wholeString
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TextToSpeechEnabled"])
    {
        AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc]init];
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:wholeString];
        [utterance setRate:0.1f];
        [synthesizer speakUtterance:utterance];

    }
}
@end
