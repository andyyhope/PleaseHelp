//
//  ContactItem.h
//  Please Help
//
//  Created by Adrian Jurcevic & Andyy Hope on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//
//  This class defines the items that are saved for an individual contact
//

#import <Foundation/Foundation.h>

@interface ContactItem : NSObject <NSCoding>

@property NSString *uuid;
@property NSString *name;
@property NSString *phone;
@property NSString *relation;
@property UIImage *image;

+ (ContactItem *)createUserWithName:(NSString *)name andPhone:(NSString *)phone andRelation:(NSString *)relation andImage:(UIImage *)image;

@end
