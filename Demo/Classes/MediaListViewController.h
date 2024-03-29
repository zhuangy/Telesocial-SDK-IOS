//
//  MediaListViewController.h
//  TelesocialSDK
//
//  Created on 8/10/11.
//  Copyright 2011 Telesocial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TelesocialSDK.h"
#import "Settings.h"
#import "Utility.h"
#import "MediaDetailViewController.h"

#define kCommandMediaListAdd	1
#define kCommandMediaListList	2

@interface MediaListViewController : UITableViewController <TSRestClientDelegate>{

}

@property (nonatomic, retain) NSMutableArray* mediaList;
@property (nonatomic, retain) UITableViewCell* createMediaCell;
@property (nonatomic, retain) UITableViewCell* listMediaCell;

@end
