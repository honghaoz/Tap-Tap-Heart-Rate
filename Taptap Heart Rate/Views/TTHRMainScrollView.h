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
    Screen0 = 100,
    Screen1,
    Screen2
} Screen;

@protocol TTHRMainScrollViewDelegate <NSObject>

- (BOOL)scrollView:(UIScrollView *)scrollView shouldMoveToScreen:(Screen)screen;

@optional
- (void)scrollView:(UIScrollView *)scrollView willMoveToScreen:(Screen)screen;
- (void)scrollView:(UIScrollView *)scrollView didMoveToScreen:(Screen)screen;

@end

@interface TTHRMainScrollView : UIScrollView

@property (nonatomic, weak) id <TTHRMainScrollViewDelegate> screenDelegate;

- (void)moveToScreen:(Screen)sc;

@end
