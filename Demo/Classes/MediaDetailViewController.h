//
//  MediaDetailViewController.h
//  TelesocialSDK
//
//  Created on 8/10/11.
//  Copyright 2011 Telesocial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TelesocialSDK.h"
#import "Settings.h"
#import "Utility.h"
#import "ItemPickerViewController.h"

#define kBMCommandMediaStatus		1
#define kBMCommandRecordMedia		2
#define kBMCommandBlastMedia		3
#define kBMCommandRequestUpload		4
#define kBMCommandRemoveMedia		5

#define kBMNotificationRemoveMedia	@"notificationRemoveMedia"


@interface MediaDetailViewController : UITableViewController <TSRestClientDelegate> {

}

@property (nonatomic, retain) NSArray* cells;
@property (nonatomic, retain) NSString* currentMediaId;

- (id) initWithMediaId:(NSString*) mediaId;

@end
