//
//  ContactsTableViewCell.h
//  Please Help
//
//  Created by Adrian Jurcevic & Andyy Hope on 28/04/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//
//  This class file defines the visual construction of a single cell for the Contacts TableView for the MainContactViewController
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
