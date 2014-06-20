//
//  ZHHParseDevice.h
//  ZHH Track Parse Device
//
//  Created by Zhang Honghao on 6/10/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZHHParseDevice : NSObject

@property (nonatomic, copy) NSString *applicationID;
@property (nonatomic, copy) NSString *clientKey;

+ (void)trackDevice;
+ (void)queryDeviceWithDefaultName:(NSString *)defaultName;

@end
