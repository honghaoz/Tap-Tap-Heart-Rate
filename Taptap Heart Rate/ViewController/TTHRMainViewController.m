//
//  TTHRMainViewController.m
//  Taptap Heart Rate
//
//  Created by Zhang Honghao on 6/10/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TTHRMainViewController.h"
#import "TTHRTapButton.h"
#import "TTHRMainScrollView.h"
#import "TTHRAnimatedView.h"
#import "TTHRHintView.h"
#import "TTHRHeartIndicatorView.h"
#import "TTHRUser.h"

#import <GoogleMobileAds/GoogleMobileAds.h>
@import FirebaseAnalytics;

// Define max and min heart rate
#define MAX_HEART_RATE 229
#define MIN_HEART_RATE 32

// Define hintView positions
#define HINT_0 0.13
#define HINT_1 0.496
#define HINT_2 0.85

// Define states
typedef enum {
    TrackOngoing = 100,
    TrackPause,
    TrackStop
} TrackState;

@interface TTHRMainViewController () <TTHRMainScrollViewDelegate, UITextFieldDelegate, GADBannerViewDelegate>

// Preference data
@property (nonatomic, assign) NSInteger countModeNumber;
@property (nonatomic, assign) Mode currentMode;
@property (nonatomic, weak) TTHRUser *user;

// Tracking data
@property (nonatomic, assign) TrackState currentState;
@property (nonatomic, assign) NSInteger heartRate;
@property (nonatomic, assign) NSInteger beatNumber;
@property (nonatomic, strong) NSNumber* startTime;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) NSMutableArray* tappedTimes;

// Views
@property (nonatomic, strong) UIColor* backgroundColor;
@property (nonatomic, strong) UIColor* buttonColor;
@property (nonatomic, assign) CGSize mainScreenSize;
@property (nonatomic, strong) TTHRMainScrollView* mainScrollView;

// Screen 0
@property (nonatomic, strong) TTHRAnimatedView* indicator;
@property (nonatomic, strong) UILabel* heartRateTilteLabel;
@property (nonatomic, strong) UILabel* heartRateLabel;

@property (nonatomic, strong) UILabel* beatLabel;
@property (nonatomic, strong) UILabel* timerLabel;
@property (nonatomic, strong) UILabel* offsetLabel;
@property (nonatomic, strong) TTHRHeartIndicatorView* heartIndicator;

@property (nonatomic, strong) TTHRTapButton* tapButton;
@property (nonatomic, strong) TTHRTapButton* resetButton;

// Screen 1
@property (nonatomic, assign) BOOL screen1IsLoaded;
@property (nonatomic, strong) UILabel* segmentLabel;
@property (nonatomic, strong) TTHRTapButton* segmentHelpButton;
@property (nonatomic, strong) UISegmentedControl* modeSegmentControl;
@property (nonatomic, strong) TTHRHintView* hintView;

@property (nonatomic, strong) UILabel* personalLabel;
@property (nonatomic, strong) UILabel* ageLabel;
@property (nonatomic, strong) UITextField* ageField;
@property (nonatomic, assign) CGSize keyboardSize;

@property (nonatomic, strong) UILabel* genderLabel;
@property (nonatomic, strong) UISegmentedControl* genderSegmentedControl;

@property (nonatomic, strong) UILabel *maxHRTitleLabel;
@property (nonatomic, strong) UILabel *maxHRLable;

@property (nonatomic, strong) UILabel *designLabel;

// Screen 1_ (Screen -1)
@property (nonatomic, assign) BOOL screen1_IsLoaded;

@property (nonatomic, strong) GADBannerView *adBannerView;
@property (nonatomic, assign) BOOL bannerIsVisible;

@end

@implementation TTHRMainViewController

- (id)init
{
    self = [super init];
    if (self) {
        _backgroundColor = [UIColor colorWithRed:0.73 green:0.03 blue:0.10 alpha:1];
        //[UIColor colorWithRed:0.8 green:0.1 blue:0.16 alpha:1];//[UIColor colorWithRed:0.95 green:0.3 blue:0.22 alpha:1];
        _buttonColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.83];

        _currentMode = FiveMode;
        if (_currentMode == FiveMode) {
            _countModeNumber = 5;
        } else if (_currentMode == TenMode) {
            _countModeNumber = 10;
        } else {
            _countModeNumber = 0;
        }

        _currentState = TrackStop;
        _beatNumber  = 0;
        _heartRate   = 0;
        _tappedTimes = nil;
    }
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    [self.view setBackgroundColor:_backgroundColor];

    // Initialize view properties
    CGFloat maxScreenHeight = 770;
    CGFloat topInset =  MAX([UIScreen mainScreen].bounds.size.height - maxScreenHeight, 0);
    _mainScreenSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,
                                 [UIScreen mainScreen].bounds.size.height - topInset);
    _mainScrollView = [[TTHRMainScrollView alloc] initWithFrame:CGRectMake(0,
                                                                           topInset,
                                                                           [UIScreen mainScreen].bounds.size.width,
                                                                           [UIScreen mainScreen].bounds.size.height - topInset)];

    CGSize bigSize = _mainScreenSize;
    bigSize.width *= 2.4;
    
    [_mainScrollView setContentSize:bigSize];
    [_mainScrollView setScreen1_Offset:0 screen0Offset:0.7 * _mainScreenSize.width screen1Offset:1.4 * _mainScreenSize.width];
    [_mainScrollView setCurrentScreen:Screen0];
    [_mainScrollView setScreen1_Width:0.7 * _mainScreenSize.width screen0Width:_mainScreenSize.width screen1Width:0.7 * _mainScreenSize.width];
    
    [_mainScrollView setPagingEnabled:YES];
    [_mainScrollView setBackgroundColor:_backgroundColor];
    [_mainScrollView setOpaque:YES];
    [_mainScrollView setMultipleTouchEnabled:NO];
    [_mainScrollView setBounces:NO];
    [_mainScrollView setShowsHorizontalScrollIndicator:NO];
    [_mainScrollView setShowsVerticalScrollIndicator:NO];
    [_mainScrollView setCanCancelContentTouches:YES];
    [_mainScrollView setDelaysContentTouches:NO];
    [_mainScrollView setScrollEnabled:NO];
    [_mainScrollView setScreenDelegate:self];
    [self.view addSubview:_mainScrollView];
    
    [self loadScreen0];
    _screen1IsLoaded = NO;
}

- (void)loadScreen0 {
    CGFloat offsetX = 0.7 * _mainScreenSize.width;
    
    // Heart Rate Label
    CGFloat heartRateLabelHeight = 100;
    CGFloat heartRateLabelWidth  = 300;
    CGFloat heartRateLabelX      = offsetX + (_mainScreenSize.width - heartRateLabelWidth) / 2;
    CGFloat heartRateLabelY      = 0;
    
    // On 4inch Screen, move label down
    if (_mainScreenSize.height > 480) {
        heartRateLabelY = 65;
    } else {
        heartRateLabelY = 55;
    }
    CGRect heartRateLabelFrame = CGRectMake(heartRateLabelX, heartRateLabelY, heartRateLabelWidth, heartRateLabelHeight);
    _heartRateLabel = [[UILabel alloc] initWithFrame:heartRateLabelFrame];
    [_heartRateLabel setText:_heartRate == 0 ? @"---" : [NSString stringWithFormat:@"%ld", (long)_heartRate]];
    [_heartRateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:130]];
    [_heartRateLabel setTextAlignment:NSTextAlignmentCenter];
    [_heartRateLabel setTextColor:_buttonColor];
    
    // Heart Rate Title Label
    CGFloat heartRateTitleLabelHeight = 30;
    CGFloat heartRateTitleLabelWidth  = 43;
    CGFloat heartRateTitleLabelX      = heartRateLabelX - heartRateTitleLabelWidth + 53;
    CGFloat heartRateTitleLabelY      = heartRateLabelY - heartRateTitleLabelHeight;
    CGRect heartRateTitleLabelFrame = CGRectMake(heartRateTitleLabelX, heartRateTitleLabelY, heartRateTitleLabelWidth, heartRateTitleLabelHeight);
    _heartRateTilteLabel = [[UILabel alloc] initWithFrame:heartRateTitleLabelFrame];
    [_heartRateTilteLabel setText:@"BPM:"];
    [_heartRateTilteLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]];
    [_heartRateTilteLabel setTextAlignment:NSTextAlignmentLeft];
    [_heartRateTilteLabel setTextColor:_buttonColor];
    
    // Animated View
    CGFloat indicatorWidth  = 80;
    CGFloat indicatorHeight = 20;
    CGFloat indicatorX      = offsetX + (_mainScreenSize.width - indicatorWidth) / 2;
    CGFloat indicatorY      = (heartRateTitleLabelY + heartRateTitleLabelHeight / 2) - indicatorHeight / 2 + 1;
    CGRect indicatorFrame = CGRectMake(indicatorX, indicatorY, indicatorWidth, indicatorHeight);
    _indicator = [[TTHRAnimatedView alloc] initWithFrame:indicatorFrame];
    [_indicator setAlpha:0.0];
    
    CGFloat heartIndicatorY      = heartRateTitleLabelY;
    CGFloat heartIndicatorWidth  = 0;// will update later
    CGFloat heartIndicatorHeight = 0;// will update later
    CGFloat heartIndicatorX      = offsetX + _mainScreenSize.width - (heartRateTitleLabelX - offsetX) - heartIndicatorWidth;
    CGRect heartIndicatorFrame = CGRectMake(heartIndicatorX, heartIndicatorY, heartIndicatorWidth, heartIndicatorHeight);
    _heartIndicator = [[TTHRHeartIndicatorView alloc] initWithFrame:heartIndicatorFrame color:_buttonColor imageNamed:@"Heart.png"];
    
    heartIndicatorWidth  = _heartIndicator.frame.size.width;
    heartIndicatorHeight = _heartIndicator.frame.size.height;
    heartIndicatorY      = heartRateTitleLabelY + 1 / 2 * heartRateTitleLabelHeight - 1 / 2 * heartIndicatorHeight + 5;
    heartIndicatorX      = offsetX + _mainScreenSize.width - (heartRateTitleLabelX - offsetX) - heartIndicatorWidth + 3;
    heartIndicatorFrame = CGRectMake(heartIndicatorX, heartIndicatorY, heartIndicatorWidth, heartIndicatorHeight);
    [_heartIndicator setFrame:heartIndicatorFrame];
    
    // Beat Label
    CGFloat beatLabelHeight = 30;
    CGFloat beatLabelWidth  = 79;
    CGFloat beatLabelX      = heartRateTitleLabelX;
    CGFloat beatLabelY      = heartRateLabelY + heartRateLabelHeight + 10;
    CGRect beatLabelFrame = CGRectMake(beatLabelX, beatLabelY, beatLabelWidth, beatLabelHeight);
    _beatLabel = [[UILabel alloc] initWithFrame:beatLabelFrame];
    [_beatLabel setText:[NSString stringWithFormat:@"Beats: %ld", (long)_beatNumber]];
    [_beatLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:15]];
    [_beatLabel setTextAlignment:NSTextAlignmentLeft];
    [_beatLabel setTextColor:_buttonColor];
    
    // Timer Label
    CGFloat timerLabelHeight = 30;
    CGFloat timerLabelWidth  = 97;
    CGFloat timerLabelX      = beatLabelX + beatLabelWidth + 2;
    CGFloat timerLabelY      = beatLabelY;
    CGRect timerLabelFrame = CGRectMake(timerLabelX, timerLabelY, timerLabelWidth, timerLabelHeight);
    _timerLabel = [[UILabel alloc] initWithFrame:timerLabelFrame];
    [_timerLabel setText:@"Time: 00:00.00"];
    [_timerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:15]];
    [_timerLabel setTextAlignment:NSTextAlignmentLeft];
    [_timerLabel setTextColor:_buttonColor];
    
    // Offset Label
    CGFloat offsetLabelHeight = 30;
    CGFloat offsetLabelWidth  = 100;
    CGFloat offsetLabelX      = timerLabelX + timerLabelWidth + 10;
    CGFloat offsetLabelY      = timerLabelY;
    CGRect offsetLabelFrame = CGRectMake(offsetLabelX, offsetLabelY, offsetLabelWidth, offsetLabelHeight);
    _offsetLabel = [[UILabel alloc] initWithFrame:offsetLabelFrame];
    [_offsetLabel setText:@"Offset: +00.00"];
    [_offsetLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:15]];
    [_offsetLabel setTextAlignment:NSTextAlignmentLeft];
    [_offsetLabel setTextColor:_buttonColor];
    
    // Tap Button
    CGFloat tapButtonHeight = 230;
    CGFloat tapButtonWidth  = 230;
    CGFloat tapButtonX      = offsetX + (_mainScreenSize.width - tapButtonWidth) / 2;
    CGFloat tapButtonY      = 0;
    // On 4inch Screen, move label up
    if (_mainScreenSize.height > 480) {
        tapButtonY = _mainScreenSize.height - tapButtonHeight - 50;
    } else {
        tapButtonY = _mainScreenSize.height - tapButtonHeight - 30;
    }
    CGRect tapButtonFrame = CGRectMake(tapButtonX, tapButtonY, tapButtonWidth, tapButtonHeight);
    _tapButton = [[TTHRTapButton alloc] initWithFrame:tapButtonFrame];
    [_tapButton setTitle:@"Tap" forState:UIControlStateNormal];
    [_tapButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:46]];
    [_tapButton setTitleColor:_backgroundColor forState:UIControlStateNormal];
    [_tapButton setTitleColor:_backgroundColor forState:UIControlStateHighlighted];
    _tapButton.backgroundColor = [UIColor clearColor];
    [_tapButton addTarget:self action:@selector(tapButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    _tapButton.adjustsImageWhenDisabled = NO;
    [_tapButton.titleLabel setNumberOfLines:0];
    
    // Reset Button
    CGFloat resetButtonHeight = 70;
    CGFloat resetButtonWidth  = 70;
    CGFloat resetButtonX      = tapButtonX + tapButtonWidth - 25;
    CGFloat resetButtonY      = tapButtonY + tapButtonHeight - resetButtonHeight + 6;
    CGRect resetButtonFrame = CGRectMake(resetButtonX, resetButtonY, resetButtonWidth, resetButtonHeight);
    _resetButton = [[TTHRTapButton alloc] initWithFrame:resetButtonFrame circleWidth:0 buttonColor:[self dimColor:_buttonColor with:0.05] circleColor:nil];
    [_resetButton setTitle:@"Reset" forState:UIControlStateNormal];
    [_resetButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    [_resetButton setTitleColor:_backgroundColor forState:UIControlStateNormal];
    [_resetButton addTarget:self action:@selector(resetButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    _resetButton.adjustsImageWhenDisabled = NO;
    
    [_mainScrollView addSubview:_heartRateTilteLabel];
    [_mainScrollView addSubview:_heartRateLabel];
    [_mainScrollView addSubview:_indicator];
    
    [_mainScrollView addSubview:_heartIndicator];
    [_mainScrollView addSubview:_beatLabel];
    [_mainScrollView addSubview:_timerLabel];
    [_mainScrollView addSubview:_offsetLabel];
    
    [_mainScrollView addSubview:_tapButton];
    [_mainScrollView addSubview:_resetButton];
}

- (void)loadScreen1 {
    if (_screen1IsLoaded)
        return;
    CGFloat offsetX = _mainScreenSize.width * 1.7;
    CGFloat heartRateTitleLabelY = _heartRateTilteLabel.frame.origin.y;
    
    // SegmentLabel
    CGFloat segmentLabelHeight = 30;
    CGFloat segmentLabelWidth  = 176;
    CGFloat segmentLabelX      = offsetX + (_mainScrollView.contentSize.width - offsetX - segmentLabelWidth) / 2;
    CGFloat segmentLabelY      = heartRateTitleLabelY;
    CGRect segmentLabelFrame = CGRectMake(segmentLabelX, segmentLabelY, segmentLabelWidth, segmentLabelHeight);
    _segmentLabel = [[UILabel alloc] initWithFrame:segmentLabelFrame];
    [_segmentLabel setText:@"Choose Measure Mode"];
    [_segmentLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]];
    [_segmentLabel setTextAlignment:NSTextAlignmentCenter];
    [_segmentLabel setTextColor:_buttonColor];
    
    // ModeSegment help button
    CGFloat segmentHelpX      = segmentLabelX + segmentLabelWidth - 8;
    CGFloat segmentHelpWidth  = segmentLabelHeight + 5;
    CGFloat segmentHelpHeight = segmentLabelHeight + 5;
    CGFloat segmentHelpY      = segmentLabelY + 1 / 2 * segmentLabelHeight - 1 / 2 * segmentHelpHeight - 2;
    CGRect segmentHelpFrame = CGRectMake(segmentHelpX, segmentHelpY, segmentHelpWidth, segmentHelpHeight);
    _segmentHelpButton = [[TTHRTapButton alloc] initWithFrame:segmentHelpFrame circleWidth:0.0 buttonColor:_buttonColor circleColor:nil];
    [_segmentHelpButton setTitle:@"?" forState:UIControlStateNormal];
    [_segmentHelpButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
    [_segmentHelpButton setTitleColor:_backgroundColor forState:UIControlStateNormal];
    [_segmentHelpButton addTarget:self action:@selector(segmentHelpButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    _segmentHelpButton.adjustsImageWhenDisabled = NO;
    [_segmentHelpButton enlargeShouldTapRaidus:5];
    [_segmentHelpButton setShouldPassTouch:NO];
    
    // ModeSegmentControl
    CGFloat modeSegmentHeight = 70;
    CGFloat modeSegmentWidth  = 170;
    CGFloat modeSegmentX      = 10;
    CGFloat modeSegmentY      = segmentLabelY + segmentLabelHeight + 7;
    _modeSegmentControl = [[UISegmentedControl alloc] initWithItems:@[ @"5", @"10", @"Tap" ]];
    modeSegmentHeight = _modeSegmentControl.frame.size.height;
    modeSegmentX = offsetX + (_mainScrollView.contentSize.width - offsetX - modeSegmentWidth) / 2;
    CGRect segmentFrame = CGRectMake(modeSegmentX, modeSegmentY, modeSegmentWidth, modeSegmentHeight);
    _modeSegmentControl.frame = segmentFrame;
    [_modeSegmentControl setTintColor:_buttonColor];
    //    [_modeSegmentControl setSelectedSegmentIndex:2];
    [_modeSegmentControl setTitleTextAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:15] } forState:UIControlStateNormal];
    [_modeSegmentControl addTarget:self action:@selector(segmentTapped:) forControlEvents:UIControlEventValueChanged];
    
    // Hint view
    CGFloat hintViewX      = modeSegmentX;
    CGFloat hintViewY      = modeSegmentY + modeSegmentHeight + 13;
    CGFloat hintViewWidth  = modeSegmentWidth;
    CGFloat hintViewHeight = 150;
    CGRect hintViewFrame = CGRectMake(hintViewX, hintViewY, hintViewWidth, hintViewHeight);
    _hintView = [[TTHRHintView alloc] initWithFrame:hintViewFrame borderColor:_buttonColor borderWidth:1.0 backgroundColor:_backgroundColor pinDirection:PinAbove pinPosition:HINT_2 triangleSize:CGSizeMake(15, 14)];
    [_hintView setAlpha:0];
    [_hintView setShow:NO withDuration:0 affectCounter:NO];
    
    // Personal label
    CGFloat personalLabelHeight = 30;
    CGFloat personalLabelWidth  = 200;
    CGFloat personalLabelX      = offsetX + (_mainScrollView.contentSize.width - offsetX - personalLabelWidth) / 2;
    CGFloat personalLabelY      = modeSegmentY + modeSegmentHeight + 37;
    CGRect personalLabelFrame = CGRectMake(personalLabelX, personalLabelY, personalLabelWidth, personalLabelHeight);
    _personalLabel = [[UILabel alloc] initWithFrame:personalLabelFrame];
    [_personalLabel setText:@"Personal Information"];
    [_personalLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]];
    [_personalLabel setTextAlignment:NSTextAlignmentCenter];
    [_personalLabel setTextColor:_buttonColor];
    
    // AgeLabel
    CGFloat ageLabelX      = modeSegmentX;
    CGFloat ageLabelY      = personalLabelY + personalLabelHeight + 5;
    CGFloat ageLabelWidth  = 60;
    CGFloat ageLabelHeight = modeSegmentHeight;
    CGRect ageLabelFrame = CGRectMake(ageLabelX, ageLabelY, ageLabelWidth, ageLabelHeight);
    _ageLabel = [[UILabel alloc] initWithFrame:ageLabelFrame];
    [_ageLabel setText:@"Age"];
    [_ageLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:17]];
    //    [_ageLabel sizeToFit];
    [_ageLabel setTextAlignment:NSTextAlignmentRight];
    [_ageLabel setTextColor:_buttonColor];
    
    // Gender Label
    CGFloat genderLabelX      = ageLabelX;
    CGFloat genderLabelY      = ageLabelY + ageLabelHeight + 5;
    CGFloat genderLabelWidth  = ageLabelWidth;
    CGFloat genderLabelHeight = modeSegmentHeight;
    CGRect genderLabelFrame = CGRectMake(genderLabelX, genderLabelY, genderLabelWidth, genderLabelHeight);
    _genderLabel = [[UILabel alloc] initWithFrame:genderLabelFrame];
    [_genderLabel setText:@"Gender"];
    [_genderLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:17]];
    //    [_genderLabel sizeToFit];
    [_genderLabel setTextAlignment:NSTextAlignmentRight];
    [_genderLabel setTextColor:_buttonColor];
    
    // Age Field
    CGFloat ageFieldX      = genderLabelX + genderLabelWidth + 10;
    CGFloat ageFieldY      = ageLabelY;
    CGFloat ageFieldWidth  = 43.0;
    CGFloat ageFieldHeight = modeSegmentHeight;
    CGRect ageFieldFrame = CGRectMake(ageFieldX, ageFieldY, ageFieldWidth, ageFieldHeight);
    _ageField = [[UITextField alloc] initWithFrame:ageFieldFrame];
    [_ageField setTextAlignment:NSTextAlignmentCenter];
    [_ageField setTextColor:_buttonColor];
    [_ageField setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]];
    //    [_ageField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"0-100" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:1.0 alpha:0.3], NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:17]}]];
    [_ageField setDelegate:self];
    [_ageField setKeyboardType:UIKeyboardTypeNumberPad];
    [_ageField setKeyboardAppearance:UIKeyboardAppearanceLight];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldResignFirstResponder:) name:@"DismissKeyboard" object:nil];
    _ageField.layer.borderColor  = [_buttonColor CGColor];
    _ageField.layer.borderWidth  = 1.0;
    _ageField.layer.cornerRadius = 4.0;
    //    [_ageField setBorderStyle:UITextBorderStyleRoundedRect];
    [_ageField setTintColor:_buttonColor];
    
    // Gender SegmentControl
    CGFloat genderSegmentedControlWidth  = 100;
    CGFloat genderSegmentedControlHeight = 70;
    CGFloat genderSegmentedControlX      = ageFieldX;
    CGFloat genderSegmentedControlY      = genderLabelY;
    _genderSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[ @"Male", @"Female" ]];
    genderSegmentedControlHeight = _genderSegmentedControl.frame.size.height;
    CGRect genderSegmentedControlFrame = CGRectMake(genderSegmentedControlX, genderSegmentedControlY, genderSegmentedControlWidth, genderSegmentedControlHeight);
    _genderSegmentedControl.frame = genderSegmentedControlFrame;
    [_genderSegmentedControl setTintColor:_buttonColor];
    [_genderSegmentedControl setWidth:43.0 forSegmentAtIndex:0];
    //    [_genderSegmentedControl setSelectedSegmentIndex:0];
    [_genderSegmentedControl setTitleTextAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:15] } forState:UIControlStateNormal];
    //    [_genderSegmentedControl setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:15]} forState:UIControlStateHighlighted];
    [_genderSegmentedControl addTarget:self action:@selector(genderSegmentedControlTapped:) forControlEvents:UIControlEventValueChanged];
    
    // Max Heart Rate Labels
    CGFloat maxHRTitleX = ageLabelX;
    CGFloat maxHRTitleY = genderLabelY + genderLabelHeight + 5;
    CGFloat maxHRTitleWidth = genderLabelWidth;
    CGFloat maxHRTitleHeight = modeSegmentHeight;
    CGRect maxHRTitleFrame = CGRectMake(maxHRTitleX, maxHRTitleY, maxHRTitleWidth, maxHRTitleHeight);
    _maxHRTitleLabel = [[UILabel alloc] initWithFrame:maxHRTitleFrame];
    [_maxHRTitleLabel setText:@"Max HR"];
    [_maxHRTitleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:16]];
    //    [_genderLabel sizeToFit];
    [_maxHRTitleLabel setTextAlignment:NSTextAlignmentRight];
    [_maxHRTitleLabel setTextColor:_buttonColor];
    
    CGFloat maxHRLabelX = genderSegmentedControlX;
    CGFloat maxHRLabelY = maxHRTitleY;
    CGFloat maxHRLabelWidth = genderSegmentedControlWidth;
    CGFloat maxHRLabelHeight = maxHRTitleHeight;
    CGRect maxHRLabelFrame = CGRectMake(maxHRLabelX, maxHRLabelY, maxHRLabelWidth, maxHRLabelHeight);
    _maxHRLable = [[UILabel alloc] initWithFrame:maxHRLabelFrame];
    [_maxHRLable setText:[NSString stringWithFormat:@" %ld", (long)[TTHRUser sharedUser].maxHR]];
    [_maxHRLable setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
    [_maxHRLable setTextAlignment:NSTextAlignmentLeft];
    [_maxHRLable setTextColor:_buttonColor];
    
    
    // CopyLabel
    CGFloat designX      = 0;
    CGFloat designY      = 0;
    CGFloat designWidth  = 0;
    CGFloat designHeight = 10;
    CGRect designFrame   = CGRectMake(designX, designY, designWidth, designHeight);
    _designLabel = [[UILabel alloc] initWithFrame:designFrame];
    [_designLabel setText:@"Designed by HonghaoZ"];
    [_designLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
    [_designLabel setTextAlignment:NSTextAlignmentCenter];
    [_designLabel setTextColor:_buttonColor];
    [_designLabel setAlpha:0.75];
    [_designLabel sizeToFit];
    designWidth  = _designLabel.frame.size.width;
    designHeight = _designLabel.frame.size.height;
    designX      = offsetX + (_mainScrollView.contentSize.width - offsetX - designWidth) / 2;
	designY      = (_mainScreenSize.height - (_bannerIsVisible ? 50 : 0)) - designHeight - 10;
    designFrame  = CGRectMake(designX, designY, designWidth, designHeight);
    [_designLabel setFrame:designFrame];
    
    [_mainScrollView addSubview:_segmentLabel];
    [_mainScrollView addSubview:_segmentHelpButton];
    [_mainScrollView addSubview:_modeSegmentControl];
    
    [_mainScrollView addSubview:_personalLabel];
    [_mainScrollView addSubview:_ageLabel];
    [_mainScrollView addSubview:_ageField];
    [_mainScrollView addSubview:_genderLabel];
    [_mainScrollView addSubview:_genderSegmentedControl];
    [_mainScrollView addSubview:_designLabel];
    [_mainScrollView addSubview:_maxHRTitleLabel];
    [_mainScrollView addSubview:_maxHRLable];
    
    [_mainScrollView addSubview:_hintView];
    
    // Update user's preference
    [_modeSegmentControl setSelectedSegmentIndex:_currentMode];
    [self segmentTapped:nil];
    
    if (_user.age > 0) {
        [_ageField setText:[NSString stringWithFormat:@"%ld", (long)_user.age]];
    }

    if (_user.gender == GenderMale) {
        [_genderSegmentedControl setSelectedSegmentIndex:0];
    } else if(_user.gender == GenderFemale) {
        [_genderSegmentedControl setSelectedSegmentIndex:1];
    }
    
    _screen1IsLoaded = YES;
}

- (void)loadScreen1_ {
    if (_screen1_IsLoaded)
        return;
    
    _screen1_IsLoaded = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _user = [TTHRUser sharedUser];
    [_user load];
    _currentMode = _user.choosedMode;
    _tappedTimes = [[NSMutableArray alloc] init];
    [self setNeedsStatusBarAppearanceUpdate];
	
    // Delay execution (iOS 8 Bugs?)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0001 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self resetButtonTapped:nil];
    });
    
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
    // Ad
    self.adBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    self.adBannerView.delegate = self;
    self.adBannerView.adUnitID = @"ca-app-pub-5080537428726834/8037535102";
    self.adBannerView.frame = CGRectMake(0, self.view.frame.size.height - 50, self.adBannerView.bounds.size.width, self.adBannerView.bounds.size.height);
    [self.view addSubview:self.adBannerView];
    self.adBannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[kGADSimulatorID];
    [self.adBannerView loadRequest:request];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - State switch

- (void)start
{
    // If before start is not ongoing, init timer
    // Else, don't init the timer again
    if (_currentState != TrackOngoing) {
        // Init timer
        NSRunLoop* runloop = [NSRunLoop currentRunLoop];
        _timer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
        [runloop addTimer:_timer forMode:NSRunLoopCommonModes];
        [runloop addTimer:_timer forMode:UITrackingRunLoopMode];
    }
    _currentState = TrackOngoing;
}

- (void)pause
{
    _currentState = TrackPause;
    // Stop the timer
    [_timer invalidate];
    _timer = nil;
}

- (void)stop
{
    _currentState = TrackStop;
    // Stop the timer
    [_timer invalidate];
    _timer = nil;
    // Clean data
    _startTime = nil;
    _beatNumber = 0;
    _heartRate = 0;
    [_tappedTimes removeAllObjects];
}

#pragma mark - Buttons selectors

- (void)tapButtonTapped:(id)sender
{
    _beatNumber++;
    NSNumber *tappedTime = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    [_tappedTimes addObject:tappedTime];
    
    switch (_currentMode) {
        case FiveMode:
        case TenMode: {
            switch (_currentState) {
                case TrackOngoing: {
                    [self pause];
                    [self updateLabels];
                    break;
                }
                case TrackPause: {
                    [self stop];
                    // Since stop will clean tapped time, need to add again
                    [_tappedTimes addObject:tappedTime];
                    [self start];
                    [self updateLabels];
                    break;
                }
                case TrackStop: {
                    [self start];
                    [self updateLabels];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case TapMode: {
            [self start];
            [self updateLabels];
            break;
        }
        default:
            break;
    }
}

- (void)resetButtonTapped:(id)sender
{
    [self stop];
    [_tapButton setDimmed:NO];
    [self updateLabels];
}

- (void)segmentTapped:(id)sender
{
    [self textFieldResignFirstResponder:nil];
//    Mode choosedMode = FiveMode;
//    if ([sender isKindOfClass:[UISegmentedControl class]]) {
//        choosedMode = ((UISegmentedControl *)sender).selectedSegmentIndex;
//    } else {
//        choosedMode = _currentMode;
//    }
    
    switch (_modeSegmentControl.selectedSegmentIndex) {
    case 0: {
        _currentMode = FiveMode;
        _countModeNumber = 5;
        [_hintView setText:[NSString stringWithFormat:@"After tapping the start button, count %ld beats, then tap again to end.\n\nInstructions: Tap start button, count 5... 4... 3... 2... 1... 0, at the moment '0', tap again to end.", (long)_countModeNumber]];
        [_hintView moveTriangleToPosition:HINT_0];
        break;
    }
    case 1: {
        _currentMode = TenMode;
        _countModeNumber = 10;
        [_hintView setText:[NSString stringWithFormat:@"After tapping the start button, count %ld beats, then tap again to end.\n\nInstructions: Tap start button, count 10 to 0, at the moment '0', tap again to end.", (long)_countModeNumber]];
        [_hintView moveTriangleToPosition:HINT_1];
        break;
    }
    case 2: {
        _currentMode = TapMode;
        [_hintView setText:@"Tap the button after each beat of the heart"];
        [_hintView moveTriangleToPosition:HINT_2];
        break;
    }
    default:
        break;
    }
//    if ([sender isKindOfClass:[UISegmentedControl class]]) {
//        _user.choosedMode = _currentMode;
//    }
    _user.choosedMode = _currentMode;
    [self resetButtonTapped:nil];
}

- (void)segmentHelpButtonTapped:(id)sender
{
    [self textFieldResignFirstResponder:nil];
    [_hintView setShow:YES withDuration:10 affectCounter:YES];
}

- (void)genderSegmentedControlTapped:(id)sender
{
    [self textFieldResignFirstResponder:nil];
    switch (_genderSegmentedControl.selectedSegmentIndex) {
        case 0: {
            [TTHRUser sharedUser].gender = GenderMale;
            break;
        }
        case 1: {
            [TTHRUser sharedUser].gender = GenderFemale;
            break;
        }
        default: {
            break;
        }
    }
    [self updateLabels];
    [_maxHRLable setText:[NSString stringWithFormat:@" %ld", (long)[TTHRUser sharedUser].maxHR]];
}

#pragma mark - UIViews update

- (void)updateLabels
{
    switch (_currentMode) {
    case FiveMode:
    case TenMode: {
        switch (_currentState) {
            case TrackOngoing: {
                [_indicator dismiss];
                if ([TTHRUser sharedUser].isCompleted) {
                    [_heartIndicator setAlpha:1.0 withDuration:0.0];
                } else {
                    [_heartIndicator setAlpha:0.0 withDuration:0.0];
                }
                [_heartIndicator setBlink:YES];
//                [_heartIndicator setPercent:0.0 withDuration:0.5];
                
                [_heartRateLabel setText:@"---"];
                [_beatLabel setText:@"Beats: -"];
                [_offsetLabel setText:@"Offset: +00.00"];
                
                [_tapButton setTitle:@"Counting..." forState:UIControlStateNormal];
                [_tapButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:34]];
                [_tapButton setLabelBelowWithTitle:@"Tap to end" andColor:_backgroundColor];
                [_tapButton setDimmed:YES];
                break;
            }
            case TrackPause: {
                [_heartIndicator setBlink:NO];
                // Update heart rate
                NSNumber* firstTapTime = [_tappedTimes firstObject];
                NSNumber* lastTapTime = [_tappedTimes lastObject];
                double offset = [lastTapTime doubleValue] - [firstTapTime doubleValue];
                _heartRate = lround(60.0 / (offset / _countModeNumber));
                // Set heart indicator, indicator label
                [self updateHeartIndicators];
                
                [_heartRateLabel setText:[NSString stringWithFormat:@"%ld", (long)_heartRate]];
                
                [_beatLabel setText:[NSString stringWithFormat:@"Beats: %ld", (long)_countModeNumber]];
                [_offsetLabel setText:[NSString stringWithFormat:offset < 0 ? @"Offset: %06.2f" : @"Offset: +%05.2f", offset]];
                
                // Fixme!!!
                [_tapButton setTitle:@"Start" forState:UIControlStateNormal];
                [_tapButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:46]];
                [_tapButton setLabelBelowWithTitle:[NSString stringWithFormat:@"Count %ld beats", (long)_countModeNumber] andColor:_backgroundColor];
                [_tapButton setDimmed:NO];
                
                [self updateTimer];
                break;
            }
            case TrackStop: {
                [_heartIndicator setBlink:NO];
                [_indicator dismiss];
                [_heartIndicator setPercent:0.0 withDuration:0.7];
                
                [_heartRateLabel setText:@"---"];
                [_beatLabel setText:@"Beats: -"];
                [_offsetLabel setText:@"Offset: +00.00"];
                
                // Fixme!!!
                [_tapButton setTitle:@"Start" forState:UIControlStateNormal];
                [_tapButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:46]];
                [_tapButton setLabelBelowWithTitle:[NSString stringWithFormat:@"Count %ld beats", (long)_countModeNumber] andColor:_backgroundColor];
                [_tapButton setDimmed:NO];
                
                break;
            }
            default:
                // Never goes here
                break;
        }
        [_tapButton.labelBelow setNumberOfLines:1];
        [_tapButton setNeedsDisplay];
        break;
    }
    case TapMode: {
        if ([TTHRUser sharedUser].isCompleted) {
            [_heartIndicator setAlpha:1.0 withDuration:0.0];
        } else {
            [_heartIndicator setAlpha:0.0 withDuration:0.0];
        }
        switch (_currentState) {
            case TrackOngoing: {
//                [_heartIndicator setBlink:YES];
                [_tapButton setTitle:@"Tap" forState:UIControlStateNormal];
                [_tapButton setLabelBelowWithTitle:@"" andColor:_backgroundColor];
                break;
            }
            case TrackPause: {
//                break;
            }
            case TrackStop: {
                [_heartIndicator setPercent:0.0 withDuration:0.7];
//                [_heartIndicator setBlink:NO];
                
                [_tapButton setTitle:@"Tap" forState:UIControlStateNormal];
                [_tapButton setLabelBelowWithTitle:@"Tap after each beat" andColor:_backgroundColor];
                [_tapButton.labelBelow setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
                [_tapButton.labelBelow setNumberOfLines:2];
                break;
            }
            default:
                // Never goes here
                break;
        }
        
        [_beatLabel setText:[NSString stringWithFormat:@"Beats: %ld", (long)_beatNumber]];
        
        [_tapButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:46]];
        [_tapButton setNeedsDisplay];
        
        if (_startTime == nil) {
            [_timerLabel setText:@"Time: 00:00.00"];
        }
        if (_beatNumber < 3) {
            [_heartRateLabel setText:_heartRate == 0 ? @"---" : [NSString stringWithFormat:@"%ld", (long)_heartRate]];
            [_offsetLabel setText:@"Offset: +00.00"];
            [_indicator dismiss];
            [_heartIndicator setPercent:0.0 withDuration:1.0];
            return;
        }
        NSNumber* lastTapTime = [_tappedTimes lastObject];
        NSNumber* lastSecondTapTime = [_tappedTimes objectAtIndex:_beatNumber - 2];
        NSNumber* lastThirdTapTime = [_tappedTimes objectAtIndex:_beatNumber - 3];
        double offset1 = [lastSecondTapTime doubleValue] - [lastThirdTapTime doubleValue];
        double offset2 = [lastTapTime doubleValue] - [lastSecondTapTime doubleValue];
        double offset = offset2 - offset1;
        [_offsetLabel setText:[NSString stringWithFormat:offset < 0 ? @"Offset: %06.2f" : @"Offset: +%05.2f", offset]];

        //double averageOffset = (offset1 + offset2) / 2;

        double totalOffset = [[_tappedTimes lastObject] doubleValue] - [[_tappedTimes firstObject] doubleValue];
        double averageOffset = totalOffset / (_beatNumber - 1);
        _heartRate = 60 / averageOffset;
        [_heartRateLabel setText:[NSString stringWithFormat:@"%ld", (long)_heartRate]];
        // Set heart indicator, indicator label
        [self updateHeartIndicators];
        break;
    }
    default:
        // Never goes here
        break;
    }
    if (_startTime == nil) {
        [_timerLabel setText:@"Time: 00:00.00"];
    }
}

- (void)updateHeartIndicators
{
    // Set heart indicator
    float percent = 0;
    HRCondition condition = HRUnknown;
    [[TTHRUser sharedUser] getHRCondition:&condition HRPercent:&percent heartRate:_heartRate];
    if (condition != HRUnknown) {
        [_heartIndicator setPercent:percent < 0.2 ? 0.2 : percent withDuration:1.0];
    }

    if (_heartRate > MAX_HEART_RATE) {
        [_indicator setText:@"Too High"];
        [_indicator setBlink:YES];
    } else if (_heartRate < MIN_HEART_RATE) {
        [_indicator setText:@"Too Low"];
        [_indicator setBlink:YES];
    } else {
        switch (condition) {
        case HRUnknown:
            [_indicator dismiss];
            break;
        case HRPoor:
            [_indicator setText:@"Poor"];
            break;
        case HRBelowAverage:
            [_indicator setText:@"Below Average"];
            break;
        case HRAvergae:
            [_indicator setText:@"Average"];
            break;
        case HRAboveAverage:
            [_indicator setText:@"Above Average"];
            break;
        case HRGood:
            [_indicator setText:@"Good"];
            break;
        case HRExcellent:
            [_indicator setText:@"Excellent"];
            break;
        case HRAthlete:
            [_indicator setText:@"Athlete"];
            break;
        default:
            break;
        }
    }
}

- (void)timer:(id)sender
{
    if (_startTime == nil) {
        _startTime = [_tappedTimes firstObject]; //[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
    } else {
        double currentTime = [[NSDate date] timeIntervalSince1970];
        double startTime = [_startTime doubleValue];
        double secondsOffset = currentTime - startTime;
        NSInteger min = (NSInteger)((NSInteger)secondsOffset / 60);
        double sec = secondsOffset - min * 60;
        //        NSLog(@"%f, %f // min: %d, sec: %f, sec:", startTime, currentTime, min, secondsOffset, sec);
        [_timerLabel setText:[NSString stringWithFormat:@"Time: %02ld:%05.2f", (long)min, sec]];
    }
}

- (void)updateTimer
{
    NSNumber* firstTapTime = [_tappedTimes firstObject];
    NSNumber* lastTapTime = [_tappedTimes lastObject];
    double secondsOffset = [lastTapTime doubleValue] - [firstTapTime doubleValue];
    NSInteger min = (NSInteger)((NSInteger)secondsOffset / 60);
    double sec = secondsOffset - min * 60;
    [_timerLabel setText:[NSString stringWithFormat:@"Time: %02ld:%05.2f", (long)min, sec]];
}

//#pragma mark -
//
//- (void)keyboardDidShow:(NSNotification*)notification
//{
//    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
//    _keyboardSize = keyboardFrame.size;
//    CGFloat moveUpHeight = _keyboardSize.height;
//    __block CGRect mainFrame = _mainScrollView.frame;
//    [UIView animateWithDuration:0.3 animations:^{
//        mainFrame.origin.y -= moveUpHeight;
//        _mainScrollView.frame = mainFrame;
//    }];
//}
//
//- (void)keyboardDidHide:(NSNotification*)notification
//{
//    CGFloat moveDownHeight = _keyboardSize.height;
//    __block CGRect mainFrame = _mainScrollView.frame;
//    [UIView animateWithDuration:0.3 animations:^{
//        mainFrame.origin.y += moveDownHeight;
//        _mainScrollView.frame = mainFrame;
//    }];
//}

#pragma mark - Rotation

//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    [self prepareViewsForOrientation:toInterfaceOrientation];
//}
//
//- (void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation
//{
//    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
//        return;
//    }
//    CGSize mainScreenSize = [UIScreen mainScreen].bounds.size;
//    NSLog(@"%@", NSStringFromCGSize(mainScreenSize));
//
//    //    CGFloat temp = mainScreenSize.height;
//    //    mainScreenSize.height = mainScreenSize.width;
//    //    mainScreenSize.width = temp;
//
//    // Landscape
//    // Home button on left
//    if (orientation == UIInterfaceOrientationLandscapeLeft) {
//        NSLog(@"Left");
//    }
//    // Home button on right
//    else if (orientation == UIInterfaceOrientationLandscapeRight) {
//        NSLog(@"Right");
//    }
//    // Protrait
//    else {
//        NSLog(@"Portrait");
//    }
//}

#pragma mark - TTHRMainScrollViewDelegate methods

- (BOOL)scrollView:(UIScrollView *)scrollView shouldMoveToScreen:(Screen)screen {
//    LogMethod;
    [_hintView setShow:NO withDuration:0 affectCounter:NO];
    if (_ageField.isFirstResponder) {
        [self textFieldResignFirstResponder:nil];
        return NO;
    } else {
        if (screen == Screen1_) {
            return NO;
        }
        return YES;
    }
}

- (void)scrollView:(UIScrollView *)scrollView willMoveToScreen:(Screen)screen {
//    LogMethod;
//    [self pause];
    if (screen == Screen0) {
        //
    } else if (screen == Screen1) {
        [self loadScreen1];
    } else {
        [self loadScreen1_];
    }
}

- (void)scrollView:(UIScrollView*)scrollView didMoveToScreen:(Screen)screen
{
//    LogMethod;
    //    [_tapButton setHighlighted:NO];
    //    [_resetButton setHighlighted:NO];
    //    [self pause];
    if (screen == Screen0) {
        _tapButton.enabled = YES;
        _resetButton.enabled = YES;
        [FIRAnalytics setScreenName:@"Main View" screenClass:[self description]];
    } else /*if (screen == Screen1)*/ {
        _tapButton.enabled = NO;
        _resetButton.enabled = NO;
        [FIRAnalytics setScreenName:@"Setting View" screenClass:[self description]];
    }
}

#pragma mark - Age text field delegate

- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    //    LogMethod;
}

- (void)textFieldDidEndEditing:(UITextField*)textField
{
    //    LogMethod;
    if ([textField.text length] == 0) {
        [TTHRUser sharedUser].age = -1;
    }
    [self updateLabels];
    [_maxHRLable setText:[NSString stringWithFormat:@" %ld", (long)[TTHRUser sharedUser].maxHR]];
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
//    NSLog(@"%d", _ageField.isFirstResponder ? 1: 0);
    //    LogMethod;
    //    NSLog(@"'%@' '%@'",textField.text, string);
    NSInteger age = [[textField.text stringByAppendingString:string] integerValue];
    if (age == 0 && [string integerValue] == 0) {
        return NO;
    }
    if (age > 129) {
        return NO;
    }
    [TTHRUser sharedUser].age = age;
    [_maxHRLable setText:[NSString stringWithFormat:@" %ld", (long)[[TTHRUser sharedUser] calculateMaxHR]]];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    //    LogMethod;
    [self textFieldResignFirstResponder:nil];
    return YES;
}

- (void)textFieldResignFirstResponder:(id)sender
{
    //    if ([sender isKindOfClass:[NSNotification class]]) {
    //        NSDictionary *userInfo = [(NSNotification *)sender userInfo];
    //        Screen touchedScreen = [userInfo[@"TouchedScreen"] integerValue];
    //        if (touchedScreen == Screen1) {
    //
    //        }
    //    }
    [_ageField resignFirstResponder];

}

#pragma mark - Helper methods

- (UIColor*)dimColor:(UIColor*)color with:(CGFloat)dim
{
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    UIColor* newColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha - dim];
    return newColor;
}

#pragma mark - iAd

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    [FIRAnalytics logEventWithName:@"Ad Displayed"
                        parameters:nil];
	if (!_bannerIsVisible)
	{
		// If banner isn't part of view hierarchy, add it
		if (self.adBannerView.superview == nil)
		{
			[self.view addSubview:self.adBannerView];
		}
		
		[UIView beginAnimations:@"animateAdBannerOn" context:NULL];
		
		self.adBannerView.frame = CGRectMake(0, self.view.frame.size.height - self.self.adBannerView.bounds.size.height, self.self.adBannerView.bounds.size.width, self.self.adBannerView.bounds.size.height);
		
		self.tapButton.frame = CGRectOffset(self.tapButton.frame, 0, -self.adBannerView.bounds.size.height / 2.0);
		self.resetButton.frame = CGRectOffset(self.resetButton.frame, 0, -self.adBannerView.bounds.size.height / 2.0);
		
		if (self.designLabel) {
			self.designLabel.frame = CGRectOffset(self.designLabel.frame, 0, -self.adBannerView.bounds.size.height);
		}
		
		[UIView commitAnimations];
		
		_bannerIsVisible = YES;
	}
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    [FIRAnalytics logEventWithName:@"Ad Removed"
                        parameters:@{
                                     @"error": [error description],
                                     }];
	if (_bannerIsVisible)
	{
		[UIView beginAnimations:@"animateAdBannerOff" context:NULL];
		
		self.adBannerView.frame = CGRectMake(0, self.view.frame.size.height, self.self.adBannerView.bounds.size.width, self.self.adBannerView.bounds.size.height);
		
		self.tapButton.frame = CGRectOffset(self.tapButton.frame, 0, self.adBannerView.bounds.size.height / 2.0);
		self.resetButton.frame = CGRectOffset(self.resetButton.frame, 0, self.adBannerView.bounds.size.height / 2.0);
		if (self.designLabel) {
			self.designLabel.frame = CGRectOffset(self.designLabel.frame, 0, self.adBannerView.bounds.size.height);
		}
		
		[UIView commitAnimations];
		
		_bannerIsVisible = NO;
	}
}

@end
