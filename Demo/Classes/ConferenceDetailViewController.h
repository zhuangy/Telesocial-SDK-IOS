//
//  ConferenceDetailViewController.h
//  TelesocialSDK
//
//  Created on 8/12/11.
//  Copyright 2011 Telesocial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TelesocialSDK.h"
#import "ItemPickerViewController.h"
#import "Settings.h"
#import "Utility.h"

#define kBMNotificationRemoveConference	@"notificationRemoveMedia"

#define kBMCommandAddNetwork		1
#define kBMCommandHangup			2
#define kBMCommandMove				3
#define kBMCommandMute				4
#define kBMCommandUnmute			5
#define kBMCommandClose				6

@interface ConferenceDetailViewController : UITableViewController <TSRestClientDelegate>{

}

@property (nonatomic, retain) NSString* currentConferenceId;
@property (nonatomic, retain) NSArray* cells;
@property (nonatomic, retain) NSArray* networksToAdd;
@property (nonatomic, retain) NSString* greetingMediaId;
@property (nonatomic, retain) NSString* networkIdToMove;
@property (nonatomic, retain) NSString* targetConferenceId;

- (id) initWithConferenceId:(NSString*) conferenceId;

@end
