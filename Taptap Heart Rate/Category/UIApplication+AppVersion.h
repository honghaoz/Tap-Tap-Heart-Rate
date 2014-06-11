//
//  UIApplication+AppVersion.h
//  UW Info
//
//  Created by Zhang Honghao on 3/12/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (AppVersion)

+ (NSString *) appVersion;
+ (NSString *) build;
+ (NSString *) versionBuild;

@end
