//
//  ContactsTableViewCell.m
//  PhoneCycleTest
//
//  Created by Andyy Hope on 22/04/13.
//  Copyright (c) 2013 Andyy Hope. All rights reserved.
//

#import "ContactsTableViewCell.h"
#import "AppearanceConstants.h"

@implementation ContactsTableViewCell
@synthesize contactName, contactRelation;
@synthesize contactImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cellBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, self.contentView.frame.size.width - 20, 110)];
        cellBackgroundView.backgroundColor = kCELL_BACKGROUND_COLOR;
        cellBackgroundView.layer.cornerRadius = kCELL_CORNER_RADIUS;
        
        
        self.contactName = [[UILabel alloc] initWithFrame:CGRectMake(120, 20, 180, 30)];
        self.contactRelation = [[UILabel alloc] initWithFrame:CGRectMake(120, 60, 180, 30)];
        self.contactImage = [[UIImage alloc] init];
        
        
        self.contactName.numberOfLines = 1;
        self.contactRelation.numberOfLines = 1;
        
        self.contactName.backgroundColor = [UIColor clearColor];
        self.contactRelation.backgroundColor = self.contactName.backgroundColor;
        
        self.contactName.font = kCELL_HEADER_FONT;
        self.contactRelation.font = kCELL_TEXT_FONT;
        
        //self.contactName.textAlignment = NSTextAlignmentCenter;
        //self.contactRelation.textAlignment = NSTextAlignmentCenter;
        
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
        self.contactName.textAlignment = UITextAlignmentCenter;
        self.contactRelation.textAlignment = UITextAlignmentCenter;
#else
        self.contactName.textAlignment = NSTextAlignmentCenter;
        self.contactRelation.textAlignment = NSTextAlignmentCenter;
#endif

        self.contactName.textColor = kCELL_HEADER_FONT_COLOR;
        self.contactRelation.textColor = kCELL_TEXT_FONT_COLOR;
        
        self.accessoryType = UITableViewCellAccessoryNone;
        
        [self.contentView addSubview:cellBackgroundView];
        [self.contentView addSubview:self.contactName];
        [self.contentView addSubview:self.contactRelation];
        //[self.contentView addSubview:contactImage];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (self.isSelected == true)
    {
        cellBackgroundView.backgroundColor = [UIColor lightGrayColor];
    } else
    {
        cellBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    // Configure the view for the selected state
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(20, 15, 90, 90);
    self.imageView.layer.cornerRadius = kCELL_CORNER_RADIUS;
    self.imageView.layer.masksToBounds = YES;
    
}

@end
