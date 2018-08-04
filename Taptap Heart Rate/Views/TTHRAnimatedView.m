//
//  TTHRAnimatedView.m
//  Taptap Heart Rate
//
//  Created by Zhang Honghao on 6/25/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TTHRAnimatedView.h"

@implementation TTHRAnimatedView {
    UILabel *_titleLabel;
    BOOL _isBlinking;
    CGFloat _initAlpha;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        @throw [NSException exceptionWithName:NSInternalInconsistencyException
//                                       reason:@"-initWithFrame: is not a valid initializer, use -initWithFrame: parentView: instead"
//                                     userInfo:nil];
//        [self setBackgroundColor:[UIColor blueColor]];
        [self setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.24]];
        self.layer.cornerRadius = 3.0;
    }
    return self;
}

- (void)setText:(NSString *)title {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [_titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.83]];
//        [_titleLabel setBackgroundColor:[UIColor brownColor]];
    }
    if ([title length] == 0) {
        [_titleLabel removeFromSuperview];
        [self dismiss];
        return;
    }
    [_titleLabel setText:title];
//    
//    NSLog(@"%@", NSStringFromCGRect(self.frame));
//    NSLog(@"%@", NSStringFromCGRect(_titleLabel.frame));
    
    // Text field changes
    CGFloat fixedHeight = _titleLabel.frame.size.height;
    CGSize newSize = [_titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, fixedHeight)];
    CGRect newFrame = _titleLabel.frame;
    newFrame.size = CGSizeMake(newSize.width, fmaxf(newSize.height, fixedHeight));
    
    // Change super view
    CGRect superViewFrame = self.frame;
    superViewFrame.size.width = newFrame.size.width + 12;
    superViewFrame.origin.x += (self.frame.size.width - superViewFrame.size.width) / 2;
    
    // Center text field
    newFrame.origin.x = (superViewFrame.size.width - newFrame.size.width) / 2;
    
    [_titleLabel setFrame:newFrame];
    [self setFrame:superViewFrame];
    
    [self addSubview:_titleLabel];
    
    [self show];
}

//+ (TTHRAnimatedView *)sharedView {
//    static dispatch_once_t once;
//    static TTHRAnimatedView *sharedView;
//    dispatch_once(&once, ^ {
//        sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    });
//    return sharedView;
//}

//- (void)show {
//    [self setBackgroundColor:[UIColor blueColor]];
//    NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
//    NSLog(@"%d", [[frontToBackWindows allObjects] count]);
//    for (UIWindow *window in frontToBackWindows) {
//        NSLog(@"%@", NSStringFromCGRect(window.bounds));
//        if (window.windowLevel == UIWindowLevelNormal) {
//            NSLog(@"asd");
//            [window addSubview:self];
//            break;
//        }
//    }
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)show {
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.alpha = 1.0;
                     }
                     completion:nil];
}

- (void)dismiss {
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.alpha = 0.0;
                     }
                     completion:nil];
}

- (void)setBlink:(BOOL)toBlink
{
    void (^blinkAnimationBlock)(void) = ^{
        
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.alpha = 0.4;
                         } completion:NULL];
        
        [UIView animateWithDuration:0.8
                              delay:0.0
                            options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self setAlpha:1.0];
                         }
                         completion:NULL];
    };
    void (^restoreAnimationBlock)(void) = ^{
        [self.layer removeAllAnimations];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self setAlpha: self->_initAlpha];
                         } completion:NULL];
    };
    if (toBlink) {
        if (_isBlinking == NO) {
            _initAlpha = self.alpha;
        }
        _isBlinking = toBlink;
        blinkAnimationBlock();
    } else {
        _isBlinking = toBlink;
        restoreAnimationBlock();
    }
}

@end
