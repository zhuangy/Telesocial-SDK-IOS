//
//  TextEntryViewController.m
//  TelesocialSDK
//
//  Created on 8/9/11.
//  Copyright 2011 Telesocial. All rights reserved.
//

#import "TextEntryViewController.h"


@implementation TextEntryViewController
@synthesize target;
@synthesize action;
@synthesize validationMessage;
@synthesize title;
@synthesize textField;
@synthesize cell;

- (id) init {
	self = [super initWithStyle:UITableViewStyleGrouped];
	
	self.textField = [[[UITextField alloc] initWithFrame:CGRectMake(20, 12, 285, 22)] autorelease];
	textField.autocorrectionType = UITextAutocorrectionTypeNo; 
	textField.returnKeyType = UIReturnKeyDone;
	textField.delegate = self;
	self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	
	self.cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""] autorelease];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	[cell addSubview:textField];
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonTap)] autorelease];
	
	return self;
}

+ (TextEntryViewController *) textEntryWithTitle:(NSString *)aTitle placeholderText:(NSString *)aPlaceholderText initialValue:(NSString *)anInitialValue validationMessage:(NSString *)aValidationMessage target:(id)aTarget action:(SEL)anAction {
	TextEntryViewController* te = [[[TextEntryViewController alloc] init] autorelease];
	[te view];
	te.title = aTitle;
	te.textField.placeholder = aPlaceholderText;
	te.textField.text = anInitialValue;
	te.validationMessage = aValidationMessage;
	te.action = anAction;
	te.target = aTarget;
	
	return te;
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:YES];
	
	[textField becomeFirstResponder];
}

- (void) notifyEntryComplete {
	
	if ([textField.text length] > 0) {
		[target performSelector:action withObject:self];
	} else {
		[Utility alert:validationMessage];
	}
}

- (void) doneButtonTap {
	[self notifyEntryComplete];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	[self notifyEntryComplete];
	return YES;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return title;
}

- (void) dealloc {
	self.target = nil;
	self.action = nil;
	self.validationMessage = nil;
	self.textField = nil;
	self.cell = nil;
	self.title = nil;
	
	[super dealloc];
}

@end
