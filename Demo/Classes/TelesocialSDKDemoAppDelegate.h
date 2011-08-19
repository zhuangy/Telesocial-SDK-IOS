//
//  TelesocialSDKDemoAppDelegate.h
//  TelesocialSDKDemo
//
//  Created by Anton Minin on 8/9/11.
//  Copyright 2011 UMITI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TelesocialSDKDemoAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

