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

/**
 *  Set above title string and color. If passed in @"", this label will be removed
 *
 *  @param string     Title string
 *  @param titleColor Color for title
 */
- (void)setLabelAboveWithTitle:(NSString *)string andColor:(UIColor *)titleColor;

/**
 *  Set below title string and color. If passed in @"", this label will be removed
 *
 *  @param string     Title string
 *  @param titleColor Color for title
 */
- (void)setLabelBelowWithTitle:(NSString *)string andColor:(UIColor *)titleColor;

/**
 *  Make the button Color dim -0.15
 *
 *  @param isDim Whether need to dim
 */
- (void)setDimmed:(BOOL)isDim;

/**
 *  Enlarge touchable area of the button, useful for small buttons
 *
 *  @param enlarge Radius that need to enlarge
 */
- (void)enlargeShouldTapRaidus:(float)enlarge;

/**
 *  Set whether touches on this button could pass to its parent view
 *
 *  @param shouldPass <#shouldPass description#>
 */
- (void)setShouldPassTouch:(BOOL)shouldPass;

@end
