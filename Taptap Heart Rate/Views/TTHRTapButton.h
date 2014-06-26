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

@property (nonatomic, strong) UILabel *labelBelow;
@property (nonatomic, strong) UILabel *labelAbove;

/**
 *  Initiate a button with frame, circle width, button color and circlr color
 *
 *  @param frame    Button rect frame
 *  @param cirWidth Circle width
 *  @param btnColor The color of the button inside the circle
 *  @param cirColor The color of the circle
 *
 *  @return a TTHRTapButton instance
 */
- (instancetype)initWithFrame:(CGRect)frame circleWidth:(CGFloat)cirWidth buttonColor:(UIColor *)btnColor circleColor:(UIColor *)cirColor;
- (void)setLabelAboveWithTitle:(NSString *)string andColor:(UIColor *)titleColor;
- (void)setLabelBelowWithTitle:(NSString *)string andColor:(UIColor *)titleColor;

/**
 *  Make the button Color dim -0.15
 *
 *  @param isDim Whether need to dim
 */
- (void)setDimmed:(BOOL)isDim;

@end
