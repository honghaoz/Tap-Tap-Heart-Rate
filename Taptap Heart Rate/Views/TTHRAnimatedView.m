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
    }
    if ([title length] == 0) {
        [_titleLabel removeFromSuperview];
        [self dismiss];
        return;
    }
    [_titleLabel setText:title];
    [_titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.83]];
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
//    LogMethod;
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

@end
