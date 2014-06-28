//
//  TTHRHintView.h
//  Taptap Heart Rate
//
//  Created by Zhang Honghao on 6/28/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PinAbove = 100,
    PinRight,
    PinBelow,
    PinLeft
} PinDirection;

@interface TTHRHintView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                  borderColor:(UIColor *)borderColor
                  borderWidth:(CGFloat)width
              backgroundColor:(UIColor *)backgroundColor
                 pinDirection:(PinDirection)direction
                  pinPosition:(float)position
                 triangleSize:(CGSize)triangleSize;

- (void)moveTriangleToPosition:(CGFloat)position;
- (void)setShow:(BOOL)toShow withDuration:(float)duration affectCounter:(BOOL)affect;

- (void)setText:(NSString *)text;

@end
