//
//  TTHRAppDelegate.m
//  Taptap Heart Rate
//
//  Created by Zhang Honghao on 6/10/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TTHRAppDelegate.h"
#import "TTHRMainViewController.h"
#import <Parse/Parse.h>
#import "ZHHParseDevice.h"
#import <Google/Analytics.h>

#import "TTHRUser.h"

@implementation TTHRAppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    LogMethod;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    self.window.rootViewController = [[TTHRMainViewController alloc] init];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    // Load User data
//    [[TTHRUser sharedUser] load];
    
    // Parse services
    [Parse setApplicationId:@"ifM1WwMLZMMsCWNgwsCbQteYiBjcBLZPuWKQULFH"
                  clientKey:@"fEf84dVgJkeYojraNDbTgB9u8HLKwaYPratdEPEP"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
#if DEBUG
    BOOL testMode = YES;
#else
	BOOL testMode = NO;
#endif
    if (testMode) {
        [ZHHParseDevice trackDevice];
    }

	// Configure tracker from GoogleService-Info.plist.
	NSError *configureError;
	[[GGLContext sharedInstance] configureWithError:&configureError];
	NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
	
	// Optional: configure GAI options.
	GAI *gai = [GAI sharedInstance];
	gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
	gai.dispatchInterval = 10;
	gai.logger.logLevel = testMode ? kGAILogLevelVerbose : kGAILogLevelError;  // remove before app release

	[gai.defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"App" action:@"Launch" label:@"" value:nil] build]];
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
