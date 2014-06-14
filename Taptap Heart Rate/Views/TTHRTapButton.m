//
//  TTHRTapButton.m
//  Taptap Heart Rate
//
//  Created by Zhang Honghao on 6/13/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TTHRTapButton.h"

@implementation TTHRTapButton {
    UIColor *_buttonColor;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        LogMethod;
        [self setImage:[self imageWithRed:0.2 green:0.2 blue:0.2 alpha:0.7] forState:UIControlStateHighlighted];
        [self setImage:[self imageWithRed:0.2 green:0.2 blue:0.2 alpha:0.9] forState:UIControlStateNormal];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//    LogMethod;
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(ctx, 1);
//    CGContextSetRGBStrokeColor(ctx, buttonColor.);
//    CGContextSetRGBFillColor(ctx, 0.1, 0.1, 0.1, 0.8);
//    CGRect circleRect = self.bounds;
//    CGContextFillEllipseInRect(ctx, circleRect);
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    LogMethod;
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    LogMethod;
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    LogMethod;
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    LogMethod;
    [super touchesCancelled:touches withEvent:event];
}

- (UIImage *)imageWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    UIGraphicsBeginImageContext(self.bounds.size);
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 1);
    CGContextSetRGBStrokeColor(ctx, red, green, blue, alpha);
    CGContextSetRGBFillColor(ctx, red, green, blue, alpha);
    CGRect circleRect = self.bounds;
    CGContextFillEllipseInRect(ctx, circleRect);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    LogMethod;
    CGFloat radius = self.bounds.size.height / 2;
    CGPoint touchedPoint = [touch locationInView:self];
    CGPoint center = CGPointMake(radius, radius);
    CGFloat distanceToCenter = sqrtf(pow(touchedPoint.x - center.x, 2) + pow(touchedPoint.y - center.y, 2));
    NSLog(@"%f %f", radius, distanceToCenter);
    if (distanceToCenter <= radius ) {
        return YES;
    } else {
        return NO;
    }
}

@end
