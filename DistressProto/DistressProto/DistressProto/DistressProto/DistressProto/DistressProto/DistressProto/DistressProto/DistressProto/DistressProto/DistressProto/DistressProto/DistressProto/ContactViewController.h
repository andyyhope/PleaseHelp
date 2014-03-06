//
//  ContactViewController.h
//  DistressProto
//
//  Created by Andyy Hope on 6/05/13.
//  Copyright (c) 2013 ECU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AddContactViewController.h"
#import "EditContactViewController.h"

@interface ContactViewController : UITableViewController
<AddContactViewControllerDelegate, EditContactViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    
}

@end
