//
//  ContactItem.h
//  DistressProto
//
//  Created by Adrian Jurcevic on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactItem : NSObject <NSCoding>

@property NSString *uuid;
@property NSString *name;
@property NSString *phone;
@property NSString *relation;
@property UIImage *image;

+ (ContactItem *)createUserWithName:(NSString *)name phone:(NSString *)phone;
+ (ContactItem *)createUserWithName:(NSString *)name phone:(NSString *)phone relation:(NSString *)relation andImage:(UIImage *)image;

+ (ContactItem *)createUserWithName:(NSString *)name andPhone:(NSString *)phone;
+ (ContactItem *)createUserWithName:(NSString *)name andPhone:(NSString *)phone andImage:(UIImage *)image;

@end
