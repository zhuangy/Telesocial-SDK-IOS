//
//  NetworkListViewController.h
//  TelesocialSDK
//
//  Created on 8/9/11.
//  Copyright 2011 Telesocial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "Settings.h"
#import "TextEntryViewController.h"
#import "Utility.h"
#import "NetworkDetailViewController.h"

@interface NetworkListViewController : UITableViewController {

}

@property (nonatomic, retain) NSMutableArray* networks;
@property (nonatomic, retain) UITableViewCell* addNetworkCell;

@end
