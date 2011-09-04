//
//  ItemPickerViewController.h
//  TelesocialSDK
//
//  Created on 8/10/11.
//  Copyright 2011 Telesocial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utility.h"

@interface ItemPickerViewController : UITableViewController {

}

@property (nonatomic, retain) NSArray* items;
@property (nonatomic, assign) BOOL multipleSelect;
@property (nonatomic, assign) BOOL required;
@property (nonatomic, retain) NSMutableArray* selectedItems;
@property (nonatomic, retain) id selectedItem;
@property (nonatomic, retain) NSString* subtitle;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

- (id) initWithTitle:(NSString*) aTitle items:(NSArray*) anItems multipleSelect:(BOOL) aMultupleSelect
			required:(BOOL) aRequired
			  target:(id) aTarget action:(SEL) anAction;

@end
