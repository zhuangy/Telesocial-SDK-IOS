//
//  ConferenceDetailViewController.m
//  TelesocialSDK
//
//  Created by Anton Minin on 8/12/11.
//  Copyright 2011 UMITI. All rights reserved.
//

#import "ConferenceDetailViewController.h"


@implementation ConferenceDetailViewController
@synthesize currentConferenceId;
@synthesize cells;
@synthesize networksToAdd;
@synthesize greetingMediaId;
@synthesize networkIdToMove;
@synthesize targetConferenceId;

- (id) initWithConferenceId:(NSString *)conferenceId {
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		self.currentConferenceId = conferenceId;
		self.cells = [NSArray arrayWithObjects:
					  [Utility cellWithTitle:@"Add Network" tag:kBMCommandAddNetwork action:YES reuseIdentifier:@""],
					  [Utility cellWithTitle:@"Hangup" tag:kBMCommandHangup action:YES reuseIdentifier:@""],
					  [Utility cellWithTitle:@"Move" tag:kBMCommandMove action:YES reuseIdentifier:@""],
					  [Utility cellWithTitle:@"Mute" tag:kBMCommandMute action:YES reuseIdentifier:@""],
					  [Utility cellWithTitle:@"Unumte" tag:kBMCommandUnmute action:YES reuseIdentifier:@""],
					  [Utility cellWithTitle:@"Close Conference" tag:kBMCommandClose action:YES reuseIdentifier:@""],
					  nil];
	}
	
	return self;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [cells count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [cells objectAtIndex:indexPath.row];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	UITableViewCell* cell = [cells objectAtIndex:indexPath.row];
	[TSRestClient defaultClient].delegate = self;
	switch (cell.tag) {
		case kBMCommandAddNetwork:
			[self.navigationController pushViewController:
			 [[[ItemPickerViewController alloc] initWithTitle:@"Please select one or more networks to add to this conference."
														items:[[Settings sharedSettings] loadNetworkList]
											   multipleSelect:YES
													 required:YES
													   target:self
													   action:@selector(networksToAddSelected:)] autorelease]
												 animated:YES];
			break;
		case kBMCommandHangup:
			[self.navigationController pushViewController:
			 [[[ItemPickerViewController alloc] initWithTitle:@"Please select a network to hangup."
														items:[[Settings sharedSettings] loadNetworkList]
											   multipleSelect:NO
													 required:YES
													   target:self
													   action:@selector(networkToHangupSelected:)] autorelease]
												 animated:YES];
			break;
		case kBMCommandMove:
			[self.navigationController pushViewController:
			 [[[ItemPickerViewController alloc] initWithTitle:@"Please select the ID of the network to move to other conference."
														items:[[Settings sharedSettings] loadNetworkList]
											   multipleSelect:NO
													 required:YES
													   target:self
													   action:@selector(networkToMoveSelected:)] autorelease]
												 animated:YES];
			
			break;
		case kBMCommandMute:
			[self.navigationController pushViewController:
			 [[[ItemPickerViewController alloc] initWithTitle:@"Please select the ID of the network to mute."
														items:[[Settings sharedSettings] loadNetworkList]
											   multipleSelect:NO
													 required:YES
													   target:self
													   action:@selector(networkToMuteSelected:)] autorelease]
												 animated:YES];
			
			break;

		case kBMCommandUnmute:
			[self.navigationController pushViewController:
			 [[[ItemPickerViewController alloc] initWithTitle:@"Please select the ID of the network to unmute."
														items:[[Settings sharedSettings] loadNetworkList]
											   multipleSelect:NO
													 required:YES
													   target:self
													   action:@selector(networkToUnmuteSelected:)] autorelease]
												 animated:YES];
			
			break;
			

		case kBMCommandClose:
			[Utility showActivityIndicator];
			[[TSRestClient defaultClient] closeConference:currentConferenceId];
			break;
		default:
			break;
	}
}

- (void) networksToAddSelected:(ItemPickerViewController*) picker {
	self.networksToAdd = picker.selectedItems;
	
	[self.navigationController pushViewController:
	 [[[ItemPickerViewController alloc] initWithTitle:@"Please select the ID of the media to be played to the conference new participants.\n\nSelect nothing to use the default greeting."
												items:[[Settings sharedSettings] loadMediaList]
									   multipleSelect:NO
											 required:NO
											   target:self
											   action:@selector(greetingMediaIdSelected:)] autorelease]
										 animated:YES];
}

- (void) greetingMediaIdSelected:(ItemPickerViewController*) picker {
	[self.navigationController popToViewController:self animated:YES];
	self.greetingMediaId = picker.selectedItem;
	
	[Utility showActivityIndicator];
	[[TSRestClient defaultClient] addNetworks:networksToAdd toConference:currentConferenceId greetingId:greetingMediaId];
}

- (void) restClient:(TSRestClient *)client didAddNetworksToConference:(NSString *)confrenceId withStatus:(TSStatus *)status {
	[Utility hideActivityIndicator];
	[Utility alert:@"Added networks to the conference with status %@", status];
}

- (void) networkToHangupSelected:(ItemPickerViewController*) picker {
	[self.navigationController popViewControllerAnimated:YES];
	[Utility showActivityIndicator];
	[[TSRestClient defaultClient] hangupNetwork:picker.selectedItem inConference:currentConferenceId];
}								  

- (void) restClient:(TSRestClient *)client didHangupNetworkId:(NSString *)networkId inConferenceId:(NSString *)conferenceId withStatus:(TSStatus *)status {
	[Utility hideActivityIndicator];
	[Utility alert:@"Hung up network with status %@", status];
}


- (void) networkToMoveSelected:(ItemPickerViewController*) picker {
	self.networkIdToMove = picker.selectedItem;
	
	[self.navigationController pushViewController:
	 [[[ItemPickerViewController alloc] initWithTitle:@"Please select the ID of the conference to move selected network to."
												items:[[Settings sharedSettings] loadConferenceList]
									   multipleSelect:NO
											 required:YES
											   target:self
											   action:@selector(targetConferenceSelected:)] autorelease]
										 animated:YES];
}

- (void) targetConferenceSelected:(ItemPickerViewController*) picker {
	[self.navigationController popToViewController:self animated:YES];
	self.targetConferenceId = picker.selectedItem;
	
	[Utility showActivityIndicator];
	[[TSRestClient defaultClient] moveNetwork:networkIdToMove fromConference:currentConferenceId toConference:targetConferenceId];
}

- (void) restClient:(TSRestClient *)client didMoveWithStatus:(TSStatus *)status {
	[Utility hideActivityIndicator];
	[Utility alert:@"Moved network with status %@", status];
}

- (void) networkToMuteSelected:(ItemPickerViewController*) picker {
	[Utility showActivityIndicator];
	[[TSRestClient defaultClient] setMute:YES forNetwork:picker.selectedItem inConference:currentConferenceId];
}

- (void) networkToUnmuteSelected:(ItemPickerViewController*) picker {
	[Utility showActivityIndicator];
	[[TSRestClient defaultClient] setMute:NO forNetwork:picker.selectedItem inConference:currentConferenceId];
}

- (void) restClient:(TSRestClient *)client didMuteWithStatus:(TSStatus *)status {
	[Utility hideActivityIndicator];
	[Utility alert:@"Set mute call completed with status %@", status];
}


- (void) removeCurrentConferenceFromList {
	[[NSNotificationCenter defaultCenter] postNotificationName:kBMNotificationRemoveConference object:currentConferenceId];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) restClient:(TSRestClient *)client didCloseConferenceId:(NSString *)confefenceId withStatus:(TSStatus *)status {
	[Utility hideActivityIndicator];
	if (status.code == kBMStatusOk) {
		[Utility alert:@"Successfuly closed conference."];
		[self removeCurrentConferenceFromList];
	} else {
		[Utility confirmTarget:self action:@selector(removeCurrentConferenceFromList) message:@"Failed to close conference, status: %@\n\nDo you want to remove it from the list anyway?", 
		 status];
	}
}

- (void) dealloc {

	self.cells = nil;
	self.currentConferenceId = nil;
	
	[super dealloc];
}

@end
