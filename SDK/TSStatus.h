//
//  BMStatus.h
//  BitmouthSDK
//
//  Created by Anton Minin on 8/2/11.
//  Copyright 2011 UMITI. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBMStatusOk					200
#define kBMStatusCreated			201
#define kBMStatusNoContent			204
#define kBMStatusBadRequest			400
#define kBMStatusUnauthorized		401
#define kBMStatusNotFound			404
#define kBMStatusBadGateway			502

#define kBMStatusAppKeyMissing		1001
#define kBMStatusServiceUrlMissing	1002
#define kBMStatusServiceUnavaialble	1003
#define kBMStatusInvalidResponse	1004

/**
 A BMStatus object encapsulates information about REST service call outcome
 */
@interface TSStatus : NSObject {
}

@property (nonatomic, assign) int code;
@property (nonatomic, retain) NSString* message;

/**
 Returns a BMStatus object initialized for a given status code and status message
 
 @param aCode		The numeric status code.
 @param aMessage	The status message, may be empty.
 */
- (id) initWithCode:(int) aCode message:(NSString*) aMessage;

/**
 Returns a Boolean value that indicates whether the receiver's status code is 2xx
 
 @returns YES if the receiver's status code is in range 200..299, returns NO in the other case
 */
- (BOOL) isOk;

/**
 Returns an auto-released BMStatus object initialized for a given status code and status message
 
 */
+ (TSStatus*) statusWithCode:(int) aCode message:(NSString*) aMessage;
+ (TSStatus*) ok;

+ (TSStatus*) statusWithResponseDictionary:(NSDictionary*) dictionary;

@end
