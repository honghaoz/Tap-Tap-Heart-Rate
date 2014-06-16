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
#import "TTHRGoogleAnalytics.h"

@interface TTHRMainViewController () <TTHRMainScrollViewDelegate>

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *buttonColor;

@property (nonatomic, assign) Mode currentMode;

@property (nonatomic, assign) NSInteger countNumber;
@property (nonatomic, assign) BOOL isTracking;
@property (nonatomic, strong) NSNumber *startTime;
@property (nonatomic, assign) NSInteger beatNumber;
@property (nonatomic, assign) NSInteger heartRate;
@property (nonatomic, strong) NSMutableArray *tappedTimes;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) TTHRMainScrollView *mainScrollView;
@property (nonatomic, strong) UILabel *heartRateTilteLabel;
@property (nonatomic, strong) UILabel *heartRateLabel;

@property (nonatomic, strong) UILabel *beatLabel;
@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, strong) UILabel *offsetLabel;

@property (nonatomic, strong) TTHRTapButton *tapButton;
@property (nonatomic, strong) TTHRTapButton *resetButton;

@property (nonatomic, strong) UILabel *segmentLabel;
@property (nonatomic, strong) UISegmentedControl *segmentControl;


@end

@implementation TTHRMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init {
    LogMethod;
    self = [super init];
    if (self) {
        _backgroundColor = [UIColor colorWithRed:0.73 green:0.03 blue:0.10 alpha:1];//[UIColor colorWithRed:0.8 green:0.1 blue:0.16 alpha:1];//[UIColor colorWithRed:0.95 green:0.3 blue:0.22 alpha:1];
        _buttonColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.83];
        
        _currentMode = FiveMode;
        if (_currentMode == FiveMode) {
            _countNumber = 5;
        } else if (_currentMode == TenMode) {
            _countNumber = 10;
        } else {
            _countNumber = 0;
        }
        
        _isTracking = NO;
        _beatNumber = 0;
        _heartRate = 0;
        _tappedTimes = nil;
    }
    return self;
}

- (void)loadView {
    LogMethod;
    self.view = [[UIView alloc] init];
    //[self.view setBackgroundColor:_backgroundColor];
    
    CGSize mainScreenSize = [UIScreen mainScreen].bounds.size;
    
    _mainScrollView = [[TTHRMainScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    CGSize bigSize = mainScreenSize;
    bigSize.width *= 1.7;
    [_mainScrollView setContentSize:bigSize];
    [_mainScrollView setPagingEnabled:YES];
    [_mainScrollView setBackgroundColor:_backgroundColor];
    [_mainScrollView setOpaque:YES];
    [_mainScrollView setMultipleTouchEnabled:NO];
    [_mainScrollView setBounces:NO];
    [_mainScrollView setShowsHorizontalScrollIndicator:NO];
    [_mainScrollView setShowsVerticalScrollIndicator:NO];
    _mainScrollView.canCancelContentTouches = NO;
    _mainScrollView.delaysContentTouches = NO;
    [_mainScrollView setScrollEnabled:NO];
    _mainScrollView.screenDelegate = self;
    [self.view addSubview:_mainScrollView];
    
    // Heart Rate Label
    CGFloat heartRateLabelHeight = 100;
    CGFloat heartRateLabelWidth = 220;
    CGFloat heartRateLabelX = (mainScreenSize.width - heartRateLabelWidth) / 2;
    CGFloat heartRateLabelY = 0;
    // On 4inch Screen, move label down
    if (IS_IPHONE_5) {
        heartRateLabelY = 65;
    } else {
        heartRateLabelY = 55;
    }
    CGRect heartRateLabelFrame = CGRectMake(heartRateLabelX, heartRateLabelY, heartRateLabelWidth, heartRateLabelHeight);
    _heartRateLabel = [[UILabel alloc] initWithFrame:heartRateLabelFrame];
    [_heartRateLabel setText:_heartRate == 0? @"---": [NSString stringWithFormat:@"%ld", (long)_heartRate]];
    [_heartRateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:130]];
    [_heartRateLabel setTextAlignment:NSTextAlignmentCenter];
    [_heartRateLabel setTextColor:_buttonColor];
    
    // Heart Rate Title Label
    CGFloat heartRateTitleLabelHeight = 30;
    CGFloat heartRateTitleLabelWidth = 43;
    CGFloat heartRateTitleLabelX = heartRateLabelX - heartRateTitleLabelWidth + 15;
    CGFloat heartRateTitleLabelY = heartRateLabelY - heartRateTitleLabelHeight;
    CGRect heartRateTitleLabelFrame = CGRectMake(heartRateTitleLabelX, heartRateTitleLabelY, heartRateTitleLabelWidth, heartRateTitleLabelHeight);
    _heartRateTilteLabel = [[UILabel alloc] initWithFrame:heartRateTitleLabelFrame];
    [_heartRateTilteLabel setText:@"BPM:"];
    [_heartRateTilteLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]];
    [_heartRateTilteLabel setTextAlignment:NSTextAlignmentLeft];
    [_heartRateTilteLabel setTextColor:_buttonColor];
    
    // Beat Label
    CGFloat beatLabelHeight = 30;
    CGFloat beatLabelWidth = 79;
    CGFloat beatLabelX = heartRateTitleLabelX;
    CGFloat beatLabelY = heartRateLabelY + heartRateLabelHeight + 10;
    CGRect beatLabelFrame = CGRectMake(beatLabelX, beatLabelY, beatLabelWidth, beatLabelHeight);
    _beatLabel = [[UILabel alloc] initWithFrame:beatLabelFrame];
    [_beatLabel setText:[NSString stringWithFormat:@"Beats: %ld", (long)_beatNumber]];
    [_beatLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:15]];
    [_beatLabel setTextAlignment:NSTextAlignmentLeft];
    [_beatLabel setTextColor:_buttonColor];
    
    // Timer Label
    CGFloat timerLabelHeight = 30;
    CGFloat timerLabelWidth = 97;
    CGFloat timerLabelX = beatLabelX + beatLabelWidth + 2;
    CGFloat timerLabelY = beatLabelY;
    CGRect timerLabelFrame = CGRectMake(timerLabelX, timerLabelY, timerLabelWidth, timerLabelHeight);
    _timerLabel = [[UILabel alloc] initWithFrame:timerLabelFrame];
    [_timerLabel setText:@"Time: 00:00.00"];
    [_timerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:15]];
    [_timerLabel setTextAlignment:NSTextAlignmentLeft];
    [_timerLabel setTextColor:_buttonColor];
    
    // Offset Label
    CGFloat offsetLabelHeight = 30;
    CGFloat offsetLabelWidth = 100;
    CGFloat offsetLabelX = timerLabelX + timerLabelWidth + 10;
    CGFloat offsetLabelY = timerLabelY;
    CGRect offsetLabelFrame = CGRectMake(offsetLabelX, offsetLabelY, offsetLabelWidth, offsetLabelHeight);
    _offsetLabel = [[UILabel alloc] initWithFrame:offsetLabelFrame];
    [_offsetLabel setText:@"Offset: +00.00"];
    [_offsetLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:15]];
    [_offsetLabel setTextAlignment:NSTextAlignmentLeft];
    [_offsetLabel setTextColor:_buttonColor];
    
    
    // Tap Button
    CGFloat tapButtonHeight = 230;
    CGFloat tapButtonWidth = 230;
    CGFloat tapButtonX = (mainScreenSize.width - tapButtonWidth) / 2;
    CGFloat tapButtonY = 0;
    // On 4inch Screen, move label up
    if (IS_IPHONE_5) {
        tapButtonY = mainScreenSize.height - tapButtonHeight - 50;
    } else {
        tapButtonY = mainScreenSize.height - tapButtonHeight - 30;
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
    CGFloat resetButtonWidth = 70;
    CGFloat resetButtonX = tapButtonX + tapButtonWidth - 25;
    CGFloat resetButtonY = tapButtonY + tapButtonHeight - resetButtonHeight + 6;
    CGRect resetButtonFrame = CGRectMake(resetButtonX, resetButtonY, resetButtonWidth, resetButtonHeight);
    _resetButton = [[TTHRTapButton alloc] initWithFrame:resetButtonFrame circleWidth:0 buttonColor:[self dimColor:_buttonColor with:0.05] circleColor:nil];
    [_resetButton setTitle:@"Reset" forState:UIControlStateNormal];
    [_resetButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
    [_resetButton setTitleColor:_backgroundColor forState:UIControlStateNormal];
    [_resetButton addTarget:self action:@selector(resetButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    _resetButton.adjustsImageWhenDisabled = NO;
    
    
    // SegmentLabel
    CGFloat segmentLabelHeight = 30;
    CGFloat segmentLabelWidth = 140;
    CGFloat segmentLabelX = mainScreenSize.width + (_mainScrollView.contentSize.width - mainScreenSize.width - segmentLabelWidth) / 2;
    CGFloat segmentLabelY = heartRateTitleLabelY;
    CGRect segmentLabelFrame = CGRectMake(segmentLabelX, segmentLabelY, segmentLabelWidth, segmentLabelHeight);
    _segmentLabel = [[UILabel alloc] initWithFrame:segmentLabelFrame];
    [_segmentLabel setText:@"Choose Tap Mode"];
    [_segmentLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17]];
    [_segmentLabel setTextAlignment:NSTextAlignmentCenter];
    [_segmentLabel setTextColor:_buttonColor];
    
    // SegmentControl
    CGFloat segmentHeight = 70;
    CGFloat segmentWidth = 150;
    CGFloat segmentX = 10;
    CGFloat segmentY = segmentLabelY + segmentLabelHeight + 10;
    _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"5", @"10", @"Tap"]];
    segmentHeight = _segmentControl.frame.size.height;
    segmentX = mainScreenSize.width + (_mainScrollView.contentSize.width - mainScreenSize.width - segmentWidth) / 2;
    CGRect segmentFrame = CGRectMake(segmentX, segmentY, segmentWidth, segmentHeight);
    _segmentControl.frame = segmentFrame;
    [_segmentControl setTintColor:_buttonColor];
    [_segmentControl setSelectedSegmentIndex:0];
    [_segmentControl addTarget:self action:@selector(segmentTapped:) forControlEvents:UIControlEventValueChanged];
    
    
    [_mainScrollView addSubview:_heartRateTilteLabel];
    [_mainScrollView addSubview:_heartRateLabel];
    
    [_mainScrollView addSubview:_beatLabel];
    [_mainScrollView addSubview:_timerLabel];
    [_mainScrollView addSubview:_offsetLabel];
    
    [_mainScrollView addSubview:_tapButton];
    [_mainScrollView addSubview:_resetButton];
    
    [_mainScrollView addSubview:_segmentLabel];
    [_mainScrollView addSubview:_segmentControl];
}

- (void)viewDidLoad
{
    LogMethod;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tappedTimes = [[NSMutableArray alloc] init];
    [self setNeedsStatusBarAppearanceUpdate];
    [self segmentTapped:nil];
    // Google Analytics
    [TTHRGoogleAnalytics analyticScreen:@"Main Screen"];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)tapButtonTapped:(id)sender {
    _beatNumber++;
    [_tappedTimes addObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]];
    
    if (!_isTracking) {
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        _timer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
        [runloop addTimer:_timer forMode:NSRunLoopCommonModes];
        [runloop addTimer:_timer forMode:UITrackingRunLoopMode];
    }
    switch (_currentMode) {
        case FiveMode:
        case TenMode: {
            // From isTracking to not traking
            if (_isTracking) {
                _isTracking = NO;
//                _beatNumber++;
//                [_tappedTimes addObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]];
                [self updateLabels];
                [self stop];
            }
            // From not tracking to isTracking
            else {
                _isTracking = YES;
//                _beatNumber++;
//                [_tappedTimes addObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]];
                [self updateLabels];
            }
            break;
        }
        case TapMode: {
            _isTracking = YES;
//            _beatNumber++;
//            [_tappedTimes addObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]];
            [self updateLabels];
            break;
        }
        default:
            break;
    }
    
}

- (void)resetButtonTapped:(id)sender {
    _isTracking = NO;
    _startTime = nil;
    [_timer invalidate];
    _beatNumber = 0;
    _heartRate = 0;
    [_tappedTimes removeAllObjects];
    [self updateLabels];
}

- (void)segmentTapped:(id)sender {
    LogMethod;
    switch (_segmentControl.selectedSegmentIndex) {
        case 0: {
            _currentMode = FiveMode;
            _countNumber = 5;
            break;
        }
        case 1: {
            _currentMode = TenMode;
            _countNumber = 10;
            break;
        }
        case 2:{
            _currentMode = TapMode;
            break;
        }
        default:
            break;
    }
    [self resetButtonTapped:nil];
//    [_mainScrollView moveToScreen:Screen0];
}

- (void)stop {
    _isTracking = NO;
    _startTime = nil;
    [_timer invalidate];
    _beatNumber = 0;
    _heartRate = 0;
    [_tappedTimes removeAllObjects];
}

- (void)updateLabels{
    switch (_currentMode) {
        case FiveMode:
        case TenMode: {
            if (_isTracking) {
                [_tapButton setTitle:@"Counting..." forState:UIControlStateNormal];
                [_tapButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:34]];
                [_tapButton setLabelBelowWithTitle:@"Tap to end" andColor:_backgroundColor];
                [_tapButton dimButtonColor:YES];
                [_heartRateLabel setText:@"---"];
                [_offsetLabel setText:@"Offset: +00.00"];
            }
            // Not tracking, update Heart Rate (Be careful for the first time)
            else {
                // Need to show Heart Rate
                if (_beatNumber == 2) {
                    NSNumber *firstTapTime = [_tappedTimes firstObject];
                    NSNumber *lastTapTime = [_tappedTimes lastObject];
                    double offset = [lastTapTime doubleValue] - [firstTapTime doubleValue];
                    _heartRate = lround(60.0 / (offset / _countNumber));
                    [_heartRateLabel setText:[NSString stringWithFormat:@"%ld", (long)_heartRate]];
                    [_offsetLabel setText:[NSString stringWithFormat:offset < 0 ? @"Offset: %06.2f": @"Offset: +%05.2f", offset]];
                } else {
                    [_heartRateLabel setText:@"---"];
                    [_offsetLabel setText:@"Offset: +00.00"];
                }
                [_tapButton setTitle:@"Start" forState:UIControlStateNormal];
                [_tapButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:46]];
                [_tapButton setLabelBelowWithTitle:[NSString stringWithFormat:@"Count %d beats", _countNumber] andColor:_backgroundColor];
                [_tapButton dimButtonColor:NO];
            }
            [_tapButton.labelBelow setNumberOfLines:1];
            [_tapButton setNeedsDisplay];
            break;
        }
        case TapMode: {
            if (_isTracking) {
                [_tapButton setTitle:@"Tap" forState:UIControlStateNormal];
                [_tapButton setLabelBelowWithTitle:@"" andColor:_backgroundColor];
                
            } else {
                [_tapButton setTitle:@"Tap" forState:UIControlStateNormal];
                [_tapButton setLabelBelowWithTitle:@"Tap after each beat" andColor:_backgroundColor];
                [_tapButton.labelBelow setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
                [_tapButton.labelBelow setNumberOfLines:2];
                
            }
            [_tapButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:46]];
            [_tapButton setNeedsDisplay];
            
            [_beatLabel setText:[NSString stringWithFormat:@"Beats: %ld", (long)_beatNumber]];
            if (_startTime == nil) {
                [_timerLabel setText:@"Time: 00:00.00"];
            }
            if (_beatNumber < 3) {
                [_heartRateLabel setText:_heartRate == 0? @"---": [NSString stringWithFormat:@"%ld", (long)_heartRate]];
                [_offsetLabel setText:@"Offset: +00.00"];
                return;
            }
            NSNumber *lastTapTime = [_tappedTimes lastObject];
            NSNumber *lastSecondTapTime = [_tappedTimes objectAtIndex:_beatNumber - 2];
            NSNumber *lastThirdTapTime = [_tappedTimes objectAtIndex:_beatNumber - 3];
            double offset1 = [lastSecondTapTime doubleValue] - [lastThirdTapTime doubleValue];
            double offset2 = [lastTapTime doubleValue] - [lastSecondTapTime doubleValue];
            double offset = offset2 - offset1;
            [_offsetLabel setText:[NSString stringWithFormat:offset < 0 ? @"Offset: %06.2f": @"Offset: +%05.2f", offset]];
            
            //double averageOffset = (offset1 + offset2) / 2;
            
            double totalOffset = [[_tappedTimes lastObject] doubleValue] - [[_tappedTimes firstObject] doubleValue];
            double averageOffset = totalOffset / (_beatNumber - 1);
            _heartRate = 60 / averageOffset;
            [_heartRateLabel setText:[NSString stringWithFormat:@"%ld", (long)_heartRate]];
            
            break;
        }
        default:
            break;
    }
    if (_startTime == nil) {
        [_timerLabel setText:@"Time: 00:00.00"];
    }
}

- (void)timer:(id)sender {
    if (_startTime == nil) {
        _startTime = [_tappedTimes firstObject];//[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]];
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

#pragma mark - TTHRMainScrollViewDelegate methods

- (void)scrollView:(UIScrollView *)scrollView moveToScreen:(Screen)screen {
    if (screen == Screen0) {
        _tapButton.enabled = YES;
        _resetButton.enabled = YES;
    } else if (screen == Screen1) {
        _tapButton.enabled = NO;
        _resetButton.enabled = NO;
    }
}

#pragma mark - Helper methods

- (UIColor *)dimColor:(UIColor *)color with:(CGFloat)dim {
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    UIColor *newColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha - dim];
    return newColor;
}
@end
