//
//  ContactsTableViewCell.h
//  PhoneCycleTest
//
//  Created by Andyy Hope on 22/04/13.
//  Copyright (c) 2013 Andyy Hope. All rights reserved.
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
