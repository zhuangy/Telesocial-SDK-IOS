//
//  Utility.h
//  TelesocialSDK
//
//  Created on 8/9/11.
//  Copyright 2011 Telesocial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#define kActivityIndicatorTag		1112
#define kConfirmationTag			1113

@interface Utility : NSObject<UIAlertViewDelegate> {

}

@property (nonatomic, assign) SEL confirmAction;
@property (nonatomic, assign) id confirmTarget;
		   

+ (UITableViewCell*) cellWithTitle:(NSString*) title tag:(int) tag action:(BOOL)action reuseIdentifier:(NSString*) reuseIdentifier;
+ (void) alert:(NSString*) format, ...;
+ (void) confirmTarget:(id) target action:(SEL) action message:(NSString*) message, ...;
+ (void) showActivityIndicator;
+ (void) hideActivityIndicator;
+ (Utility*) sharedUtility;

@end
