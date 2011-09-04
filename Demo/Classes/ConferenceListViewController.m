//
//  ConferenceListViewController.m
//  TelesocialSDK
//
//  Created on 8/10/11.
//  Copyright 2011 Telesocial. All rights reserved.
//

#import "ConferenceListViewController.h"


@implementation ConferenceListViewController
@synthesize conferences;
@synthesize createConferenceCell;
@synthesize leadNetworkId;
@synthesize greetingMediaId;
@synthesize recordingMediaId;

- (id) init {
	self = [super initWithStyle:UITableViewStyleGrouped];
	
	if (self) {
		self.conferences = [NSMutableArray arrayWithArray:[[Settings sharedSettings] loadConferenceList]];
		self.createConferenceCell = [Utility cellWithTitle:@"Start Conference Call" tag:0 action:YES reuseIdentifier:@""];
		self.title = @"Conference Calls";
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRemoveConference:) name:kBMNotificationRemoveConference object:nil];
	}
	
	return self;
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	self.conferences = nil;
	self.createConferenceCell = nil;
	
	[super dealloc];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (void) refreshConferenceList {
	[(UITableView*)self.view reloadData];
}

- (void) handleRemoveConference:(NSNotification*) notification {
	[conferences removeObject:notification.object];
	[self refreshConferenceList];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	if (section == 1) {
		return 1;
	} else {
		return [conferences count];
	}
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1) {
		return createConferenceCell;
	}
	
	
	static NSString* cellIdentifier = @"conferenceCell";
	
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [Utility cellWithTitle:@"" tag:0 action:NO reuseIdentifier:cellIdentifier];
	}
	
	cell.textLabel.text = [conferences objectAtIndex:indexPath.row];
	
	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.section == 1) {
		[self.navigationController pushViewController:
											 [[[ItemPickerViewController alloc] initWithTitle:@"Please pick a leading network for the conference call"
																						items:[[Settings sharedSettings] loadNetworkList]
																			   multipleSelect:NO
																					 required:YES
																					   target:self
																					   action:@selector(leadNetworkSelected:)] autorelease]
											 animated:YES];
	} else {
		[self.navigationController pushViewController:[[[ConferenceDetailViewController alloc] initWithConferenceId:[conferences objectAtIndex:indexPath.row]] autorelease]	animated:YES];
	}
}

- (void) leadNetworkSelected:(ItemPickerViewController*) picker {
	self.leadNetworkId = picker.selectedItem;
	
	[self.navigationController pushViewController:
	 [[[ItemPickerViewController alloc] initWithTitle:@"Please select the ID of the media to be played to conference participant. Select nothing to use the default greeting."
												items:[[Settings sharedSettings] loadMediaList]
									   multipleSelect:NO
											 required:NO
											   target:self
											   action:@selector(greetingMediaSelected:)] autorelease]
										 animated:YES];
	

}

- (void) greetingMediaSelected:(ItemPickerViewController*) picker {
	self.greetingMediaId = picker.selectedItem;
	[self.navigationController pushViewController:
	 [[[ItemPickerViewController alloc] initWithTitle:@"Please select the ID of the media to which the conference audio is to be recorded. Select nothing if you do not want to record the conference."
											   items:[[Settings sharedSettings] loadMediaList]
									  multipleSelect:NO
											required:NO
											  target:self
											  action:@selector(recordingMediaSelected:)] autorelease]
										animated:YES];
}

- (void) recordingMediaSelected:(ItemPickerViewController*) picker {
	[self.navigationController popToViewController:self animated:YES];
	
	self.recordingMediaId = picker.selectedItem;
	
	[Utility showActivityIndicator];
	[TSRestClient defaultClient].delegate = self;
	[[TSRestClient defaultClient] createConferenceWithNetwork:leadNetworkId	greetingId:greetingMediaId recordingId:recordingMediaId];
}

- (void) restClient:(TSRestClient *)client didCreateConferenceId:(NSString *)conferenceId withStatus:(TSStatus *)status {

	[Utility hideActivityIndicator];
	[Utility alert:@"Created conference %@ with status: %@", conferenceId, status];
	if ([status isOk]) {
		[conferences addObject:conferenceId];
		[self refreshConferenceList];
	}
}

@end
