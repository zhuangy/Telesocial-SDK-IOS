//
//  BMMediaInfo.m
//  BitmouthSDK
//
//  Created on 8/2/11.
//  Copyright 2011 Telesocial. All rights reserved.
//

#import "TSMediaInfo.h"


@implementation TSMediaInfo

@synthesize id;
@synthesize downloadUrl;
@synthesize fileSize;

- (id) initWithId:(NSString *)anId downloadUrl:(NSString *)aDownloadUrl fileSize:(long long)aFileSize {

	self = [super init];
	if (self) {
		self.id = anId;
		self.downloadUrl = aDownloadUrl;
		self.fileSize = aFileSize;
	}
	
	return self;
}

+ (TSMediaInfo *) mediaInfoWithId:(NSString *)anId downloadUrl:(NSString *)aDownloadUrl fileSize:(long long)aFileSize {

	return [[[TSMediaInfo alloc] initWithId:anId downloadUrl:aDownloadUrl fileSize:aFileSize] autorelease];
}

+ (TSMediaInfo *) mediaInfoWithResponseObject:(NSDictionary *)responseObject {
	return [TSMediaInfo mediaInfoWithId:[responseObject objectForKey:@"mediaId"] 
							downloadUrl:[responseObject objectForKey:@"downloadUrl"]
							   fileSize:[((NSNumber*)[responseObject objectForKey:@"fileSize"]) longLongValue]];
}

- (void) dealloc {
	self.id = nil;
	self.downloadUrl = nil;
	
	[super dealloc];
}


@end
