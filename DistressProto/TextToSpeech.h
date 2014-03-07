//
//  TextToSpeech.h
//  OpenEarsTest
//
//  Created by Andyy Hope on 15/06/13.
//  Copyright (c) 2013 Andyy Hope. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface TextToSpeech : NSObject
{
    
}

- (void)doYouWantToCall:(NSString *)contact;
- (void)nowCalling:(NSString *)contact;
- (void)optionWithContact:(NSString *)contact andNextContact:(NSString *)nextContact;
- (void)textMessageSentTo:(NSString *)contact;
- (void)textMessageInstructionToContact:(NSString *)contact;
- (void)say:(NSString *)message;
- (void)textToSpeechEnabled;
@end
