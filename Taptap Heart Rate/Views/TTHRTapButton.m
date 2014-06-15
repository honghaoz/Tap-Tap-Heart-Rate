//
//  TTHRTapButton.m
//  Taptap Heart Rate
//
//  Created by Zhang Honghao on 6/13/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TTHRTapButton.h"

@implementation TTHRTapButton {
    CGFloat _circleWidth;
    CGFloat _shrinkWidth;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    UIColor *whiteColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.83];
    return [self initWithFrame:frame circleWidth:10 buttonColor:whiteColor circleColor:whiteColor];
}

- (instancetype)initWithFrame:(CGRect)frame circleWidth:(CGFloat)cirWidth buttonColor:(UIColor *)btnColor circleColor:(UIColor *)cirColor {
    self = [super initWithFrame:frame];
    if (self) {
        _circleWidth = cirWidth;
        _shrinkWidth = 9 + _circleWidth;
        self.buttonColor = btnColor;
        self.buttonCircleColor = cirColor;
        CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
        [btnColor getRed:&red green:&green blue:&blue alpha:&alpha];
        self.buttonColorHighLighted = [UIColor colorWithRed:red green:green blue:blue alpha:alpha - 0.3];
        [self setBackgroundImage:[self imageWithButtonColor:btnColor circleColor:cirColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[self imageWithButtonColor:self.buttonColorHighLighted circleColor:cirColor] forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)setbuttonColor:(UIColor *)color {
    _buttonColor = color;
    
}

- (void)setbuttonCircleColor:(UIColor *)color {
    _buttonCircleColor = color;
}

- (void)setbuttonColorHighLighted:(UIColor *)color {
    _buttonColorHighLighted = color;
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

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
////    LogMethod;
//    [super touchesBegan:touches withEvent:event];
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
////    LogMethod;
//    [super touchesMoved:touches withEvent:event];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
////    LogMethod;
//    [super touchesEnded:touches withEvent:event];
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
////    LogMethod;
//    [super touchesCancelled:touches withEvent:event];
//}

- (UIImage *)imageWithButtonColor:(UIColor *)btnColor circleColor:(UIColor *)cirColor {
    CGFloat cirRed = 0.0, cirGreen = 0.0, cirBlue = 0.0, cirAlpha =0.0;
    [cirColor getRed:&cirRed green:&cirGreen blue:&cirBlue alpha:&cirAlpha];
    
    CGFloat btnRed = 0.0, btnGreen = 0.0, btnBlue = 0.0, btnAlpha =0.0;
    [btnColor getRed:&btnRed green:&btnGreen blue:&btnBlue alpha:&btnAlpha];
    
    UIGraphicsBeginImageContext(self.bounds.size);
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 1);
    CGContextSetRGBStrokeColor(ctx, cirRed, cirGreen, cirBlue, cirAlpha);
    CGContextSetRGBFillColor(ctx, btnRed, btnGreen, btnBlue, btnAlpha);
    
    // Draw rounded button
    CGRect roundRect = self.bounds;
    roundRect.size.height -= 2 * _shrinkWidth;
    roundRect.size.width -= 2 * _shrinkWidth;
    roundRect.origin.x = _shrinkWidth;
    roundRect.origin.y = _shrinkWidth;
    CGContextFillEllipseInRect(ctx, roundRect);
    
    // Draw Circle
    CGPoint center;
    center.x = self.bounds.size.width / 2.0;
    center.y = self.bounds.size.height / 2.0;
    CGFloat radius = self.bounds.size.height / 2;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    path.lineWidth = _circleWidth;//shrinkPoints / 6;
    //[path moveToPoint:CGPointMake(center.x + radius - shrinkPoints, center.y)];
    [path addArcWithCenter:center radius:radius - path.lineWidth startAngle:0.0 endAngle:M_PI * 2.0 clockwise:YES];
    
    [path stroke];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGFloat radius = self.bounds.size.height / 2;
    CGPoint touchedPoint = [touch locationInView:self];
    CGPoint center = CGPointMake(radius, radius);
    CGFloat distanceToCenter = sqrtf(pow(touchedPoint.x - center.x, 2) + pow(touchedPoint.y - center.y, 2));
    if (distanceToCenter < radius - _shrinkWidth + radius * 1/10) {
        return YES;
    } else {
        return NO;
    }
}

@end
