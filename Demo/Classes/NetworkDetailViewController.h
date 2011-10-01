//
//  NetworkDetailViewController.h
//  TelesocialSDK
//
//  Created on 8/9/11.
//  Copyright 2011 Telesocial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TelesocialSDK.h"
#import "Utility.h"
#import "Settings.h"
#import "TextEntryViewController.h"

#define kCommandNetworkStatus			1
#define kCommandNetworkRegister			2
#define kCommandRemoveFromList			3
#define kCommandNetworkStatusRelated	4
#define kCommandChangePhoneNumber		5

#define kBMNotificationRemoveNetwork	@"notificationRemoveNetwork"

@interface NetworkDetailViewController : UITableViewController <TSRestClientDelegate> {

}

@property (nonatomic, retain) NSString* currentNetworkId;
@property (nonatomic, retain) NSArray* cells;

- (id)initWithNetworkId:(NSString*) aNetworkId;

@end
