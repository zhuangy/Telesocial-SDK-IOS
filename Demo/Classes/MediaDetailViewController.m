//
//  MediaDetailViewController.m
//  TelesocialSDK
//
//  Created on 8/10/11.
//  Copyright 2011 Telesocial. All rights reserved.
//

#import "MediaDetailViewController.h"



@implementation MediaDetailViewController
@synthesize cells;
@synthesize currentMediaId;

- (id) initWithMediaId:(NSString *)mediaId {

	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		self.currentMediaId = mediaId;
		
		self.cells = [NSArray arrayWithObjects:
					  [Utility cellWithTitle:@"Status" tag:kBMCommandMediaStatus action:YES reuseIdentifier:@""],
					  [Utility cellWithTitle:@"Record" tag:kBMCommandRecordMedia action:YES reuseIdentifier:@""],
					  [Utility cellWithTitle:@"Blast" tag:kBMCommandBlastMedia action:YES reuseIdentifier:@""],
					  [Utility cellWithTitle:@"Upload MP3" tag:kBMCommandRequestUpload action:YES reuseIdentifier:@""],
					  [Utility cellWithTitle:@"Remove" tag:kBMCommandRemoveMedia action:YES reuseIdentifier:@""],
					  nil];
		self.title = mediaId;
	}
	
	return self;
}

- (void) dealloc {
	self.cells = nil;
	self.currentMediaId = nil;
	
	[super dealloc];
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
		case kBMCommandMediaStatus:
			[Utility showActivityIndicator];
			[[TSRestClient defaultClient] getMediaStatus:currentMediaId];
			break;
		case kBMCommandRecordMedia:
			[self.navigationController pushViewController:
			 [[[ItemPickerViewController alloc] initWithTitle:@"Please select a network ID to call." 
														items:[[Settings sharedSettings] loadNetworkList]
											   multipleSelect:NO
													 required:YES
													   target:self
													   action:@selector(itemForRecordPicked:)] autorelease]
												 animated:YES];
			break;

		case kBMCommandBlastMedia:
			[self.navigationController pushViewController:
			 [[[ItemPickerViewController alloc] initWithTitle:@"Please select a network ID to call." 
														items:[[Settings sharedSettings] loadNetworkList]
											   multipleSelect:NO
													 required:YES
													   target:self
													   action:@selector(itemForBlastPicked:)] autorelease]
												 animated:YES];
			break;
		case kBMCommandRequestUpload:
			[Utility showActivityIndicator];

			[[TSRestClient defaultClient] requestUploadGrantForMedia:currentMediaId];
			break;

			
		case kBMCommandRemoveMedia:
			[Utility confirmTarget:self action:@selector(removeCurrentMediaFromServer) message:@"Remove media %@?", currentMediaId]; 
			break;
		default:
			break;
	}
}

- (void) itemForRecordPicked:(ItemPickerViewController*) picker {
	[self.navigationController popViewControllerAnimated:YES];
	NSString* networkId = picker.selectedItem;
	[Utility showActivityIndicator];
	[[TSRestClient defaultClient] recordMedia:currentMediaId network:networkId];
}

- (void) itemForBlastPicked:(ItemPickerViewController*) picker {
	[self.navigationController popViewControllerAnimated:YES];
	
	NSString* networkId = picker.selectedItem;
	[Utility showActivityIndicator];
	[[TSRestClient defaultClient] blastMedia:currentMediaId network:networkId];
}


- (void) removeCurrentMediaFromServer {
	[Utility showActivityIndicator];
	[[TSRestClient defaultClient] removeMedia:currentMediaId];
}

- (void) restClient:(TSRestClient *)client didReceiveStatus:(TSStatus *)status forMedia:(TSMediaInfo *)mediaInfo {
	[Utility hideActivityIndicator];
	[Utility alert:@"Media status is %@", status];
}

- (void) removeCurrentMediaFromList {
	[[NSNotificationCenter defaultCenter] postNotificationName:kBMNotificationRemoveMedia object:currentMediaId];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) restClient:(TSRestClient *)client didRemoveMediaId:(NSString *)mediaId withStatus:(TSStatus *)status {
	[Utility hideActivityIndicator];
	if (status.code == kBMStatusOk) {
		[self removeCurrentMediaFromList];
	} else {
		[Utility confirmTarget:self 
						action:@selector(removeCurrentMediaFromList) 
					   message:@"Failed to remove media from the server, status: %@. \n\nDo you want to remove it from the list anyway?", status];
	}
}

- (void) restClient:(TSRestClient *)client didRecordMedia:(TSMediaInfo *)mediaInfo withStatus:(TSStatus *)status {
	[Utility hideActivityIndicator];
	[Utility alert:@"Record media call completed, status: %@", status];
}

- (void) restClient:(TSRestClient *)client didBlastMedia:(TSMediaInfo *)mediaInfo withStatus:(TSStatus *)status {
	[Utility hideActivityIndicator];
	[Utility alert:@"Blast media completed, status: %@", status];
}

- (void) restClient:(TSRestClient *)client didReceiveUploadGrant:(NSString *)grantId withStatus:(TSStatus *)status {

	if (status.code == kBMStatusCreated) {
        [[TSRestClient defaultClient] uploadData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sample" ofType:@"mp3"]] withGrantCode:grantId];
	} else {
        [Utility hideActivityIndicator];    
		[Utility alert:@"Failed to allocate upload grant code. Status: %@", status];
	}
}

- (void)restClient:(TSRestClient *)client didUploadToUrl:(NSString *)urlString status:(TSStatus *)status {
	[Utility hideActivityIndicator];    
    if ([status isOk]) {
        [Utility alert:@"Upload complete, media URL is %@", urlString];
    } else {
        [Utility alert:@"Upload failed with status %@", status];
   }
}

@end
