//
//  TextToSpeech.m
//  OpenEarsTest
//
//  Created by Andyy Hope on 15/06/13.
//  Copyright (c) 2013 Andyy Hope. All rights reserved.
//

#import "TextToSpeech.h"

@implementation TextToSpeech
@synthesize fliteController;
@synthesize slt;
-(id)init
{
    if (self = [super init])
    {
        
        self.fliteController=[[FliteController alloc] init];
        self.slt = [[Slt alloc] init];
        
        self.fliteController.duration_stretch = 1.1f;
    }
    return self;
}


- (FliteController *)fliteController {
	if (fliteController == nil) {
		fliteController = [[FliteController alloc] init];
	}
	return fliteController;
}

- (Slt *)slt {
	if (slt == nil) {
		slt = [[Slt alloc] init];
	}
	return slt;
}


- (void)doYouWantToCall:(NSString *)contact
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TextToSpeechEnabled"])
    {
        [self.fliteController say:[NSString stringWithFormat:@"PRESS THE CALL BUTTON, TO PHONE, '%@'", contact] withVoice:self.slt];
    }
    
}
- (void)nowCalling:(NSString *)contact
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TextToSpeechEnabled"])
    {
        [self.fliteController say:[NSString stringWithFormat:@"CALLING %@", contact] withVoice:self.slt];
    }
    
}
- (void)optionWithContact:(NSString *)contact andNextContact:(NSString *)nextContact
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TextToSpeechEnabled"])
    {
        [self.fliteController say:[NSString stringWithFormat:@"DO YOU WANT TO TEXT MESSAGE, %@, OR CALL, %@", contact, nextContact] withVoice:self.slt];
    }
    
}
- (void)textMessageSentTo:(NSString *)contact
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TextToSpeechEnabled"])
    {
        [self.fliteController say:[NSString stringWithFormat:@"TEXT MESSAGE, SENT TO, %@", contact] withVoice:self.slt];
    }
    
}

-(void)textToSpeechEnabled
{
    
        [self.fliteController say:@"VOICE ASSISTANCE, HAS BEEN ACTIVATED" withVoice:self.slt];

}

- (void)say:(NSString *)message
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TextToSpeechEnabled"])
    {
        [self.fliteController say:message withVoice:self.slt];
    }
}
@end
