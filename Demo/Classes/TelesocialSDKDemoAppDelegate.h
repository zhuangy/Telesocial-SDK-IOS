//
//  TelesocialSDKDemoAppDelegate.h
//  TelesocialSDKDemo
//
//  Created on 8/9/11.
//  Copyright 2011 Telesocial. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TelesocialSDKDemoAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

