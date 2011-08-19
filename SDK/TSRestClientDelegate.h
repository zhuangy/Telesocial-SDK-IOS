//
//  TSRestClientDelegate.h
//  BitmouthSDK
//
//  Created by Anton Minin on 8/2/11.
//  Copyright 2011 UMITI. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TSStatus.h"
#import "TSMediaInfo.h"

@class TSRestClient;

@protocol TSRestClientDelegate

@optional

/**
 Sent when the client has finished executing TSRestClient::registerNetworkId:phone: call.
 
 @param client		The client sending the message. 
 @param networkId   ID of the network or nil, if registration has failed.
 @param status      Status of the operation. <br><br>
	kBMStatusCreated (201)		- The registration succeeded.<br>
	kBMStatusBadRequest (400)	- One or more parameters were invalid or this (phone, networkid) pair is already registered.<br>
	kBMStatusBadGateway (502)	- Unable to start the phone authorization process.
 */
- (void) restClient:(TSRestClient*) client didRegisterNetworkId:(NSString*) networkId 
		 withStatus:(TSStatus*) status;

/**
 Sent when the client has finished executing TSRestClient::createConference:record: call.
 
 @param client			The client sending the message.
 @param conferenceId	The ID of the newly created conference.
 @param status      Status of the operation. <br><br>
	kBMStatusCreated (201)		- The conference request has been accepted.<br> 
	kBMStatusBadGateway (502)	- The request cannot be fulfilled at this time.
 */ 
- (void) restClient:(TSRestClient*) client didCreateConferenceId:(NSString*) conferenceId 
		 withStatus:(TSStatus*) status;

/**
 Sent when the client has finished executing TSRestClient::createMedia call.

 @param client			The client sending the message.
 @param mediaInfo		Information about newly created media item.
 @param status			Status of the operation. <br><br>
	kBMStatusCreated (201)		- The conference request has been accepted.<br> 
	kBMStatusNotFound (404)		- The application key is invalid.
 
 */ 
- (void) restClient:(TSRestClient*) client didCreateMedia:(TSMediaInfo*) mediaInfo
         withStatus:(TSStatus*) status;

/**
 Sent when the client has finished executing TSRestClient::recordMedia:network: call.
 
 @param client			The client sending the message.
 @param mediaInfo		The media used for recording.
 @param status			Status of the operation. <br><br>
	kBMStatusCreated (201)		- The "record" request has been accepted.<br>
	kBMStatusNotFound (404)		- The application key is invalid or the application is not associated with the networkid.<br>
	kBMStatusBadGateway (502)	- Unable to initiate phone call at this time.
 */ 
- (void) restClient:(TSRestClient*) client didRecordMedia:(TSMediaInfo*) mediaInfo
		 withStatus:(TSStatus*) status;

/**
 Sent when the client has finished executing TSRestClient::blastMedia:network: call.
 
 @param client			The client sending the message.
 @param mediaInfo		The media used in the blast.
 @param status			Status of the operation. <br><br>
 	kBMStatusCreated (201)		- The "blast" request has been accepted.<br>
	kBMStatusNotFound (404)		- The application key is invalid or the application is not associated with the networkid.<br>
	kBMStatusBadGateway (502)	- Unable to initiate phone call at this time.
 */ 
- (void) restClient:(TSRestClient*) client didBlastMedia:(TSMediaInfo*) mediaInfo
		 withStatus:(TSStatus*) status;

/**
 Sent when the client has finished executing TSRestClient::getMediaStatus: call.

 @param client			The client sending the message.
 @param status			Status of the operation.<br><br>
	kBMStatusOk (200)			- Media content (ex. mp3 file) exists for this Media ID.<br>
	kBMStatusNoContent (204)	- No media content exists for this Media ID.<br>
	kBMStatusNotFound (404)		- The media ID is invalid.
 @param mediaInfo		The media info sent in the original request. 
 */
- (void) restClient:(TSRestClient*) client didReceiveStatus:(TSStatus*) status forMedia:(TSMediaInfo*) mediaInfo;

/**
 Sent when the client has finished executing TSRestClient::addNetworks:toConference: call.
 
 @param client			The client sending the message.
 @param conferenceId	The ID of the conference.
 @param status			Status of the operation.<br><br>
	kBMStatusOk (200)			- The network IDs have been added to the conference.<br>
	kBMStatusBadRequest (400)	- Missing or invalid parameters.<br>
	kBMStatusBadGateway (502)	- Unable to initiate phone(s) call at this time.
 */ 
- (void) restClient:(TSRestClient*) client didAddNetworksToConference:(NSString*) confrenceId
		 withStatus:(TSStatus*) status;

/**
 Sent when the client has finished executing TSRestClient::requestUploadGrantForMedia: call.

 @param client			The client sending the message.
 @param grantId			A grant code that may be used to perform a single file upload. The grant code is
 valid for 24 hours after issuance.
 @param status			Status of the operation.<br><br>
	kBMStatusCreated (201)		- The grant code has been allocated.<br>
	kBMStatusUnauthorized (401)	- The media ID is invalid or is not associated with the application identified by the appkey parameter.
 */ 
- (void) restClient:(TSRestClient*) client didReceiveUploadGrant:(NSString*) grantId
		 withStatus:(TSStatus*) status;

/**
 Sent when the client has finished executing TSRestClient::removeMedia: call.
 
 @param client			The client sending the message.
 @param mediaId			The ID of the media the service attempted to remove.
 @param status			Status of the operation.<br><br>
	kBMStatusOk (200)			- The media has been removed.<br>
	kBMStatusUnauthorized (401)	- The content associated with the media ID cannot be removed.<br>
	kBMStatusNotFound (404)		- The media ID is invalid.<br>
 */ 
- (void) restClient:(TSRestClient*) client didRemoveMediaId:(NSString*) mediaId
		 withStatus:(TSStatus*) status;

/**
 Sent when the client has finished executing TSRestClient::closeConference: call.
 
 @param client			The client sending the message.
 @param conferenceId	The ID of the conference the service attempted to close.
 @param status			Status of the operation.<br><br>
	kBMStatusOk (200)			- The conference has been closed.<br>
	kBMStatusNotFound (404)		- The conference ID is invalid.<br>
	kBMStatusBadGateway (502)	- Unable to terminate conference calls.
 */ 
- (void) restClient:(TSRestClient*) client didCloseConferenceId:(NSString*) confefenceId
		 withStatus:(TSStatus*) status;

/**
 Sent when the client has finished executing TSRestClient::hangupNetwork:inConference: call.
 
 @param client			The client sending the message.
 @param networkId		The ID of the network the service attempted to hangup.
 @param conferenceId	The ID of the conference.
 @param status			Status of the operation.<br><br>
	kBMStatusOk (200)			- The call leg has been closed.<br>
	kBMStatusUnauthorized (401)	- The specified network ID is not associated with the application 
 identified by the application key.<br>
	kBMStatusNotFound (404)		- The conference ID is invalid.<br>
	kBMStatusBadGateway (502)	- Unable to terminate call at this time.
 */ 
- (void) restClient:(TSRestClient*) client didHangupNetworkId:(NSString*) networkId
     inConferenceId:(NSString*) conferenceId withStatus:(TSStatus*) status;

/**
 Sent when the client has finished executing TSRestClient::moveNetwork:fromConference:toConference: call.
 
 @param client			The client sending the message.
 @param status			Status of the operation.<br><br> 
	kBMStatusOk (200)			- The call leg has been moved.<br>
 kBMStatusUnauthorized (401)	- The specified network ID is not associated with the application 
 identified by the application key.<br>
 	kBMStatusBadGateway (502)	- Unable to move call at this time.
 */ 
- (void) restClient:(TSRestClient*) client didMoveWithStatus:(TSStatus*) status;

/**
 Sent when the client has finished executing TSRestClient::setMute:forNetwork:inConference: call.

 @param client			The client sending the message.
 @param status			Status of the operation.<br><br> 
	kBMStatusOk (200)			- The call has been (un)muted<br>
	kBMStatusUnauthorized (401)	- The specified network ID is not associated with the application
 identified by the application key.<br>
	kBMStatusBadGateway (502)	- Unable to mute call at this time. 
 
 */ 
- (void) restClient:(TSRestClient*) client didMuteWithStatus:(TSStatus*) status;

/**
 Sent when the client has finished executing TSRestClient::getAPIVersion call.
 
 @param client			The client sending the message.
 @param versionString	The API version string in xx.yy.zz format.
 @param status			Status of the operation.<br><br> 
	kBMStatusOk (200)			- Application version retrieved successfuly<br>
 */ 
- (void) restClient:(TSRestClient*) client didReceiveApiVersion:(NSString*) versionString
			 status:(TSStatus*) status;

/**
 Sent when the client has finished executing TSRestClient::getRegistrationStatus:checkRelated: call.
 
 @param client		The client sending the message.
 @param	networkId	The ID of the network that has been checked.
 @param status		The outome of the operation.<br><br>
	If <i>checkRelated</i> was set to YES in the TSRestClient::getRegistrationStatus:checkRelated: call:<br>
	kBMStatusOk (200)			- The registrant with the specified network ID exists and is associated with the application<br>
	kBMStatusUnauthorized (401)	- The network ID exists but it not associated with the specified application.<br>
	kBMStatusNotFound (404)		- The network is not registered.<br><br>
	If <i>checkRelated</i> was set to NO in the TSRestClient::getRegistrationStatus:checkRelated: call:<br>
	kBMStatusOk (200)			- The registrant with the specified network ID exists.<br>
	kBMStatusNotFound (404)		- The registrant with the specified network ID does not exist.<br><br>
 */
- (void) restClient:(TSRestClient*) client didReceiveStatus:(TSStatus*) status forNetwork:(NSString*) networkId;

@end
