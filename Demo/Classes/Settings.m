//
//  Settings.m
//  TelesocialSDK
//
//  Created on 8/9/11.
//  Copyright 2011 Telesocial. All rights reserved.
//

#import "Settings.h"


static Settings* sharedSettings;

@implementation Settings

- (id) valueForKey:(NSString*) key defaultValue:(id) defaultValue {
	NSString* value = [[NSUserDefaults standardUserDefaults] valueForKey:key];
	if (value != nil) {
		return value;
	} else {
		return defaultValue;
	}
}

/**
 Save a value in the NSUserDefaults and synchronize
 */
- (void) saveValue:(id) value forKey:(NSString*) key {
	NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
	
	[ud setValue:value forKey:key];
	[ud synchronize];
}

+ (Settings*) sharedSettings {
	if (sharedSettings == nil) {
		sharedSettings = [[Settings alloc] init];
	}
	
	return sharedSettings;
}

- (NSString *) serviceUrl {
	return [self valueForKey:kBMServiceUrlKey defaultValue:@"https://api.telesocial.com"];
}

- (void) setServiceUrl:(NSString *) value{
	[self saveValue:value forKey:kBMServiceUrlKey];
}

- (NSString *) applicationKey {
	return [self valueForKey:kBMApplicationKeyKey defaultValue:@"af2416f5-736b-4d78-b495-13b05b090de1"];
}

- (void) setApplicationKey:(NSString *) value {
	[self saveValue:value forKey:kBMApplicationKeyKey];
}

- (NSArray *) loadNetworkList {
	return [self valueForKey:kBMNetworkListKey defaultValue:[NSArray array]];
}

- (void) saveNetworkList:(NSArray *)networkList {
	[self saveValue:networkList forKey:kBMNetworkListKey];
}

- (NSArray*) loadMediaList {
	return [self valueForKey:kBMMediaListKey defaultValue:[NSArray array]];
}

- (void) saveMediaList:(NSArray *)mediaList {
	[self saveValue:mediaList forKey:kBMMediaListKey];
}

- (NSArray *) loadConferenceList {
	return [self valueForKey:kBMConferenceListKey defaultValue:[NSArray array]];	
}

- (void) saveConferenceList:(NSArray *)conferenceList {
	[self saveValue:conferenceList forKey:kBMConferenceListKey];
}

@end
