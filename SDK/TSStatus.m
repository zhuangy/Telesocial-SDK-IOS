//
//  BMStatus.m
//  BitmouthSDK
//
//  Created by Anton Minin on 8/2/11.
//  Copyright 2011 UMITI. All rights reserved.
//

#import "TSStatus.h"


@implementation TSStatus

@synthesize code;
@synthesize message;

- (id) initWithCode:(int)aCode message:(NSString *)aMessage {

	self = [super init];
	if (self) {
		self.code = aCode;
		self.message = aMessage;
	}
	
	return self;
}

- (void) dealloc {
	self.message = nil;
	[super dealloc];
}

- (BOOL) isOk {
	return (self.code >= 200) && (self.code < 300);
}

+ (TSStatus *) statusWithCode:(int)aCode message:(NSString *)aMessage {
	return [[[TSStatus alloc] initWithCode:aCode message:aMessage] autorelease];
}
			
+ (TSStatus *) ok {
	return [TSStatus statusWithCode:kBMStatusOk message:@""];
}

+ (TSStatus *) statusWithResponseDictionary:(NSDictionary *)dictionary {

	
	NSArray* keys = [dictionary allKeys];
	if ([keys count] < 1)
	{
		return [TSStatus statusWithCode:kBMStatusInvalidResponse message:@"Response top level object is empty"];
	}
	
	NSDictionary* responseObject = [dictionary objectForKey:[keys objectAtIndex:0]];
	
	TSStatus* result = nil;
	
	NSNumber* aCode = [responseObject objectForKey:@"status"];
	NSString* aMessage = [responseObject objectForKey:@"message"];
	
	if (aCode == nil) {
		result = [TSStatus statusWithCode:kBMStatusInvalidResponse message:@"Could not parse response to get operation status"];
	} else {
		result = [TSStatus statusWithCode:[aCode intValue] message:aMessage];
	}
	
	return result;
}

- (NSString*) description {
	if ((message == nil) || [message isEqualToString:@""]) {
		return [NSString stringWithFormat:@"%d", code];
	} else {
		return [NSString stringWithFormat:@"%d: %@", code, message];
	}
}

@end
