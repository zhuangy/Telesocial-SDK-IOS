//
//  TelesocialSDKDemoViewController.m
//  TelesocialSDKDemo
//
//  Created on 8/5/11.
//  Copyright 2011 Telesocial. All rights reserved.
//

#import "TelesocialSDKDemoViewController.h"

@implementation TelesocialSDKDemoViewController
@synthesize sections;


- (void)viewDidLoad {
    [super viewDidLoad];

	// Create table cells for the main menu
	self.sections = [NSArray arrayWithObjects:
					 [NSArray arrayWithObjects:
					  [Utility cellWithTitle:@"Registration" tag:kBMCommandNetworks action:NO reuseIdentifier:@""],
					  [Utility cellWithTitle:@"Media Management" tag:kBMCommandMedia action:NO reuseIdentifier:@""],
					  [Utility cellWithTitle:@"Conference Calling" tag:kBMCommandConferences action:NO reuseIdentifier:@""],
					  nil],
					 [NSArray arrayWithObjects: 
					  [Utility cellWithTitle:@"API Version" tag:kBMCommandApiVersion action:YES reuseIdentifier:@""],
					  nil],
					 [NSArray arrayWithObjects:
					  serviceUrlCell = [Utility cellWithTitle:@"Service URL" tag:kBMCommandSetServiceUrl action:NO reuseIdentifier:@""],
					  applicationKeyCell = [Utility cellWithTitle:@"Application Key" tag:kBMCommandSetAppKey action:NO reuseIdentifier:@""],
					  nil],
					 nil];
	
	
	self.title = @"Telesocial";
	
	[self refreshValues];
	[TSRestClient defaultClient].delegate = self;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return [sections count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[sections objectAtIndex:section] count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [[sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	// make sure the delegate property of the default service is not set to another object
	[TSRestClient defaultClient].delegate = self;

	UITableViewCell* cell = [[sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	switch (cell.tag) {
		case kBMCommandNetworks:
			[self.navigationController pushViewController:[[[NetworkListViewController alloc] init] autorelease] animated:YES];
			break;
		case kBMCommandMedia:
			[self.navigationController pushViewController:[[[MediaListViewController alloc] init] autorelease] animated:YES];
			break;
		case kBMCommandConferences:
			[self.navigationController pushViewController:[[[ConferenceListViewController alloc] init] autorelease] animated:YES];
			break;

		case kBMCommandApiVersion:
			// Show standard activity indicator to let the user know that a call to the network service is in progress
			[Utility showActivityIndicator];
			
			// Initiate getAPIVersion call to the rest service. The defaultClient object will 
			// send restClient:didReceiveApiVersion:status message to this object when the call is complete
			[[TSRestClient defaultClient] getAPIVersion];
			break;
		case kBMCommandSetServiceUrl:
			// Present text input controller which will send "serviceUrlEntryComplete:" message when input is complete.
			[self.navigationController pushViewController:
			 [TextEntryViewController textEntryWithTitle:@"Telesocial API Service URL" 
										 placeholderText:@"" 
											initialValue:[Settings sharedSettings].serviceUrl 
									   validationMessage:@"Service URL is required and can not be empty."
												  target:self
												  action:@selector(serviceUrlEntryComplete:)]
												 animated:YES];
			break;
			
		case kBMCommandSetAppKey:
			// Present standard text input controller which will send "applicationKeyEntryComplete:" message when input is complete.
			[self.navigationController pushViewController:
			 [TextEntryViewController textEntryWithTitle:@"Application Key" 
										 placeholderText:@"" 
											initialValue:[Settings sharedSettings].applicationKey
									   validationMessage:@"Application key is required and can not be empty."
												  target:self
												  action:@selector(applicationKeyEntryComplete:)]
												 animated:YES];
			break;
			
		default:
			break;
	}

}

- (void) refreshValues {
	// refresh serfice url and application key labels in the table view
	serviceUrlCell.detailTextLabel.text = [Settings sharedSettings].serviceUrl;
	applicationKeyCell.detailTextLabel.text = [Settings sharedSettings].applicationKey;
	
	// update servuce url and application key in the default REST client
	[TSRestClient defaultClient].serviceUrl = [Settings sharedSettings].serviceUrl;
	[TSRestClient defaultClient].applicationKey = [Settings sharedSettings].applicationKey;
}

- (void) serviceUrlEntryComplete:(TextEntryViewController*) textEntry {
	[self.navigationController popViewControllerAnimated:YES];
	[Settings sharedSettings].serviceUrl = textEntry.textField.text;
	[self refreshValues];
}

- (void) applicationKeyEntryComplete:(TextEntryViewController*) textEntry {
	[self.navigationController popViewControllerAnimated:YES];
	[Settings sharedSettings].applicationKey = textEntry.textField.text;
	[self refreshValues];
}

	 
- (void) restClient:(TSRestClient *)client didReceiveApiVersion:(NSString *)versionString status:(TSStatus *)status {
	// getAPIVersion call completed, now must hide activity indicator
	
	[Utility hideActivityIndicator];
	
	if ([status isOk]) {
		// display API version string if status is 2xx
		[Utility alert:@"API version: %@", versionString];
	} else {
		// display error message in other case
		[Utility alert:@"Failed to get API version. Status: %@", [status description]];
	}
}

- (void)dealloc {
	self.sections = nil;
	
    [super dealloc];
}

@end
