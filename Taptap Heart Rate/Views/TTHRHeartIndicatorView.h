//
//  TTHRHeartIndicatorView.h
//  Taptap Heart Rate
//
//  Created by Zhang Honghao on 6/28/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTHRHeartIndicatorView : UIView

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color imageNamed:(NSString *)imageName;

- (void)setPercent:(float)percent withDuration:(float)duration;
- (void)setBlink:(BOOL)toBlink;

@end
