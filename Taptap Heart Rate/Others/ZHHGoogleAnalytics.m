//
//  ZHHGoogleAnalytics.m
//  ZHH GoogleAnalytics
//
//  Created by Zhang Honghao on 4/2/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "ZHHGoogleAnalytics.h"
#import <Google/Analytics.h>

@implementation ZHHGoogleAnalytics

+ (void)trackScreen:(NSString *)screenName {
    // Google Analytics
    id tracker = [[GAI sharedInstance] defaultTracker];
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName
           value:screenName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
	[tracker dispatch];
}

@end
