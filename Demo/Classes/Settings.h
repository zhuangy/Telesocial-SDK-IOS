//
//  Settings.h
//  TelesocialSDK
//
//  Created on 8/9/11.
//  Copyright 2011 Telesocial. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBMServiceUrlKey		@"serviceUrl"
#define kBMApplicationKeyKey	@"applicationKey1"
#define kBMNetworkListKey		@"networks"
#define kBMMediaListKey			@"media"
#define kBMConferenceListKey	@"conferences1"

@interface Settings : NSObject {
}

@property (nonatomic, retain) NSString* serviceUrl;
@property (nonatomic, retain) NSString* applicationKey;

- (NSArray*) loadNetworkList;
- (void) saveNetworkList:(NSArray*) networkList;
- (NSArray*) loadMediaList;
- (void) saveMediaList:(NSArray*) mediaList;
- (NSArray*) loadConferenceList;
- (void) saveConferenceList:(NSArray*) conferenceList;

+ (Settings*) sharedSettings;


@end
