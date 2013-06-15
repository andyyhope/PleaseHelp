//
//  ContactsTableViewCell.h
//  Please Help
//
//  Created by Adrian Jurcevic & Anddy Hope on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ContactsTableViewCell : UITableViewCell
{
    UIView *cellBackgroundView;
    UILabel *contactName;
    UILabel *contactRelation;
    UIImage *contactImage;
}

@property (nonatomic, retain) UILabel *contactName;
@property (nonatomic, retain) UILabel *contactRelation;
@property (nonatomic, retain) UIImage *contactImage;

@end
