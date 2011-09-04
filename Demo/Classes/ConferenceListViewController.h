//
//  ConferenceListViewController.h
//  TelesocialSDK
//
//  Created on 8/10/11.
//  Copyright 2011 Telesocial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utility.h"
#import "Settings.h"
#import "ConferenceDetailViewController.h"
#import "ItemPickerViewController.h"

@interface ConferenceListViewController : UITableViewController <TSRestClientDelegate>{

}

@property (nonatomic, retain) NSMutableArray* conferences;
@property (nonatomic, retain) UITableViewCell* createConferenceCell;

@property (nonatomic, retain) NSString* leadNetworkId;
@property (nonatomic, retain) NSString* greetingMediaId;
@property (nonatomic, retain) NSString* recordingMediaId;

@end
