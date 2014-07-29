//
//  TTHRMainScrollView.m
//  Taptap Heart Rate
//
//  Created by Zhang Honghao on 6/15/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TTHRMainScrollView.h"

@implementation TTHRMainScrollView {
    CGPoint touchBeginPoint;
    BOOL isMoved;
    BOOL isMoving;
    BOOL lastMoveEnd;
    
    Screen _currentScreen;
    CGFloat _offset1_;
    CGFloat _offset0;
    CGFloat _offset1;
    
    CGFloat _width1_;
    CGFloat _width0;
    CGFloat _width1;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        isMoved = NO;
        isMoving = NO;
        lastMoveEnd = NO;
        _currentScreen = Screen0;
    }
    return self;
}

- (void)setCurrentScreen:(Screen)screen {
    _currentScreen = screen;
    switch (screen) {
        case Screen1_: {
            [self setContentOffset:CGPointMake(_offset1_, 0) animated:NO];
            break;
        }
        case Screen0:{
            [self setContentOffset:CGPointMake(_offset0, 0) animated:NO];
            break;
        }
        case Screen1:{
            [self setContentOffset:CGPointMake(_offset1, 0) animated:NO];
            break;
        }
        default:
            assert(NO);
            break;
    }
}

- (void)setScreen1_Offset:(CGFloat)offset1_
            screen0Offset:(CGFloat)offset0
            screen1Offset:(CGFloat)offset1 {
    _offset1_ = offset1_;
    _offset0 = offset0;
    _offset1 = offset1;
}

- (void)setScreen1_Width:(CGFloat)width1_
            screen0Width:(CGFloat)width0
            screen1Width:(CGFloat)width1 {
    _width1_ = width1_;
    _width0 = width0;
    _width1 = width1;
}

#pragma mark - UIResponder methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    LogMethod;
    isMoved = NO;
    lastMoveEnd = YES;
    [super touchesBegan:touches withEvent:event];
    for (UITouch *touch in touches) {
        touchBeginPoint = [touch locationInView:self];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissKeyboard" object:self userInfo:@{@"TouchedScreen": [NSNumber numberWithInteger:[self getScreenFromTouchPoint:[touch locationInView:self]]]}];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    LogMethod;
    for (UITouch *touch in touches) {
        CGPoint currentPoint = [touch locationInView:self];
        // Scroll left
        if (touchBeginPoint.x - currentPoint.x > 70) {
            isMoved = YES;
            if (!isMoving && lastMoveEnd) {
                lastMoveEnd = NO;
                if (_currentScreen != Screen1) {
                    [self moveToScreen:_currentScreen + 1];
                }
            }
        }
        // Scroll right
        if (currentPoint.x - touchBeginPoint.x > 70) {
            isMoved = YES;
            if (!isMoving && lastMoveEnd) {
                lastMoveEnd = NO;
                if (_currentScreen != Screen1_) {
                    [self moveToScreen:_currentScreen - 1];
                }
            }
        }
    }
//    if (!isMoved) {
        [super touchesMoved:touches withEvent:event];
//    }
    //    [self.nextResponder touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    LogMethod;
    if (!isMoved) {
        for (UITouch *touch in touches) {
            CGPoint currentPoint = [touch locationInView:self];
            Screen touchedScreen = [self getScreenFromTouchPoint:currentPoint];
            [self moveToScreen:touchedScreen];
        }
    }
    lastMoveEnd = YES;
//    if (isMoved == NO) {
        [super touchesEnded:touches withEvent:event];
//    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    LogMethod;
    [super touchesCancelled:touches withEvent:event];
}


#pragma mark - Helper methods

/**
 *  Get which screen is the point located
 *
 *  @param point point in the view
 *
 *  @return Screen number
 */
- (Screen)getScreenFromTouchPoint:(CGPoint)point {
    if (0 <= point.x && point.x < _width1_) {
        return Screen1_;
    } else if (_width1_ <= point.x && point.x < _width1_ + _width0) {
        return Screen0;
    } else {
        return Screen1;
    }
}

- (void)moveToScreen:(Screen)sc
{
    if (isMoving == NO) {
        if ([self.screenDelegate scrollView:self shouldMoveToScreen:sc]) {
            isMoving = YES;
            if ([self.screenDelegate respondsToSelector:@selector(scrollView:willMoveToScreen:)]) {
                [self.screenDelegate scrollView:self willMoveToScreen:sc];
            }
            [UIView animateWithDuration:0.3
                animations:^{
                                 switch (sc) {
                                     case Screen1_: {
                                         [self setContentOffset:CGPointMake(_offset1_, 0) animated:NO];
                                         break;
                                     }
                                     case Screen0:{
                                         [self setContentOffset:CGPointMake(_offset0, 0) animated:NO];
                                         break;
                                     }
                                     case Screen1:{
                                         [self setContentOffset:CGPointMake(_offset1, 0) animated:NO];
                                         break;
                                     }
                                     default:
                                         assert(NO);
                                         break;
                                 }
                }
                completion:^(BOOL finished) {
                                 isMoving = NO;
                                 if ([self.screenDelegate respondsToSelector:@selector(scrollView:didMoveToScreen:)]) {
                                     [self.screenDelegate scrollView:self didMoveToScreen:sc];
                                 }
                    _currentScreen = sc;
                }];
        }
    }
}

@end
