//
//  TSRestOperation.m
//  BitmouthSDK
//
//  Created on 8/4/11.
//  Copyright 2011 Telesocial. All rights reserved.
//

#import "TSRestOperation.h"
#import "JSONKit.h"

@implementation TSRestOperation
@synthesize request;
@synthesize response;
@synthesize target;
@synthesize action;
@synthesize error;
@synthesize data;
@synthesize dataString;
@synthesize status;
@synthesize object;
@synthesize parsedResponse;

- (id) initWithRequest:(NSURLRequest *)aRequest target:(id)aTarget action:(SEL)anAction {

	self = [super init];
	if (self) {
		self.request = aRequest;
		self.response = nil;
		self.target = aTarget;
		self.action = anAction;
	}
	
	return self;
}

+ (TSRestOperation *) operationWithRequest:(NSURLRequest *)aRequest target:(id)aTarget action:(SEL)anAction {
	return [[[TSRestOperation alloc] initWithRequest:aRequest target:aTarget action:anAction] autorelease];
}

- (void) dealloc {
	self.request = nil;
	self.response = nil;
	self.target = nil;
	self.action = nil;
	self.error = nil;
	self.data = nil;
	self.dataString = nil;
	self.status = nil;
	self.object = nil;
	self.parsedResponse = nil;
	
	[super dealloc];
}

- (void) main {
	NSHTTPURLResponse* aResponse = nil;
	NSError* anError = nil;
	self.data = [NSURLConnection sendSynchronousRequest:request returningResponse:&aResponse error:&anError];
	if (data) {
		self.dataString = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
		self.parsedResponse = [[JSONDecoder decoder] parseJSONData:data];
	}
	
	self.response = aResponse;
	self.error = anError;

//	NSLog(@"response error:%@, status code: %d, body: %@", [error description], [response statusCode], dataString);
	
	if (error) {
		self.status = [TSStatus statusWithCode:kBMStatusServiceUnavaialble message:[error localizedDescription]];
	} else {
		if (response) {
			self.status = [TSStatus statusWithCode:[response statusCode] message:@""];
		} else {
			self.status = [TSStatus statusWithCode:kBMStatusInvalidResponse message:@"Server returned invalid response"];
		}
	}
	
	[target performSelectorOnMainThread:action withObject:self waitUntilDone:YES];
}

+ (TSRestOperation *) operationWithStatus:(TSStatus *)aStatus {
	TSRestOperation* operation = [TSRestOperation operationWithRequest:nil target:nil action:nil];
	operation.status = aStatus;
	return operation;
}

@end
