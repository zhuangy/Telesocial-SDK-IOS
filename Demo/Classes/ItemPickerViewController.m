//
//  ItemPickerViewController.m
//  TelesocialSDK
//
//  Created on 8/10/11.
//  Copyright 2011 Telesocial. All rights reserved.
//

#import "ItemPickerViewController.h"


@implementation ItemPickerViewController
@synthesize items;
@synthesize multipleSelect;
@synthesize selectedItems;
@synthesize selectedItem;
@synthesize target;
@synthesize action;
@synthesize subtitle;
@synthesize required;

- (id) initWithTitle:(NSString*) aTitle items:(NSArray*) anItems multipleSelect:(BOOL) aMultupleSelect
			  required:(BOOL) aRequired target:(id) aTarget action:(SEL) anAction {
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		self.items = anItems;
		self.selectedItems = [NSMutableArray array];
		self.selectedItem = nil;
		self.title = aTitle;
		self.target = aTarget;
		self.action = anAction;
		self.subtitle = aTitle;
		self.multipleSelect = aMultupleSelect;
		self.required = aRequired;
		self.title = @"Select";
		
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonTap)] autorelease];
	}
	
	return self;
}

- (void) dealloc {
	self.items = nil;
	self.selectedItems = nil;
	self.selectedItem = nil;
	self.subtitle = nil;
	
	[super dealloc];
}

- (void) doneButtonTap {
	if (required && [selectedItems count] == 0) {
		[Utility alert:@"Please select at least one item"];
		return;
	}

	
	if ([selectedItems count] > 0) {
		self.selectedItem = [selectedItems objectAtIndex:0];
	} else {
		self.selectedItem = nil;
	}
	
	[target performSelector:action withObject:self];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [items count];
}


- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return self.subtitle;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"pickerCell";
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [Utility cellWithTitle:@"" tag:0 action:NO reuseIdentifier:cellIdentifier];
	}
	id item = [items objectAtIndex:indexPath.row];
	cell.textLabel.text = [item description];
	cell.accessoryType = [selectedItems indexOfObject:item] == NSNotFound ? UITableViewCellAccessoryNone : 
																			UITableViewCellAccessoryCheckmark;

	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	id item = [items objectAtIndex:indexPath.row];
	UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];

							 
	if ([selectedItems indexOfObject:item] == NSNotFound) {
		if (!multipleSelect) {
			[selectedItems removeAllObjects];
			for (UITableViewCell* otherCell in [tableView visibleCells]) {
				otherCell.accessoryType = UITableViewCellAccessoryNone;
			}
		}
		[selectedItems addObject:item];
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	} else {
		[selectedItems removeObject:item];
		cell.accessoryType = UITableViewCellAccessoryNone;		
	}

}

@end
