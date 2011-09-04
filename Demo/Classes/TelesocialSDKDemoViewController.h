//
//  TelesocialSDKDemoViewController.h
//  TelesocialSDKDemo
//
//  Created on 8/5/11.
//  Copyright 2011 Telesocial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TelesocialSDK.h"
#import "Utility.h"
#import "Settings.h"
#import "TextEntryViewController.h"
#import "NetworkListViewController.h"
#import "MediaListViewController.h"
#import "ConferenceListViewController.h"

#define kBMCommandNetworks		1
#define kBMCommandMedia			2
#define kBMCommandConferences	3
#define kBMCommandApiVersion	4
#define kBMCommandSetServiceUrl 5
#define kBMCommandSetAppKey		6

@interface TelesocialSDKDemoViewController : UITableViewController <TSRestClientDelegate>{
	UITableViewCell* serviceUrlCell;
	UITableViewCell* applicationKeyCell;
}

@property (nonatomic, retain) NSArray* sections;

- (void) refreshValues;

@end

