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
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        isMoved = NO;
        isMoving = NO;
        lastMoveEnd = NO;
    }
    return self;
}

#pragma mark - UIResponder methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    LogMethod;
    isMoved = NO;
    lastMoveEnd = YES;
    [super touchesBegan:touches withEvent:event];
    for (UITouch *touch in touches) {
        touchBeginPoint = [touch locationInView:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissKeyboard" object:self userInfo:@{@"TouchedScreen": [NSNumber numberWithInteger:[self getScreenFromTouchPoint:[touch locationInView:self]]]}];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    LogMethod;
    for (UITouch *touch in touches) {
        CGPoint currentPoint = [touch locationInView:self];
        if (touchBeginPoint.x - currentPoint.x > 70) {
            isMoved = YES;
            if (!isMoving && lastMoveEnd) {
                lastMoveEnd = NO;
                [self moveToScreen:Screen1];
            }
        }
        if (currentPoint.x - touchBeginPoint.x > 70) {
            isMoved = YES;
            if (!isMoving && lastMoveEnd) {
                lastMoveEnd = NO;
                [self moveToScreen:Screen0];
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
            if (touchedScreen == Screen0) {
                [self moveToScreen:Screen0];
            } else if (touchedScreen == Screen1) {
                [self moveToScreen:Screen1];
            }
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
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if (0 <= point.x && point.x < screenWidth) {
        return Screen0;
    } else if (point.x < screenWidth * 2) {
        return Screen1;
    } else {
        return Screen2;
    }
}

- (void)moveToScreen:(Screen)sc {
//    LogMethod;
    if (sc == Screen0) {
        if (isMoving == NO) {
//            NSLog(@"%@", @"Screen0");
            isMoving = YES;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 [self setContentOffset:CGPointMake(0, 0) animated:NO];
                             } completion:^(BOOL finished) {
                                 isMoving = NO;
//                                 NSLog(@"Screen0 complete");
                             }];
            if ([self.screenDelegate respondsToSelector:@selector(scrollView:moveToScreen:)]) {
                [self.screenDelegate scrollView:self moveToScreen:Screen0];
            }
        }
    } else if (sc == Screen1) {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        if (isMoving == NO) {
//            NSLog(@"%@", @"Screen1");
            isMoving = YES;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 [self setContentOffset:CGPointMake(self.contentSize.width - screenWidth, 0) animated:NO];
                             } completion:^(BOOL finished) {
                                 isMoving = NO;
//                                 NSLog(@"Screen1 complete");
                             }];
            if ([self.screenDelegate respondsToSelector:@selector(scrollView:moveToScreen:)]) {
                [self.screenDelegate scrollView:self moveToScreen:Screen1];
            }
        }
    }
}

@end
