//
//  BMMediaInfo.h
//  TelesocialSDK
//
//  Created by Anton Minin on 8/2/11.
//  Copyright 2011 UMITI. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TSMediaInfo : NSObject {

}

@property (nonatomic, retain) NSString* id;
@property (nonatomic, retain) NSString* downloadUrl;
@property (nonatomic, assign) long long fileSize;

- (id) initWithId:(NSString*) anId downloadUrl:(NSString*) aDownloadUrl
		 fileSize:(long long) aFileSize;

+ (TSMediaInfo*) mediaInfoWithId:(NSString*) anId downloadUrl:(NSString*) aDownloadUrl
						fileSize:(long long) aFileSize;
   
+ (TSMediaInfo*) mediaInfoWithResponseObject:(NSDictionary*) responseObject;

@end
