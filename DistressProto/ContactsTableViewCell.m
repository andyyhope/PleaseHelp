//
//  ContactsTableViewCell.m
//  Please Help
//
//  Created by Adrian Jurcevic & Andyy Hope on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import "ContactsTableViewCell.h"

@implementation ContactsTableViewCell
@synthesize contactName;
@synthesize contactRelation;
@synthesize contactImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // Setup Table Cell Style
        cellBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, self.contentView.frame.size.width - 20, 110)];
        cellBackgroundView.backgroundColor = kCELL_BACKGROUND_COLOR;
        cellBackgroundView.layer.cornerRadius = kCELL_CORNER_RADIUS;
        
        // Labels for Name, Relation
        // Image for Contact Image
        self.contactName = [[UILabel alloc] initWithFrame:CGRectMake(120, 20, 180, 60)];
        self.contactRelation = [[UILabel alloc] initWithFrame:CGRectMake(120, 70, 180, 30)];
        self.contactImage = [[UIImage alloc] init];
        
        // Skin the Labels
        self.contactName.numberOfLines = 0;
        self.contactRelation.numberOfLines = 1;
        
        self.contactName.backgroundColor = [UIColor clearColor];
        self.contactRelation.backgroundColor = self.contactName.backgroundColor;
        
        self.contactName.font = kCELL_HEADER_FONT;
        self.contactRelation.font = kCELL_TEXT_FONT;
      
        self.contactName.textAlignment = NSTextAlignmentCenter;
        self.contactRelation.textAlignment = NSTextAlignmentCenter;

        self.contactName.textColor = kCELL_HEADER_FONT_COLOR;
        self.contactRelation.textColor = kCELL_TEXT_FONT_COLOR;
        
        // Remove Accessory Type
        self.accessoryType = UITableViewCellAccessoryNone;
        
        // Add to Content View
        [self.contentView addSubview:cellBackgroundView];
        [self.contentView addSubview:self.contactName];
        [self.contentView addSubview:self.contactRelation];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    if (self.isSelected == true)
    {
        cellBackgroundView.backgroundColor = [UIColor lightGrayColor];
    } else
    {
        cellBackgroundView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)layoutSubviews
{
    // Apply skin to Image
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(20, 15, 90, 90);
    self.imageView.layer.cornerRadius = kCELL_CORNER_RADIUS;
    self.imageView.layer.masksToBounds = YES;
    
}

@end
