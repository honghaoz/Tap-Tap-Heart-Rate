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
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - UIResponder methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    LogMethod;
    isMoved = NO;
    [super touchesBegan:touches withEvent:event];
    for (UITouch *touch in touches) {
        touchBeginPoint = [touch locationInView:self];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    LogMethod;
    for (UITouch *touch in touches) {
        CGPoint currentPoint = [touch locationInView:self];
        if (touchBeginPoint.x - currentPoint.x > 70) {
            isMoved = YES;
            [self setContentOffset:CGPointMake(self.contentSize.width - 320, 0) animated:YES];
            if ([self.screenDelegate respondsToSelector:@selector(scrollView:moveToScreen:)]) {
                [self.screenDelegate scrollView:self moveToScreen:Screen1];
            }
        }
        if (currentPoint.x - touchBeginPoint.x > 70) {
            isMoved = YES;
            [self setContentOffset:CGPointMake(0, 0) animated:YES];
            if ([self.screenDelegate respondsToSelector:@selector(scrollView:moveToScreen:)]) {
                [self.screenDelegate scrollView:self moveToScreen:Screen0];
            }
        }
    }
    [super touchesMoved:touches withEvent:event];
    //    [self.nextResponder touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    LogMethod;
    if (!isMoved) {
        for (UITouch *touch in touches) {
            CGPoint currentPoint = [touch locationInView:self];
            Screen touchedScreen = [self getScreenFromTouchPoint:currentPoint];
            if (touchedScreen == Screen0) {
                [self setContentOffset:CGPointMake(0, 0) animated:YES];
                if ([self.screenDelegate respondsToSelector:@selector(scrollView:moveToScreen:)]) {
                    [self.screenDelegate scrollView:self moveToScreen:Screen0];
                }
            } else if (touchedScreen == Screen1) {
                [self setContentOffset:CGPointMake(self.contentSize.width - 320, 0) animated:YES];
                if ([self.screenDelegate respondsToSelector:@selector(scrollView:moveToScreen:)]) {
                    [self.screenDelegate scrollView:self moveToScreen:Screen1];
                }
            }
        }
    }
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    LogMethod;
    [super touchesCancelled:touches withEvent:event];
}


#pragma mark - Helper methods

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

@end
