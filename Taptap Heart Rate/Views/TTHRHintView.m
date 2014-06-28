//
//  TTHRHintView.m
//  Taptap Heart Rate
//
//  Created by Zhang Honghao on 6/28/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TTHRHintView.h"

#define DEFAULT_BORDER_COLOR [UIColor colorWithRed:1 green:1 blue:1 alpha:0.85]
//#define LINE_WIDTH 1.3

@implementation TTHRHintView {
    CGFloat lineWidth;
    UIView *_roundRectView;
    UIImageView *_triangleView;
    UITextView *_textView;
    PinDirection _direction;
    UIColor *_borderColor;
    
    NSInteger showCounter;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame borderColor:DEFAULT_BORDER_COLOR borderWidth:1.0 backgroundColor:[UIColor redColor] pinDirection:PinAbove pinPosition:0.5 triangleSize:CGSizeMake(25, 15)];
}

- (instancetype)initWithFrame:(CGRect)frame borderColor:(UIColor *)borderColor borderWidth:(CGFloat)width backgroundColor:(UIColor *)backgroundColor pinDirection:(PinDirection)direction pinPosition:(float)position triangleSize:(CGSize)triangleSize{
    self = [super initWithFrame:frame];
    if (self) {
        lineWidth = width;
        _direction = direction;
        showCounter = 0;
        _borderColor = borderColor;
        // Rounded rectangle border
        [self setBackgroundColor:backgroundColor];
        
        _roundRectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
        _roundRectView.layer.borderWidth = lineWidth;
        _roundRectView.layer.borderColor = [borderColor CGColor];
        _roundRectView.layer.cornerRadius = 4.0;
        [self addSubview:_roundRectView];
        
        // Triangle
        CGFloat triangleX;
        CGFloat triangleY;
        CGFloat triangleWidth = triangleSize.width;
        CGFloat triangleHeight = triangleSize.height;
        switch (direction) {
            case PinAbove: {
                triangleX = position * (frame.size.width - triangleWidth);
                triangleY = -triangleHeight + lineWidth;
                break;
            }
            case PinBelow: {
                triangleX = position * (frame.size.width - triangleWidth);
                triangleY = frame.size.height - lineWidth;
                break;
            }
            case PinLeft: {
                triangleX = -triangleWidth + lineWidth;
                triangleY = position * (frame.size.height - triangleHeight);
                break;
            }
            case PinRight: {
                triangleX = frame.size.width - lineWidth;
                triangleY = position * (frame.size.height - triangleHeight);
                break;
            }
            default:
                break;
        }
        
        _triangleView = [[UIImageView alloc] initWithImage:[self imageWithBorderColor:borderColor size:CGSizeMake(triangleWidth, triangleHeight) pinDirection:direction]];
        CGRect triangleFrame = _triangleView.frame;
        triangleFrame.origin = CGPointMake(triangleX, triangleY);
        _triangleView.frame = triangleFrame;
        [_triangleView setBackgroundColor:backgroundColor];
        [self addSubview:_triangleView];
    }
    return self;
}

- (void)moveTriangleToPosition:(CGFloat)position {
    CGFloat triangleX;
    CGFloat triangleY;
    CGFloat triangleWidth = _triangleView.bounds.size.width;
    CGFloat triangleHeight = _triangleView.bounds.size.height;
    switch (_direction) {
        case PinAbove: {
            triangleX = position * (self.frame.size.width - triangleWidth);
            triangleY = -triangleHeight + lineWidth;
            break;
        }
        case PinBelow: {
            triangleX = position * (self.frame.size.width - triangleWidth);
            triangleY = self.frame.size.height - lineWidth;
            break;
        }
        case PinLeft: {
            triangleX = -triangleWidth + lineWidth;
            triangleY = position * (self.frame.size.height - triangleHeight);
            break;
        }
        case PinRight: {
            triangleX = self.frame.size.width - lineWidth;
            triangleY = position * (self.frame.size.height - triangleHeight);
            break;
        }
        default:
            break;
    }
    CGRect newFrame = CGRectMake(triangleX, triangleY, triangleWidth, triangleHeight);
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [_triangleView setFrame:newFrame];
                     }
                     completion:nil];
}

- (void)setShow:(BOOL)toShow withDuration:(float)duration affectCounter:(BOOL)affect {
    if (toShow) {
        NSLog(@"%@", @"show");
        showCounter++;
        self.hidden = NO;
        if ([_textView.text length] <= 0) {
            return;
        }
        CGRect newFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, _textView.frame.size.width, _textView.frame.size.height);
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.frame = newFrame;
                             _roundRectView.frame = CGRectMake(0, 0, newFrame.size.width, newFrame.size.height);
                             self.alpha = 1.0;
                         }
                         completion:^(BOOL finished) {
                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * 1e9), dispatch_get_main_queue(),^{
                                 [self setShow:NO withDuration:0 affectCounter:YES];
                             });
                         }];
    } else {
        NSLog(@"NO");
        if (affect) {
            showCounter--;
            if (showCounter < 0) {
                showCounter = 0;
            }
            if (showCounter == 0) {
                [UIView animateWithDuration:0.5
                                      delay:0.0
                                    options:UIViewAnimationOptionAllowUserInteraction
                                 animations:^{
                                     self.alpha = 0.0;
                                 }
                                 completion:^(BOOL finished) {
                                     self.hidden = YES;
                                 }];
            }
        } else {
            [UIView animateWithDuration:0.5
                                  delay:0.0
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 self.alpha = 0.0;
                             }
                             completion:^(BOOL finished) {
                                 self.hidden = YES;
                             }];
        }
    }
}

- (void)setText:(NSString *)text {
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:self.bounds];
        [_textView setBackgroundColor:[UIColor clearColor]];
        [_textView setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:17]];
        [_textView setTextAlignment:NSTextAlignmentNatural];
        [_textView setTextColor:_borderColor];
        [_textView setTextContainerInset:UIEdgeInsetsMake(10, 10, 10, 10)];
        [_textView setScrollEnabled:NO];
    }
    if ([text length] > 0) {
        [self addSubview:_textView];
    } else {
        [_textView removeFromSuperview];
        return;
    }
    _textView.frame = [self calculateNewFrameWithText:text textView:_textView];
    
    // Animation
    showCounter++;
    self.hidden = NO;
    CGRect newFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, _textView.frame.size.width, _textView.frame.size.height);
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         _textView.alpha = 0;
                     }
                     completion:nil];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.frame = newFrame;
                         _roundRectView.frame = CGRectMake(0, 0, newFrame.size.width, newFrame.size.height);
                         self.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [_textView setText:text];
                         [UIView animateWithDuration:0.3
                                               delay:0.0
                                             options:UIViewAnimationOptionAllowUserInteraction
                                          animations:^{
                                              _textView.alpha = 1.0;
                                          }
                                          completion:nil];
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * 1e9), dispatch_get_main_queue(),^{
                             [self setShow:NO withDuration:0 affectCounter:YES];
                         });
                     }];
}

#pragma mark - Helper methods

- (void)setRoundedRect:(CALayer *)layer borderColor:(UIColor *)borderColor {
//    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
//    [borderColor getRed:&red green:&green blue:&blue alpha:&alpha];
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(ctx, 1);
//    CGContextSetRGBStrokeColor(ctx, red, green, blue, alpha);
//    [[UIColor clearColor] getRed:&red
//                           green:&green
//                            blue:&blue
//                           alpha:&alpha];
//    CGContextSetRGBFillColor(ctx, red, green, blue, alpha);
    
    UIBezierPath *roundRectPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:4.0];
    CAShapeLayer *rounderRectLayer = [[CAShapeLayer alloc] init];
    [rounderRectLayer setPath:roundRectPath.CGPath];
    [rounderRectLayer setBackgroundColor:nil];
    [layer addSublayer:rounderRectLayer];
}

- (UIImage *)imageWithBorderColor:(UIColor *)borderColor size:(CGSize)size pinDirection:(PinDirection)direction{
    
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
    [borderColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 1);
    CGContextSetRGBStrokeColor(ctx, red, green, blue, alpha);
    UIBezierPath *path = [[UIBezierPath alloc] init];
    path.lineWidth = lineWidth;
    switch (direction) {
        case PinAbove: {
            [path moveToPoint:CGPointMake(0, size.height)];
            [path addLineToPoint:CGPointMake(size.width / 2, 0)];
            [path addLineToPoint:CGPointMake(size.width, size.height)];
//            [path closePath];
            break;
        }
        case PinBelow: {
            [path moveToPoint:CGPointMake(0, 0)];
            [path addLineToPoint:CGPointMake(size.width / 2, size.height)];
            [path addLineToPoint:CGPointMake(size.width, 0)];
//            [path closePath];
            break;
        }
        case PinLeft: {
            [path moveToPoint:CGPointMake(size.width, 0)];
            [path addLineToPoint:CGPointMake(0, size.height / 2)];
            [path addLineToPoint:CGPointMake(size.width, size.height)];
//            [path closePath];
            break;
        }
        case PinRight: {
            [path moveToPoint:CGPointMake(0, 0)];
            [path addLineToPoint:CGPointMake(size.width, size.height / 2)];
            [path addLineToPoint:CGPointMake(0, size.height)];
//            [path closePath];
            break;
        }
        default:
            break;
    }
    [path stroke];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (CGRect)calculateNewFrameWithText:(NSString *)string textView:(UITextView *)textView {
    NSString *originalText = textView.text;
    
    [textView setText:string];
    
    CGFloat fixedWidth = _textView.frame.size.width;
    CGSize newSize = [_textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = _textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    
    [textView setText:originalText];
    return newFrame;
}
@end
