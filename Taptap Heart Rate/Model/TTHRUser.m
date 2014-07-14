//
//  TTHRUser.m
//  Taptap Heart Rate
//
//  Created by Zhang Honghao on 6/28/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

/*
 http://www.topendsports.com/testing/heart-rate-resting-chart.htm
 Resting Heart Rate for MEN
 
 Age            18-25	26-35	36-45	46-55	56-65	65+
 Athlete        49-55	49-54	50-56	50-57	51-56	50-55
 Excellent      56-61	55-61	57-62	58-63	57-61	56-61
 Good           62-65	62-65	63-66	64-67	62-67	62-65
 Above Average	66-69	66-70	67-70	68-71	68-71	66-69
 Average        70-73	71-74	71-75	72-76	72-75	70-73
 Below Average	74-81	75-81	76-82	77-83	76-81	74-79
 Poor           82+     82+     83+     84+     82+     80+
 
 Resting Heart Rate for WOMEN
 
 Age            18-25	26-35	36-45	46-55	56-65	65+
 Athlete        54-60	54-59	54-59	54-60	54-59	54-59
 Excellent      61-65	60-64	60-64	61-65	60-64	60-64
 Good           66-69	65-68	65-69	66-69	65-68	65-68
 Above Average	70-73	69-72	70-73	70-73	69-73	69-72
 Average        74-78	73-76	74-78	74-77	74-77	73-76
 Below Average	79-84	77-82	79-84	78-83	78-83	77-84
 Poor           85+     83+     85+     84+     84+     84+
 
 */

#import "TTHRUser.h"

@implementation TTHRUser {
    NSInteger lowest;
    NSInteger highest;
}

+ (TTHRUser *)sharedUser {
    static TTHRUser *sharedUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        LogMethod;
        sharedUser = [[self alloc] init];
    });
    return sharedUser;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _isCompleted = NO;
        _gender = GenderUnknown;
        _age = -1;
        _choosedMode = TapMode;
    }
    return self;
}

- (void)setAge:(NSInteger)age {
    LogMethod;
    _age = age;
    [self updateMaxHR];
    [self updateIsCompleted];
    [self save];
}

- (void)setGender:(Gender)gender {
    LogMethod;
    _gender = gender;
    [self updateMaxHR];
    [self updateIsCompleted];
    [self save];
}

- (NSInteger)calculateMaxHR {
    if (_gender == GenderMale) {
        return (NSInteger)(202 - (0.55 * _age));
    } else if (_gender == GenderFemale) {
        return (NSInteger)(216 - (1.09 * _age));
    } else {
        return 0;
    }
}

- (void)updateMaxHR {
    _maxHR = [self calculateMaxHR];
    NSLog(@"maxHR: %d", _maxHR);
}

- (void)updateIsCompleted {
    if (_age > 0 && _gender != GenderUnknown) {
        _isCompleted = YES;
    } else {
        _isCompleted = NO;
    }
}

- (void)setChoosedMode:(Mode)choosedMode {
    _choosedMode = choosedMode;
    [self save];
}

//- (void)registerAsObserver {
//    [self addObserver:self
//           forKeyPath:@"age"
//              options:NSKeyValueObservingOptionNew//(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
//              context:NULL];
//    [self addObserver:self
//           forKeyPath:@"gender"
//              options:NSKeyValueObservingOptionNew
//              context:NULL];
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath
//                      ofObject:(id)object
//                        change:(NSDictionary *)change
//                       context:(void *)context {
//    LogMethod;
//    if ([keyPath isEqual:@"age"]) {
//        self.age = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
//    }
//    if ([keyPath isEqual:@"gender"]) {
//        self.gender = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
//    }
//    /*
//     Be sure to call the superclass's implementation *if it implements it*.
//     NSObject does not implement the method.
//     */
//    [super observeValueForKeyPath:keyPath
//                         ofObject:object
//                           change:change
//                          context:context];
//}


//- (NSInteger)lowestHeartRate {
//    
//}
//- (NSInteger)highestHeartRate {
//    
//}

- (void)getHRCondition:(HRCondition *)condition HRPercent:(float *)percent heartRate:(NSInteger)heartRate {
    switch (_gender) {
        case GenderUnknown: {
            *condition = HRUnknown;
            *percent = 0;
            break;
        }
        case GenderMale: {
            if (_age == -1) {
                *condition = HRUnknown;
                *percent = 0;
            } else if (_age <= 25) {
                NSInteger min = 49;
                NSInteger max = 82;
                if (heartRate < 49) {
                    *condition = HRAthlete;
                    *percent = 1.0;
                } else if (heartRate <= 55) {
                    *condition = HRAthlete;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 61) {
                    *condition = HRExcellent;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 65) {
                    *condition = HRGood;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 69) {
                    *condition = HRAboveAverage;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 73) {
                    *condition = HRAvergae;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 81) {
                    *condition = HRBelowAverage ;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else {
                    *condition = HRPoor ;
                    *percent = (float)(max - max) / (max - min);
                }
            } else if (_age <= 35) {
                NSInteger min = 49;
                NSInteger max = 82;
                if (heartRate < 49) {
                    *condition = HRAthlete;
                    *percent = 1.0;
                } else if (heartRate <= 54) {
                    *condition = HRAthlete;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 61) {
                    *condition = HRExcellent;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 65) {
                    *condition = HRGood;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 70) {
                    *condition = HRAboveAverage;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 74) {
                    *condition = HRAvergae;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 81) {
                    *condition = HRBelowAverage ;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else {
                    *condition = HRPoor ;
                    *percent = (float)(max - max) / (max - min);
                }
            } else if (_age <= 45) {
                NSInteger min = 50;
                NSInteger max = 83;
                if (heartRate < 50) {
                    *condition = HRAthlete;
                    *percent = 1.0;
                } else if (heartRate <= 56) {
                    *condition = HRAthlete;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 62) {
                    *condition = HRExcellent;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 66) {
                    *condition = HRGood;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 70) {
                    *condition = HRAboveAverage;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 75) {
                    *condition = HRAvergae;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 82) {
                    *condition = HRBelowAverage ;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else {
                    *condition = HRPoor ;
                    *percent = (float)(max - max) / (max - min);
                }
            } else if (_age <= 55) {
                NSInteger min = 50;
                NSInteger max = 84;
                if (heartRate < 50) {
                    *condition = HRAthlete;
                    *percent = 1.0;
                } else if (heartRate <= 57) {
                    *condition = HRAthlete;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 63) {
                    *condition = HRExcellent;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 67) {
                    *condition = HRGood;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 71) {
                    *condition = HRAboveAverage;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 76) {
                    *condition = HRAvergae;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 83) {
                    *condition = HRBelowAverage ;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else {
                    *condition = HRPoor ;
                    *percent = (float)(max - max) / (max - min);
                }
            } else if (_age <= 65) {
                NSInteger min = 51;
                NSInteger max = 82;
                if (heartRate < 50) {
                    *condition = HRAthlete;
                    *percent = 1.0;
                } else if (heartRate <= 56) {
                    *condition = HRAthlete;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 61) {
                    *condition = HRExcellent;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 67) {
                    *condition = HRGood;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 71) {
                    *condition = HRAboveAverage;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 75) {
                    *condition = HRAvergae;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 81) {
                    *condition = HRBelowAverage ;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else {
                    *condition = HRPoor ;
                    *percent = (float)(max - max) / (max - min);
                }
            } else {
                NSInteger min = 50;
                NSInteger max = 80;
                if (heartRate < 50) {
                    *condition = HRAthlete;
                    *percent = 1.0;
                } else if (heartRate <= 55) {
                    *condition = HRAthlete;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 61) {
                    *condition = HRExcellent;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 65) {
                    *condition = HRGood;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 69) {
                    *condition = HRAboveAverage;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 73) {
                    *condition = HRAvergae;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 79) {
                    *condition = HRBelowAverage ;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else {
                    *condition = HRPoor ;
                    *percent = (float)(max - max) / (max - min);
                }
            }
            break;
        }
        case GenderFemale: {
            if (_age == -1) {
                *condition = HRUnknown;
                *percent = 0;
            } else if (_age <= 25) {
                NSInteger min = 54;
                NSInteger max = 85;
                if (heartRate < 54) {
                    *condition = HRAthlete;
                    *percent = 1.0;
                } else if (heartRate <= 60) {
                    *condition = HRAthlete;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 65) {
                    *condition = HRExcellent;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 69) {
                    *condition = HRGood;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 73) {
                    *condition = HRAboveAverage;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 78) {
                    *condition = HRAvergae;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 84) {
                    *condition = HRBelowAverage ;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else {
                    *condition = HRPoor ;
                    *percent = (float)(max - max) / (max - min);
                }
            } else if (_age <= 35) {
                NSInteger min = 54;
                NSInteger max = 83;
                if (heartRate < 54) {
                    *condition = HRAthlete;
                    *percent = 1.0;
                } else if (heartRate <= 59) {
                    *condition = HRAthlete;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 64) {
                    *condition = HRExcellent;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 68) {
                    *condition = HRGood;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 72) {
                    *condition = HRAboveAverage;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 76) {
                    *condition = HRAvergae;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 82) {
                    *condition = HRBelowAverage ;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else {
                    *condition = HRPoor ;
                    *percent = (float)(max - max) / (max - min);
                }
            } else if (_age <= 45) {
                NSInteger min = 54;
                NSInteger max = 59;
                if (heartRate < 54) {
                    *condition = HRAthlete;
                    *percent = 1.0;
                } else if (heartRate <= 59) {
                    *condition = HRAthlete;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 64) {
                    *condition = HRExcellent;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 69) {
                    *condition = HRGood;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 73) {
                    *condition = HRAboveAverage;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 78) {
                    *condition = HRAvergae;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 84) {
                    *condition = HRBelowAverage ;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else {
                    *condition = HRPoor ;
                    *percent = (float)(max - max) / (max - min);
                }
            } else if (_age <= 55) {
                NSInteger min = 54;
                NSInteger max = 84;
                if (heartRate < 54) {
                    *condition = HRAthlete;
                    *percent = 1.0;
                } else if (heartRate <= 60) {
                    *condition = HRAthlete;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 65) {
                    *condition = HRExcellent;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 69) {
                    *condition = HRGood;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 73) {
                    *condition = HRAboveAverage;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 77) {
                    *condition = HRAvergae;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 83) {
                    *condition = HRBelowAverage ;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else {
                    *condition = HRPoor ;
                    *percent = (float)(max - max) / (max - min);
                }
            } else if (_age <= 65) {
                NSInteger min = 54;
                NSInteger max = 59;
                if (heartRate < 54) {
                    *condition = HRAthlete;
                    *percent = 1.0;
                } else if (heartRate <= 59) {
                    *condition = HRAthlete;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 64) {
                    *condition = HRExcellent;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 68) {
                    *condition = HRGood;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 73) {
                    *condition = HRAboveAverage;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 77) {
                    *condition = HRAvergae;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 83) {
                    *condition = HRBelowAverage ;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else {
                    *condition = HRPoor ;
                    *percent = (float)(max - max) / (max - min);
                }
            } else {
                NSInteger min = 54;
                NSInteger max = 84;
                if (heartRate < 54) {
                    *condition = HRAthlete;
                    *percent = 1.0;
                } else if (heartRate <= 59) {
                    *condition = HRAthlete;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 64) {
                    *condition = HRExcellent;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 68) {
                    *condition = HRGood;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 72) {
                    *condition = HRAboveAverage;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 76) {
                    *condition = HRAvergae;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else if (heartRate <= 84) {
                    *condition = HRBelowAverage ;
                    *percent = (float)(max - heartRate) / (max - min) ;
                } else {
                    *condition = HRPoor ;
                    *percent = (float)(max - max) / (max - min);
                }
            }
            break;
        }
        default:
            break;
    }
//    NSLog(@"%f", *percent);
    *percent += 0.20;
    if (*percent > 1.0) {
        *percent = 1.0;
    }
}


//- (void)setAge:(NSInteger)newAge gender:(Gender)gen
//{
//    self.age = newAge;
//    self.gender = gen;
//    [self save];
//}


- (void)save
{
    LogMethod;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.age forKey:@"UserAge"];
    [defaults setInteger:self.gender forKey:@"UserGender"];
    [defaults setInteger:self.choosedMode forKey:@"UserChoosedMode"];
    [defaults setInteger:self.maxHR forKey:@"MaxHR"];
    [defaults synchronize];
}


- (void)load
{
    LogMethod;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _age = [defaults integerForKey:@"UserAge"];
    _gender = (int)[defaults integerForKey:@"UserGender"];
    _choosedMode = (int)[defaults integerForKey:@"UserChoosedMode"];
    _maxHR = [defaults integerForKey:@"MaxHR"];
    [self updateIsCompleted];
    NSLog(@"Age: %d", _age);
}

@end
