//
//  Utility.m
//  TelesocialSDK
//
//  Created by Anton Minin on 8/9/11.
//  Copyright 2011 UMITI. All rights reserved.
//

#import "Utility.h"
#import "TelesocialSDKDemoAppDelegate.h"

@implementation Utility
@synthesize confirmTarget;
@synthesize confirmAction;

static Utility* sharedUtility;

+ (UITableViewCell*) cellWithTitle:(NSString*) title tag:(int) tag action:(BOOL)action reuseIdentifier:(NSString*) reuseIdentifier{

	UITableViewCell* cell = [[[UITableViewCell alloc] 
							  initWithStyle:action ? UITableViewCellStyleDefault : UITableViewCellStyleSubtitle 
							  reuseIdentifier:reuseIdentifier] autorelease];

	cell.textLabel.text = title;
	cell.tag = tag;

	if (action) {
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.accessoryType = UITableViewCellAccessoryNone;
	} else { 
		cell.textLabel.textAlignment = UITextAlignmentLeft;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	cell.textLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
	cell.detailTextLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
	
	
	return cell;
}

+ (Utility*) sharedUtility {
	if (sharedUtility == nil) {
		sharedUtility = [[Utility alloc] init];
	}
	
	return sharedUtility;
}

+ (void) alert:(NSString *)format, ... {
	va_list args;
    va_start (args, format);
    NSString *message = [[NSString alloc] initWithFormat:format  arguments:args];
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Telesocial SDK Demo" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	[alert release];
	[message release];
    va_end (args);
}


+ (void) confirmTarget:(id) target action:(SEL) action message:(NSString*) message, ... {
	va_list args;
    va_start (args, message);
    NSString *formattedMessage = [[NSString alloc] initWithFormat:message  arguments:args];
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Please Confirm" message:formattedMessage delegate:[Utility sharedUtility] cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
	[Utility sharedUtility].confirmAction = action;
	[Utility sharedUtility].confirmTarget = target;
	alert.tag = kConfirmationTag;
	[alert show];
	[alert release];
	[formattedMessage release];
    va_end (args);	
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (alertView.cancelButtonIndex != buttonIndex) {
		[confirmTarget performSelector:confirmAction];
	}
}

+ (void) showActivityIndicator {
	UIView* background = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)] autorelease];
	background.backgroundColor = [UIColor clearColor];
	
	UIView* rect = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)] autorelease];
	rect.layer.cornerRadius = 9;
	rect.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
	rect.center = background.center;
	[background addSubview:rect];
	
	UIActivityIndicatorView* activityIndicator = [[[UIActivityIndicatorView alloc] 
												   initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
	activityIndicator.center = background.center;
	[background addSubview:activityIndicator];
	[activityIndicator startAnimating];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	background.tag = kActivityIndicatorTag;
	
	[((TelesocialSDKDemoAppDelegate*)[UIApplication sharedApplication].delegate).window addSubview:background];
}

+ (void) hideActivityIndicator {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[[((TelesocialSDKDemoAppDelegate*)[UIApplication sharedApplication].delegate).window viewWithTag:kActivityIndicatorTag] removeFromSuperview];
}

@end
