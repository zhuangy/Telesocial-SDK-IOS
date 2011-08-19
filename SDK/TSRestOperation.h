//
//  BMRestOperation.h
//  BitmouthSDK
//
//  Created by Anton Minin on 8/4/11.
//  Copyright 2011 UMITI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSStatus.h"

@interface TSRestOperation : NSOperation {

}

@property (nonatomic, retain) NSURLRequest* request;
@property (nonatomic, retain) NSHTTPURLResponse* response;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, retain) NSError* error;
@property (nonatomic, retain) NSData* data;
@property (nonatomic, retain) NSString* dataString;
@property (nonatomic, retain) id object;
@property (nonatomic, retain) id parsedResponse;

@property (nonatomic, retain) TSStatus* status;

- (id) initWithRequest:(NSURLRequest*) aRequest target:(id) aTarget action:(SEL) anAction;
+ (TSRestOperation*) operationWithRequest:(NSURLRequest*) aRequest target:(id) aTarget action:(SEL) anAction;
+ (TSRestOperation*) operationWithStatus:(TSStatus*) aStatus;

@end
