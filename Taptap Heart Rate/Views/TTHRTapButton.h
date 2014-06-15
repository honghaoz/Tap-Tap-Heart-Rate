//
//  TTHRTapButton.h
//  Taptap Heart Rate
//
//  Created by Zhang Honghao on 6/13/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTHRTapButton : UIButton

@property (nonatomic, strong) UIColor *buttonColor;
@property (nonatomic, strong) UIColor *buttonCircleColor;

@property (nonatomic, strong) UIColor *buttonColorHighLighted;

- (instancetype)initWithFrame:(CGRect)frame circleWidth:(CGFloat)cirWidth buttonColor:(UIColor *)btnColor circleColor:(UIColor *)cirColor;

@end
