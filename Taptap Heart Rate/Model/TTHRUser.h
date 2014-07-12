//
//  TTHRUser.h
//  Taptap Heart Rate
//
//  Created by Zhang Honghao on 6/28/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTHRMainViewController.h"

@interface TTHRUser : NSObject

typedef enum {
    GenderUnknown = 100,
    GenderMale,
    GenderFemale
} Gender;

typedef enum {
    HRUnknown = 200,
    HRAthlete,
    HRExcellent,
    HRGood,
    HRAboveAverage,
    HRAvergae,
    HRBelowAverage,
    HRPoor
} HRCondition;

@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) Gender gender;
@property (nonatomic, assign) Mode choosedMode;

+ (TTHRUser *)sharedUser;

//- (void)setAge:(NSInteger)newAge gender:(Gender)gen;
- (void)getHRCondition:(HRCondition *)condition  HRPercent:(float *)percent heartRate:(NSInteger)heartRate;

- (void)save;
- (void)load;

@end
