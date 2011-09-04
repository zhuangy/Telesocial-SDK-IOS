//
//  TextEntryViewController.h
//  TelesocialSDK
//
//  Created on 8/9/11.
//  Copyright 2011 Telesocial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utility.h"


@interface TextEntryViewController : UITableViewController <UITextFieldDelegate>{
	
}

@property (nonatomic, retain) UITextField* textField;
@property (nonatomic, retain) UITableViewCell* cell;

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, retain) NSString* validationMessage;
@property (nonatomic, retain) NSString* title;

+ (TextEntryViewController*) textEntryWithTitle:(NSString*) aTitle
								placeholderText:(NSString*) aPlaceholderText
								   initialValue:(NSString*) anInitialValue
							  validationMessage:(NSString*) aValidationMessage
										 target:(id) aTarget
										 action:(SEL) anAction;


@end
