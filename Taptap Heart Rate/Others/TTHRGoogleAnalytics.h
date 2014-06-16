//
//  TTHRGoogleAnalytics.h
//  UW Info
//
//  Created by Zhang Honghao on 4/2/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTHRGoogleAnalytics : NSObject

/**
 *  Track Screen with Name
 *
 *  @param screenName Screen name
 */
+ (void)analyticScreen:(NSString *)screenName;

@end
