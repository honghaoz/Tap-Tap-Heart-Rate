//
//  ZHHHandyMacros.h
//
//  Created by Zhang Honghao on 6/10/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <Foundation/Foundation.h>

// NSLog(...) -> ConciseNSLog(...)
// Define NSLog as ConciseNSLog
#ifdef DEBUG
    #define NSLog(args...) ConciseNSLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);
#else
    #define NSLog(x...)
#endif

void ConciseNSLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...);

void ConciseNSLogWithoutTimeStamp(const char *file, int lineNumber, const char *functionName, NSString *format, ...);

// NSLogX(...) -> ExtendNSLog(...)
// Define NSLogX(), include function name, file name and line number
#define NSLogX(args...) ExtendNSLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);

void ExtendNSLog(const char *file, int lineNumber, const char *functionName, NSString *format, ...);

// Log class name and method name
#define LogMethod NSLog(@"-[%@ %@]", NSStringFromClass(self.class),NSStringFromSelector(_cmd))

// NSInteger to NSString
#define NSIntegerToString(i) [NSString stringWithFormat:@"%lu", (unsigned long)i]

// Print an Object, to see if this object is nil
#define PrintNil(object) NSLog(@"%@ is %@", [object class], object == nil? @"nil" : @"not nil")

// Detect 4inch or 3.5inch
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
