//
//  TTHRMainScrollView.h
//  Taptap Heart Rate
//
//  Created by Zhang Honghao on 6/15/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TTHRMainScrollView;

typedef enum {
    Screen1_ = 100,
    Screen0,
    Screen1,
} Screen;

@protocol TTHRMainScrollViewDelegate <NSObject>

- (BOOL)scrollView:(UIScrollView *)scrollView shouldMoveToScreen:(Screen)screen;

@optional
- (void)scrollView:(UIScrollView *)scrollView willMoveToScreen:(Screen)screen;
- (void)scrollView:(UIScrollView *)scrollView didMoveToScreen:(Screen)screen;

@end

@interface TTHRMainScrollView : UIScrollView

@property (nonatomic, weak) id <TTHRMainScrollViewDelegate> screenDelegate;

- (void)setCurrentScreen:(Screen)screen;

- (void)setScreen1_Offset:(CGFloat)offset1_
            screen0Offset:(CGFloat)offset0
            screen1Offset:(CGFloat)offset1;

- (void)setScreen1_Width:(CGFloat)width1_
            screen0Width:(CGFloat)width0
            screen1Width:(CGFloat)width1;

- (void)moveToScreen:(Screen)sc;

@end
