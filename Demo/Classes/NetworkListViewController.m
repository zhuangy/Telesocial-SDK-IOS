//
//  NetworkListViewController.m
//  TelesocialSDK
//
//  Created by Anton Minin on 8/9/11.
//  Copyright 2011 UMITI. All rights reserved.
//

#import "NetworkListViewController.h"


@implementation NetworkListViewController
@synthesize addNetworkCell;
@synthesize networks;


#pragma mark -
#pragma mark Initialization

- (id) init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
		self.addNetworkCell = [Utility cellWithTitle:@"Add a Network" tag:0 action:YES reuseIdentifier:@""];
		self.networks = [NSMutableArray arrayWithArray:[[Settings sharedSettings] loadNetworkList]];
		self.title = @"Networks";
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRemoveNetwork:) name:kBMNotificationRemoveNetwork object:nil];
    }
    return self;
}

- (void) dealloc {
	self.addNetworkCell = nil;
	self.networks = nil;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[super dealloc];
}

- (void) refreshNetworkList {
	[(UITableView*)self.view reloadData];
}

- (void) handleRemoveNetwork:(NSNotification*) notification {
	[networks removeObject:notification.object];
	[[Settings sharedSettings] saveNetworkList:networks];
	[self refreshNetworkList];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return [networks count];
	} else {
		return 1;
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
		return addNetworkCell;
	}
	
    static NSString *cellIdentifier = @"networkCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [Utility cellWithTitle:@"" tag:0 action:NO reuseIdentifier:cellIdentifier];
    }
	
	cell.textLabel.text = [networks objectAtIndex:indexPath.row];
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.section == 1) {
		[self.navigationController pushViewController:
		 [TextEntryViewController textEntryWithTitle:@"Network ID" 
									 placeholderText:@"networkid"
										initialValue:@""
								   validationMessage:@"Network ID can not be empty."
											  target:self 
											  action:@selector(networkIdEntryComplete:)]
											 animated:YES];
	} else {
	
		NSString* networkId = [networks objectAtIndex:indexPath.row];
		NetworkDetailViewController* networkDetail = [[[NetworkDetailViewController alloc] initWithNetworkId:networkId] autorelease];
		[self.navigationController pushViewController:networkDetail animated:YES];
	}
}


- (void) networkIdEntryComplete:(TextEntryViewController*) textEntry {
	[self.navigationController popViewControllerAnimated:YES];
	NSString* networkId = textEntry.textField.text;
	if ([networks indexOfObject:networkId] != NSNotFound) {
		[Utility alert:@"Network '%@' already exists.", networkId];
		return;
	}
	
	[networks addObject:networkId];
	[[Settings sharedSettings] saveNetworkList:networks];
	[self refreshNetworkList];
}

@end

