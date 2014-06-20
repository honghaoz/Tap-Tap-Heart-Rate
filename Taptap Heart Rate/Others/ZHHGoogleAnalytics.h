//
//  ZHHGoogleAnalytics.h
//  ZHH GoogleAnalytics
//
//  Created by Zhang Honghao on 4/2/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHHGoogleAnalytics : NSObject

/**
 *  Track Screen with Name
 *
 *  @param screenName Screen name
 */
+ (void)trackScreen:(NSString *)screenName;

@end
