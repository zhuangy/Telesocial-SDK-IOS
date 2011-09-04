//
//  NetworkDetailViewController.m
//  TelesocialSDK
//
//  Created on 8/9/11.
//  Copyright 2011 Telesocial. All rights reserved.
//

#import "NetworkDetailViewController.h"


@implementation NetworkDetailViewController
@synthesize currentNetworkId;
@synthesize cells;

#pragma mark -
#pragma mark Initialization


- (id)initWithNetworkId:(NSString*) aNetworkId{

    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
		self.currentNetworkId = aNetworkId;
		self.title = aNetworkId;
		self.cells = [NSArray arrayWithObjects:
					  [Utility cellWithTitle:@"Register" tag:kCommandNetworkRegister action:YES reuseIdentifier:@""],
					  [Utility cellWithTitle:@"Get Status - Check if Exists" tag:kCommandNetworkStatus action:YES reuseIdentifier:@""],
  					  [Utility cellWithTitle:@"Get Status - Check if Related" tag:kCommandNetworkStatusRelated action:YES reuseIdentifier:@""],
					  [Utility cellWithTitle:@"Remove from the List" tag:kCommandRemoveFromList action:YES reuseIdentifier:@""],
					  nil];
    }
    return self;
}

#pragma mark -
#pragma mark View lifecycle

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [cells count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [cells objectAtIndex:indexPath.row];
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	UITableViewCell* cell = [cells objectAtIndex:indexPath.row];
	[TSRestClient defaultClient].delegate = self;
	switch (cell.tag) {
		case kCommandNetworkRegister: {
			TextEntryViewController* textEntry =[TextEntryViewController 
												 textEntryWithTitle:@"Phone Number"
													placeholderText:@"1234567890"
													   initialValue:@""
												  validationMessage:@"Please provide a phone number"
															 target:self
												  action:@selector(phoneNumberEntryComplete:)];
			textEntry.textField.keyboardType = UIKeyboardTypePhonePad;
			[self.navigationController pushViewController:textEntry animated:YES];

			break;
		}
		case kCommandNetworkStatus:
			[Utility showActivityIndicator];
			[[TSRestClient defaultClient] getRegistrationStatus:currentNetworkId checkRelated:NO];
			break;		
		case kCommandNetworkStatusRelated:
			[Utility showActivityIndicator];
			[[TSRestClient defaultClient] getRegistrationStatus:currentNetworkId checkRelated:YES];
			break;		
		case kCommandRemoveFromList:
			[Utility confirmTarget:self action:@selector(removeCurrentNetwork) message:@"Remove network '%@' from the list?", currentNetworkId];

		default:
			break;
	}
}

- (void) removeCurrentNetwork {
	[[NSNotificationCenter defaultCenter] postNotificationName:kBMNotificationRemoveNetwork object:currentNetworkId];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) phoneNumberEntryComplete:(TextEntryViewController*) textEntry {
	[self.navigationController popViewControllerAnimated:YES];
	[Utility showActivityIndicator];
	[[TSRestClient defaultClient] registerNetworkId:currentNetworkId phone:textEntry.textField.text];
}

- (void) restClient:(TSRestClient *)client didReceiveStatus:(TSStatus *)status forNetwork:(NSString *)networkId {
	[Utility hideActivityIndicator];
	[Utility alert:@"Status for network '%@' is %@", networkId, [status description]];
}

- (void) restClient:(TSRestClient *)client didRegisterNetworkId:(NSString *)networkId withStatus:(TSStatus *)status {
	[Utility hideActivityIndicator];
	[Utility alert:@"Registration of network '%@' completed with status %@", networkId, status];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	self.currentNetworkId = nil;
	self.cells = nil;
	
    [super dealloc];
}


@end

