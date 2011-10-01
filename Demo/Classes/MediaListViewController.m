//
//  MediaListViewController.m
//  TelesocialSDK
//
//  Created on 8/10/11.
//  Copyright 2011 Telesocial. All rights reserved.
//

#import "MediaListViewController.h"


@implementation MediaListViewController
@synthesize mediaList;
@synthesize createMediaCell;
@synthesize listMediaCell;

- (id) init {

	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		self.mediaList = [NSMutableArray arrayWithArray:[[Settings sharedSettings] loadMediaList]];
		self.createMediaCell = [Utility cellWithTitle:@"Create Media" tag:kCommandMediaListAdd action:YES reuseIdentifier:@""];
		self.listMediaCell = [Utility cellWithTitle:@"List Media" tag:kCommandMediaListList action:YES reuseIdentifier:@""];
		self.title = @"Media List";
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRemoveMedia:) name:kBMNotificationRemoveMedia object:nil];
	}
	
	return self;
}

- (void) dealloc {
	self.mediaList = nil;
	self.createMediaCell = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[super dealloc];
}

- (void) refreshMediaList {
	[(UITableView*)self.view reloadData];
}

- (void) handleRemoveMedia:(NSNotification*) notification {
	[mediaList removeObject:notification.object];
	[self refreshMediaList];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 1) {
		return 2;
	} else {
		return [mediaList count];
	}
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			return createMediaCell;
		} else {
			return listMediaCell;
		}
	}
	
    static NSString *cellIdentifier = @"mediaCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [Utility cellWithTitle:@"" tag:0 action:NO reuseIdentifier:cellIdentifier];
    }
	
	cell.textLabel.text = [mediaList objectAtIndex:indexPath.row];
	
	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[TSRestClient defaultClient].delegate = self;
	
	if (indexPath.section == 1) {
		UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
		switch (cell.tag) {
			case kCommandMediaListAdd:
				[Utility showActivityIndicator];
				[[TSRestClient defaultClient] createMedia];
				break;
			case kCommandMediaListList:
				[Utility showActivityIndicator];
				[[TSRestClient defaultClient] getMediaIds];
				break;
			default:
				break;
		}
	} else {
		NSString* mediaId = [mediaList objectAtIndex:indexPath.row];
		[self.navigationController pushViewController:[[[MediaDetailViewController alloc] initWithMediaId:mediaId] autorelease] animated:YES];
	}
}

- (void) restClient:(TSRestClient *)client didReceiveMediaIdsWithStatus:(TSStatus *)status recorded:(NSArray *)recorded uploaded:(NSArray *)uploaded {
	[Utility hideActivityIndicator];
	
	if ([status isOk]) {
		[Utility alert:@"Status: %@", status];
		[mediaList removeAllObjects];
		NSLog(@"Class: %@", [recorded class]);
		[mediaList addObjectsFromArray:recorded];
		[mediaList addObjectsFromArray:uploaded];
		[[Settings sharedSettings] saveMediaList:mediaList];
		[self refreshMediaList];
	} else {
		[Utility alert:@"Failed to get media IDs: %@", status];
	}
}

- (void) restClient:(TSRestClient *)client didCreateMedia:(TSMediaInfo *)mediaInfo withStatus:(TSStatus *)status {
	[Utility hideActivityIndicator];
	
	if (status.code == kBMStatusCreated) {
		[Utility alert:@"Successfuly created new media id: %@", mediaInfo.id];
		[mediaList addObject:mediaInfo.id];
		[[Settings sharedSettings] saveMediaList:mediaList];
		[self refreshMediaList];
	} else {
		[Utility alert:@"Failed to create new media, status: %@", status];
	}
}


@end
