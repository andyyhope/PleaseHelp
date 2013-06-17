//
//  TextToSpeech.h
//  OpenEarsTest
//
//  Created by Andyy Hope on 15/06/13.
//  Copyright (c) 2013 Andyy Hope. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>

@interface TextToSpeech : NSObject
{

    FliteController *fliteController;
    Slt *slt;
    
}

@property (strong, nonatomic) FliteController *fliteController;
@property (strong, nonatomic) Slt *slt;

- (void)doYouWantToCall:(NSString *)contact;
- (void)nowCalling:(NSString *)contact;
- (void)optionWithContact:(NSString *)contact andNextContact:(NSString *)nextContact;
- (void)textMessageSentTo:(NSString *)contact;
- (void)say:(NSString *)message;
-(void)textToSpeechEnabled;
@end
