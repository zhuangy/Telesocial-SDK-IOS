//
//  BMRestClient.m
//  BitmouthSDK
//
//  Created by Anton Minin on 8/2/11.
//  Copyright 2011 UMITI. All rights reserved.
//

#import "TSRestClient.h"
#import "TSRestOperation.h"

static TSRestClient* defaultClient;

@interface TSRestClient ()
@property (nonatomic, retain) NSOperationQueue* operationQueue;
@end

@implementation TSRestClient

@synthesize applicationKey;
@synthesize serviceUrl;
@synthesize operationQueue;
@synthesize delegate;



- (id) init {
	self = [super init];
	if (self) {
		self.applicationKey = nil;
		self.serviceUrl = nil;
		self.operationQueue = [[[NSOperationQueue alloc] init] autorelease];
		[operationQueue setMaxConcurrentOperationCount:kBMMaxConcurentCalls];
	}
	return self;
}

+ (TSRestClient*) defaultClient {

	if (defaultClient == nil) {
		defaultClient = [[TSRestClient alloc] init];
	}
	
	return defaultClient;
}

- (void) dealloc {
	self.applicationKey = nil;
	self.serviceUrl = nil;
	self.operationQueue = nil;
	
	[super dealloc];
}

- (NSString*) encodedParamsFromDictionary:(NSDictionary*) params {
	if (params == nil) {
		return nil;
	}

	BOOL needDelimiter = NO;
	NSMutableString* queryString = [NSMutableString string];
	for (NSString* key in params) {
		NSObject* value = [params valueForKey:key];

		if (needDelimiter) {
			[queryString appendString:@"&"];
		}
		

		if ([value isKindOfClass:[NSString class]]) {
			[queryString appendString:[key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
			[queryString appendString:@"="];
			[queryString appendString:[(NSString*)value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		};
		
		NSMutableArray* array = [NSMutableArray array];
		if ([value isKindOfClass:[NSArray class]]) {
			for (NSString* item in (NSArray*)value) {
				[array addObject:[NSString stringWithFormat:@"%@=%@", [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
								  [item stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
			}
			[queryString appendString:[array componentsJoinedByString:@"&"]];
		}
		
		needDelimiter = YES;
	}
	
	if ([queryString length] > 0) {
		return queryString;
	} else {
		return nil;
	}
}

- (void) invokeUri:(NSString *)uri method:(NSString*) method queryParams:(NSDictionary *)queryParams postParams:(NSDictionary *)postParams target:(id)target action:(SEL)action object:(id)object{
	// make sure service URL and application key are set
	if (self.serviceUrl == nil) {
		[target performSelector:action withObject:[TSRestOperation operationWithStatus:
												   [TSStatus statusWithCode:kBMStatusServiceUrlMissing message:@"Bitmouth service URL not set"]]];
	}
	
	if (self.applicationKey == nil) {
		[target performSelector:action withObject:[TSRestOperation operationWithStatus:
												   [TSStatus statusWithCode:kBMStatusAppKeyMissing message:@"Bitmouth application key not set"]]];
	}
	
	// urlencode any GET parameters
	NSString* queryParamsString = [self encodedParamsFromDictionary:queryParams];
	
	NSString* urlString = [serviceUrl stringByAppendingPathComponent:uri];

	// Need this to fix "//" -> "/" replacement that NSString::stringByAppendingPathComponent performs
	urlString = [urlString stringByReplacingOccurrencesOfString:@"http:/" withString:@"http://"];
	
	if (queryParams != nil) {
		urlString = [urlString stringByAppendingFormat:@"?%@", queryParamsString];
	}
	

	// urlencode POST parameters
	NSString* postParamsString = [self encodedParamsFromDictionary:postParams];
	
	if (postParamsString != nil) {
		NSLog(@"curl -d \"%@\" %@\n", postParamsString, urlString);
	} else {
		NSLog(@"curl %@\n", urlString);		
	}

	uint postDataLength = 0;
	NSData* postData = nil;
	
	if (postParamsString != nil) {
		postData = [postParamsString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
		postDataLength = [postData length];
	}
	
	NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]] autorelease];

	[request setValue:[NSString stringWithFormat:@"%d", postDataLength] forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];

	[request setHTTPMethod:method];
	
	// prepare operation to run in the background
	TSRestOperation* operation = [TSRestOperation operationWithRequest:request target:target action:action];
	operation.object = object;

	// add it to the operation que
	[operationQueue addOperation:operation];
}

- (void) getRegistrationStatus:(NSString *)networkId checkRelated:(BOOL)checkRelated {
	NSString* uri = [NSString stringWithFormat:@"/api/rest/registrant/%@", [networkId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

	[self invokeUri:uri 
			 method:kBMMethodPOST 
		queryParams:nil
		 postParams:[NSDictionary dictionaryWithObjectsAndKeys:
					 self.applicationKey, @"appkey",
					 checkRelated ? @"related" : @"exists", @"query", nil] 
			 target:self 
			 action:@selector(getRegistrationStatusComplete:) 
			 object:networkId];
}

- (void) getRegistrationStatusComplete:(TSRestOperation*) operation {
	TSStatus* status = [TSStatus statusWithResponseDictionary:operation.parsedResponse];
	
	if ([(id) delegate respondsToSelector:@selector(restClient:didReceiveStatus:forNetwork:)]) {
		[delegate restClient:self didReceiveStatus:status forNetwork:operation.object];
	}
}



- (void) registerNetworkId:(NSString *)networkId phone:(NSString *)phone {
	[self invokeUri:@"/api/rest/registrant"
			 method:kBMMethodPOST
		queryParams:nil
		 postParams:[NSDictionary dictionaryWithObjectsAndKeys:
														self.applicationKey, @"appkey",
														networkId, @"networkid",
														phone, @"phone", nil] 
			 target:self 
			 action:@selector(registerNetworkIdComplete:)
			 object:networkId];
}

- (void) registerNetworkIdComplete:(TSRestOperation*) operation {
	TSStatus* status = [TSStatus statusWithResponseDictionary:operation.parsedResponse];
	
	if ([(id)delegate respondsToSelector:@selector(restClient:didRegisterNetworkId:withStatus:)]) {
		[delegate restClient:self didRegisterNetworkId:operation.object withStatus:status];
	}
}



- (void) createConferenceWithNetwork:(NSString*) networkId greetingId:(NSString *)greetingId recordingId:(NSString *)recordingId {

	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   self.applicationKey, @"appkey",
								   networkId, @"networkid", nil];

	// only pass recording parameter if it is not nill
	if (recordingId != nil) {
		[params setObject:[recordingId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"recordingid"];
	}
	
	// only pass greetingid parameter if it is not nill
	if (greetingId != nil) {
		[params setObject:[greetingId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"greetingid"];
	}
	
	[self invokeUri:@"api/rest/conference" 
			 method:kBMMethodPOST
		queryParams:nil
		 postParams:params
			 target:self
			 action:@selector(createConferenceComplete:)
			 object:nil];
}

- (void) createConferenceComplete:(TSRestOperation*) operation {

	NSDictionary* tlo = [operation.parsedResponse objectForKey:@"ConferenceResponse"];
	TSStatus* status = [TSStatus statusWithResponseDictionary:operation.parsedResponse];

	NSString* conferenceId = nil;
	if ([status isOk]) {
		// get ID of the newly created conference from the top level object
		conferenceId = [tlo objectForKey:@"conferenceId"];
		
	
		if (conferenceId == nil) {
			status = [TSStatus statusWithCode:kBMStatusInvalidResponse message:@"Could not get conferenceId from server response"];
		}
	}

	if ([(id) delegate respondsToSelector:@selector(restClient:didCreateConferenceId:withStatus:)]) {
		[delegate restClient:self didCreateConferenceId:conferenceId withStatus:operation.status];
	}
}



- (void) createMedia {
	[self invokeUri:@"api/rest/media"
			 method:kBMMethodPOST
		queryParams:nil
		 postParams:[NSDictionary dictionaryWithObjectsAndKeys:
					 self.applicationKey, @"appkey",
					 nil] 
			 target:self
			 action:@selector(createMediaForNetworkComplete:)
			 object:nil];
}

- (void) createMediaForNetworkComplete:(TSRestOperation*) operation {
	NSDictionary* tlo = [operation.parsedResponse objectForKey:@"MediaResponse"];
	TSStatus* status = [TSStatus statusWithResponseDictionary:operation.parsedResponse];
	
	TSMediaInfo* mediaInfo = nil;
	
	if ([status isOk]) {
		// get media info fields like file size, download URL and media ID from response object
		mediaInfo = [TSMediaInfo mediaInfoWithResponseObject:tlo];
	}
	
	if ([(id)delegate respondsToSelector:@selector(restClient:didCreateMedia:withStatus:)]) {
		[delegate restClient:self didCreateMedia:mediaInfo withStatus:status];
	}
		
}

- (void) recordMedia:(NSString *)mediaId network:(NSString *)networkId {
	[self invokeUri:[NSString stringWithFormat:@"api/rest/media/%@", [mediaId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
			 method:kBMMethodPOST
		queryParams:nil
		 postParams:[NSDictionary dictionaryWithObjectsAndKeys:
					 self.applicationKey, @"appkey",
					 networkId, @"networkid",
					 @"record", @"action", nil] 
			 target:self
			 action:@selector(recordMediaComplete:)
			 object:networkId];
}

- (void) recordMediaComplete:(TSRestOperation*) operation {
	NSDictionary* tlo = [operation.parsedResponse objectForKey:@"MediaResponse"];
	TSStatus* status = [TSStatus statusWithResponseDictionary:operation.parsedResponse];
	
	TSMediaInfo* mediaInfo = nil;
	
	if ([status isOk]) {
		mediaInfo = [TSMediaInfo mediaInfoWithResponseObject:tlo];
	}
	
	if ([(id)delegate respondsToSelector:@selector(restClient:didRecordMedia:withStatus:)]) {
		[delegate restClient:self didRecordMedia:mediaInfo withStatus:status];
	}
}


- (void) blastMedia:(NSString *)mediaId network:(NSString *)networkId {
	[self invokeUri:[NSString stringWithFormat:@"api/rest/media/%@", [mediaId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
			 method:kBMMethodPOST
		queryParams:nil
		 postParams:[NSDictionary dictionaryWithObjectsAndKeys:
					 self.applicationKey, @"appkey",
					 networkId, @"networkid",
					 @"blast", @"action", nil] 
			 target:self
			 action:@selector(blastMediaComplete:)
			 object:networkId];
}



- (void) blastMediaComplete:(TSRestOperation*) operation {
	NSDictionary* tlo = [operation.parsedResponse objectForKey:@"MediaResponse"];
	TSStatus* status = [TSStatus statusWithResponseDictionary:operation.parsedResponse];
	
	TSMediaInfo* mediaInfo = nil;
	
	if ([status isOk]) {
		mediaInfo = [TSMediaInfo mediaInfoWithResponseObject:tlo];
	}
	
	if ([(id)delegate respondsToSelector:@selector(restClient:didBlastMedia:withStatus:)]) {
		[delegate restClient:self didBlastMedia:mediaInfo withStatus:status];
	}
}

- (void) getMediaStatus:(NSString *)mediaId {
	[self invokeUri:[NSString stringWithFormat:@"api/rest/media/status/%@", [mediaId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
			 method:kBMMethodPOST
		queryParams:nil
		 postParams:[NSDictionary dictionaryWithObjectsAndKeys:self.applicationKey, @"appkey", 
					 nil]
			 target:self
			 action:@selector(getMediaStatusComplete:)
			 object:nil];
}	

- (void) getMediaStatusComplete:(TSRestOperation*) operation {
	NSDictionary* tlo = [operation.parsedResponse objectForKey:@"MediaResponse"];
	TSStatus* status = [TSStatus statusWithResponseDictionary:operation.parsedResponse];
	
	TSMediaInfo* mediaInfo = nil;
	
	if (status.code == kBMStatusOk) {
		mediaInfo = [TSMediaInfo mediaInfoWithResponseObject:tlo];
	}
	
	if ([(id)delegate respondsToSelector:@selector(restClient:didReceiveStatus:forMedia:)]) {
		[delegate restClient:self didReceiveStatus:status forMedia:mediaInfo];
	}
	
}

- (void) addNetworks:(NSArray*) networks toConference:(NSString*) conferenceId greetingId:(NSString*) greetingId{
	
	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   self.applicationKey, @"appkey",
								   @"add", @"action",
								   networks, @"networkid", nil];
	if (greetingId != nil) {
		[params setObject:greetingId forKey:@"greetingid"];
	}
	[self invokeUri:[NSString stringWithFormat:@"api/rest/conference/%@", [conferenceId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
			 method:kBMMethodPOST
		queryParams:nil
		 postParams:params
			 target:self
			 action:@selector(addNetworksToConferenceComplete:)
			 object:conferenceId];
}

- (void) addNetworksToConferenceComplete:(TSRestOperation*) operation {
	TSStatus* status = [TSStatus statusWithResponseDictionary:operation.parsedResponse];
	
	if ([(id) delegate respondsToSelector:@selector(restClient:didAddNetworksToConference:withStatus:)]) {
		[delegate restClient:self didAddNetworksToConference:operation.object withStatus:status];
	}
}


- (void) requestUploadGrantForMedia:(NSString *)mediaId {
	[self invokeUri:[NSString stringWithFormat:@"api/rest/media/%@", [mediaId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
			 method:kBMMethodPOST
		queryParams:nil
		 postParams:[NSDictionary dictionaryWithObjectsAndKeys:
					 self.applicationKey, @"appkey",
					 @"upload_grant", @"action", nil]
			 target:self
			 action:@selector(requestUploadGrantForMediaComplete:)
			 object:nil];
}

- (void) requestUploadGrantForMediaComplete:(TSRestOperation*) operation {
	NSDictionary* tlo = [operation.parsedResponse objectForKey:@"UploadResponse"];
	TSStatus* status = [TSStatus statusWithResponseDictionary:operation.parsedResponse];

	NSString* grantId = nil;
	if (status.code == kBMStatusCreated) {
		grantId = [tlo objectForKey:@"grantId"];
	}
	
	if ([(id) delegate respondsToSelector:@selector(restClient:didReceiveUploadGrant:withStatus:)]) {
		[delegate restClient:self didReceiveUploadGrant:grantId withStatus:status];
	}
}
		 
- (void) removeMedia:(NSString *)mediaId {
	[self invokeUri:[NSString stringWithFormat:@"api/rest/media/%@", [mediaId  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
			 method:kBMMethodPOST
		queryParams:nil
		 postParams:[NSDictionary dictionaryWithObjectsAndKeys:
					 self.applicationKey, @"appkey", 
					 @"remove", @"action",
					 nil]
			 target:self
			 action:@selector(removeMediaComplete:)
			 object:mediaId];
}

- (void) removeMediaComplete:(TSRestOperation*) operation {
	TSStatus* status = [TSStatus statusWithResponseDictionary:operation.parsedResponse];
	
	if ([(id)delegate respondsToSelector:@selector(restClient:didRemoveMediaId:withStatus:)]) {
		[delegate restClient:self didRemoveMediaId:operation.object withStatus:status];
	}
	
}

- (void) closeConference:(NSString *)conferenceId {
	[self invokeUri:[NSString stringWithFormat:@"api/rest/conference/%@", [conferenceId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
			 method:kBMMethodPOST
		queryParams:nil
		 postParams:[NSDictionary dictionaryWithObjectsAndKeys:
					 self.applicationKey, @"appkey", 
					 @"close", @"action",
					 nil]
			 target:self
			 action:@selector(closeConferenceComplete:)
			 object:conferenceId];
	
}

- (void) closeConferenceComplete:(TSRestOperation*) operation {
	TSStatus* status = [TSStatus statusWithResponseDictionary:operation.parsedResponse];
	
	if ([(id)delegate respondsToSelector:@selector(restClient:didCloseConferenceId:withStatus:)]) {
		[delegate restClient:self didCloseConferenceId:operation.object withStatus:status];
	}
}

- (void) hangupNetwork:(NSString *)networkId inConference:(NSString *)conferenceId {
	[self invokeUri:[NSString stringWithFormat:@"api/rest/conference/%@/%@", [conferenceId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], 
					 [networkId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
			 method:kBMMethodPOST
		queryParams:nil
		 postParams:[NSDictionary dictionaryWithObjectsAndKeys:
					 self.applicationKey, @"appkey", 
					 @"hangul", @"action",					 
					 nil]
			 target:self
			 action:@selector(hangupNetworkInConferenceComplete:)
			 object:[NSArray arrayWithObjects: networkId, conferenceId, nil]];
}

- (void) hangupNetworkInConferenceComplete:(TSRestOperation*) operation {
	TSStatus* status = [TSStatus statusWithResponseDictionary:operation.parsedResponse];
	
	if ([(id) delegate respondsToSelector:@selector(restClient:didHangupNetworkId:inConferenceId:withStatus:)]) {
		[delegate restClient:self 
		  didHangupNetworkId:[operation.object objectAtIndex:0] 
			  inConferenceId:[operation.object objectAtIndex:1]
				  withStatus:status];
	}
}

- (void) moveNetwork:(NSString *)networkId fromConference:(NSString *)fromConferenceId toConference:(NSString *)toConferenceId {
	[self invokeUri:[NSString stringWithFormat:@"api/rest/conference/%@/%@", 
					 [fromConferenceId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], 
					 [networkId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
			 method:kBMMethodPOST
		queryParams:nil
		 postParams:[NSDictionary dictionaryWithObjectsAndKeys:
					 self.applicationKey, @"appkey", 
					 toConferenceId, @"toconferenceid",
					 @"move", @"action",
					 nil]
			 target:self
			 action:@selector(moveNetworkComplete:)
			 object:nil];
}	

- (void) moveNetworkComplete:(TSRestOperation*) operation {
	TSStatus* status = [TSStatus statusWithResponseDictionary:operation.parsedResponse];
	
	if ([(id) delegate respondsToSelector:@selector(restClient:didMoveWithStatus:)]) {
		[delegate restClient:self didMoveWithStatus:status];
	}
}

- (void) setMute:(BOOL)mute forNetwork:(NSString *) networkId inConference :(NSString *)conferenceId {
	

	[self invokeUri:[NSString stringWithFormat:@"api/rest/conference/%@/%@", 
					 [conferenceId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
					 [networkId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
			 method:kBMMethodPOST
		queryParams:nil
		 postParams:[NSDictionary dictionaryWithObjectsAndKeys:
					 self.applicationKey, @"appkey",
					 mute ? @"mute" : @"unmute", @"action", nil]
			 target:self
			 action:@selector(muteComplete:)
			 object:nil];
}

- (void) muteComplete:(TSRestOperation*) operation {
	TSStatus* status = [TSStatus statusWithResponseDictionary:operation.parsedResponse];
	
	if ([(id) delegate respondsToSelector:@selector(restClient:didMuteWithStatus:)]) {
		[delegate restClient:self didMuteWithStatus:status];
	}
	
}

- (void) getAPIVersion {
	[self invokeUri:@"/api/rest/version" method:kBMMethodGET queryParams:nil postParams:nil target:self action:@selector(getAPIVersionComplete:) object:nil];
}

- (void) getAPIVersionComplete:(TSRestOperation*) operation {

	if ([(id)delegate respondsToSelector:@selector(restClient:didReceiveApiVersion:status:)]) {
		[delegate restClient:self didReceiveApiVersion:operation.dataString status:operation.status];
	}
}

@end
