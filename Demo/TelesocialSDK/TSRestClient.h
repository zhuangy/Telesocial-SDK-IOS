//
//  TSRestClient.h
//  BitmouthSDK
//
//  Created on 8/2/11.
//  Copyright 2011 Telesocial. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSRestClientDelegate.h"


#define kBMMaxConcurentCalls	4
#define kBMMethodPOST			@"POST"
#define kBMMethodGET			@"GET"
#define kBMMethodDELETE			@"DELETE"

@interface TSRestClient : NSObject {
    
}

/**
 Get network registration status.  This method can be called to determine
 - if a network ID has been registered with the Bitmouth system
 - if a network ID has been registered and is associated with a particular application in the Bitmouth system.
 
 
 
 @param networkId		The ID of the network to check
 @param checkRelated	If YES, then check whether the supplied network ID is associated with a particular application.
 If NO, only checks if the network ID is registered with the Bitmouth system.
 
 @see TSRestClientDelegate::restClient:didReceiveStatus:forNetwork: 
 */
- (void) getRegistrationStatus:(NSString*) networkId checkRelated:(BOOL) checkRelated;


/**
 This method registers a network ID and phone number pair 
 and relates them to the current application.
 
 @param networkId	The ID of the network to be registered.
 @param phone		The phone number to relate to the network ID.
 
 @see TSRestClientDelegate::restClient:didRegisterNetworkId:withStatus:
 */
- (void) registerNetworkId:(NSString*) networkId phone:(NSString*) phone;

/**
 This method creates a conference call with two or more participants.
 
 @param networkId	The network ID of the conference leader.
 @param greetingId	The media ID of a pre-recorded greeting to be played to conference participants
					when they answer their phones. If this parameter is <i>nil</i>, the default 
					greeting is used.
 @param recordingId The media ID to which the conference audio is to be recorded or <i>nil</i>.
					When the conference ends, an audio file will be produced that is mapped to this
					media id. If the parameter is <i>nil</i> then no recording will be performed.
 
 @see TSRestClientDelegate::restClient:didCreateConferenceId:withStatus:
 */
- (void) createConferenceWithNetwork:(NSString*) networkId greetingId:(NSString *)greetingId recordingId:(NSString *)recordingId ;


/**
 This method returns a Media ID associated with current application that can be 
 used with subsequent "record" and "blast" methods.
 
 @see TSRestClientDelegate::restClient:didCreateMedia:withStatus:
 */
- (void) createMedia;

/**
 This method causes the specified networkId to be called and played a 
 "record greeting" prompt. The status of the recording can subsequently 
 be determined by calling the getMediaStatus:(NSString*) mediaId method 
 and supplying the appropriate Media ID.
 
 @param mediaId		The ID of the media to be used in recording.
 @param networkId	The network ID to call.
 
 @see TSRestClientDelegate::restClient:didRecordMedia:withStatus:
 */
- (void) recordMedia:(NSString*) mediaId network:(NSString*) networkId;

/**
 This method causes the specified networkid to be called and 
 played a previously-recorded greeting.
 
 @param mediaId		The ID of the media to be played.
 @param networkID	The ID of the network to call.
 
 @see TSRestClientDelegate::restClient:didBlastMedia:withStatus:
 */
- (void) blastMedia:(NSString*) mediaId network:(NSString*) networkId;

/**
 This method retrieves status information about the Media ID and the operation in progress, if any.
 
 @param mediaId		The ID of the media to get status of.
 
 @see TSRestClientDelegate::restClient:didReceiveStatus:forMedia:
 */
- (void) getMediaStatus:(NSString*) mediaId;

/**
 This method adds one or more additional network IDs (call legs) to the conference.
 
 @param networks		One or more network IDs to add to the conference.
 @param conferenceId	The conference ID to add network to.
 @param greetingId		The media ID of a pre-recorded greeting to be played to conference participants
						when they answer their phones. If this parameter is <i>nil</i>, the default 
						greeting is used.
 
 @see TSRestClientDelegate::restClient:didAddNetworksToConference:withStatus:
 */
- (void) addNetworks:(NSArray*) networks toConference:(NSString*) conferenceId greetingId:(NSString*) greetingId;

/**
 This method is used to request permission to upload a file. To use this method, 
 the application must first obtain a media ID. When successful, this method returns
 a grant code that may be used to perform a single file upload. The grant code is 
 valid for twenty-four hours after issuance.
 
 @param mediaId		The ID of the media which is associated with this upload request.
 
 @see TSRestClientDelegate::restClient:didReceiveUploadGrant:withStatus:
 */
- (void) requestUploadGrantForMedia:(NSString*) mediaId;

/**
 This method is used to request remove a media instance.
 
 @param mediaId		The ID of the media to remove
 
 @see TSRestClientDelegate::restClient:didRemoveMediaId:withStatus:
 */
- (void) removeMedia:(NSString*) mediaId;

/**
 This method closes (removes) a conference and terminates any call legs in progress.
 
 @param conferenceId	The ID of the conference to terminate.
 
 @see TSRestClientDelegate::restClient:didCloseConferenceId:withStatus:
 */
- (void) closeConference:(NSString*) conferenceId;

/**
 This method terminates the specified conference leg.
 
 @param networkId		The ID of the network to terminate.
 @param conferenceId	The ID of the conference to operate on.
 
 @see TSRestClientDelegate::restClient:didHangupNetworkId:inConferenceId:withStatus:
 */
- (void) hangupNetwork:(NSString*) networkId inConference:(NSString*) conferenceId;

/**
 This method moves a call leg from one conference to another.
 
 @param networkId			The ID of the network to move.
 @param fromConferenceId	The ID of the conference to move the network from.
 @param toConferenceId		The ID of the conference to move the network to.
 
 @see TSRestClientDelegate::restClient:didMoveWithStatus:
 */
- (void) moveNetwork:(NSString*) networkId fromConference:(NSString*) fromConferenceId toConference:(NSString*) toConferenceId;

/**
 This method mutes or un-mutes the specified call leg.
 
 @param	mute			If YES the specified conference leg will be muted, if NO then unmuted.
 @param networkId		The ID of the network associated with the specified call leg.
 @param conferenceId	The ID of the conference to operate on.
 
 @see TSRestClientDelegate::restClient:didMuteWithStatus:
 */
- (void) setMute:(BOOL) mute forNetwork:(NSString*)networkId inConference:(NSString*) conferenceId;


/**
 This method returns the API version in xx.yy.zz format.
 
 @see TSRestClientDelegate::restClient:didReceiveApiVersion:status:
 */
- (void) getAPIVersion;


@property (nonatomic, retain) NSString* applicationKey;
@property (nonatomic, retain) NSString* serviceUrl;
@property (nonatomic, assign) id<TSRestClientDelegate> delegate;

/**
 Upload an mp3 file to the server. 
 
 @param data            Data to upload. Only MP3 files are supported.
 @param grantCode       The grant code previously created via TSRestClient::requestUploadGrantCodeForMedia: method
 
*/
 - (void) uploadData:(NSData*) data withGrantCode:(NSString*) grantCode;


/**
 Returns the default TSRestClient object for the system. This will always return the same instane if the client.
 
 @returns The default BRRestClient object for the system.
 */
+ (TSRestClient*) defaultClient;


@end
