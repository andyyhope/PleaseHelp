//
//  ContactItem.m
//  DistressProto
//
//  Created by Adrian Jurcevic on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "ContactItem.h"

@implementation ContactItem

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    
    if (self) {
        [self setUuid:[decoder decodeObjectForKey:@"uuid"]];
        [self setName:[decoder decodeObjectForKey:@"name"]];
        [self setPhone:[decoder decodeObjectForKey:@"phone"]];
        [self setRelation:[decoder decodeObjectForKey:@"relation"]];
        [self setImage:[decoder decodeObjectForKey:@"image"]];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.uuid forKey:@"uuid"];
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.phone forKey:@"phone"];
    [coder encodeObject:self.relation forKey:@"relation"];
    [coder encodeObject:self.image forKey:@"image"];
}

+ (ContactItem *)createUserWithName:(NSString *)name andPhone:(NSString *)phone andRelation:(NSString *)relation andImage:(UIImage *)image
{
    ContactItem *item = [[ContactItem alloc] init];
    
    [item setName:name];
    [item setPhone:phone];
    [item setImage:image];
    [item setRelation:relation];
    [item setUuid:[[NSUUID UUID] UUIDString]];
    
    return item;
}

+ (ContactItem *)createUserWithName:(NSString *)name andPhone:(NSString *)phone andRelation:(NSString *)relation
{
    ContactItem *item = [[ContactItem alloc] init];
    
    [item setName:name];
    [item setPhone:phone];
    [item setRelation:relation];
    [item setUuid:[[NSUUID UUID] UUIDString]];
    
    return item;
}

@end
