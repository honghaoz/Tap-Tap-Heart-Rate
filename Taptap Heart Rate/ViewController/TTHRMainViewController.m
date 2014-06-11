//
//  TTHRMainViewController.m
//  Taptap Heart Rate
//
//  Created by Zhang Honghao on 6/10/14.
//  Copyright (c) 2014 org-honghao. All rights reserved.
//

#import "TTHRMainViewController.h"

@interface TTHRMainViewController ()

@property (nonatomic, assign) NSInteger tappedTime;
@property (nonatomic, assign) NSInteger heartRate;
@property (nonatomic, strong) NSMutableArray *tappedSeconds;

@property (nonatomic, strong) UILabel *heartRateLabel;
@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, strong) UIButton *tapButton;
@property (nonatomic, strong) UIButton *resetButton;


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
        ;
    }
    return self;
}

- (void)loadView {
    LogMethod;
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize mainScreenSize = [UIScreen mainScreen].bounds.size;
    
    CGFloat heartRateLabelHeight = 100;
    CGFloat heartRateLabelWidth = 200;
    CGFloat heartRateLabelX = (mainScreenSize.width - heartRateLabelWidth) / 2;
    CGFloat heartRateLabelY = 70;
    CGRect heartRateLabelFrame = CGRectMake(heartRateLabelX, heartRateLabelY, heartRateLabelWidth, heartRateLabelHeight);
    _heartRateLabel = [[UILabel alloc] initWithFrame:heartRateLabelFrame];
    [_heartRateLabel setText:[NSString stringWithFormat:@"%d", _heartRate]];
    [_heartRateLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:120]];
    [_heartRateLabel setTextAlignment:NSTextAlignmentCenter];
    [_heartRateLabel setTextColor:[UIColor blackColor]];
    
    CGFloat timerLabelHeight = 50;
    CGFloat timerLabelWidth = 100;
    CGFloat timerLabelX = (mainScreenSize.width - timerLabelWidth) / 2;
    CGFloat timerLabelY = 20 + heartRateLabelY + heartRateLabelHeight;
    CGRect timerLabelFrame = CGRectMake(timerLabelX, timerLabelY, timerLabelWidth, timerLabelHeight);
    _timerLabel = [[UILabel alloc] initWithFrame:timerLabelFrame];
    [_timerLabel setText:@"+00.00"];
    [_timerLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:30]];
    [_timerLabel setTextAlignment:NSTextAlignmentRight];
    [_timerLabel setTextColor:[UIColor blackColor]];
    
    CGFloat tapButtonHeight = 50;
    CGFloat tapButtonWidth = 50;
    CGFloat tapButtonX = (mainScreenSize.width - tapButtonWidth) / 3;
    CGFloat tapButtonY = mainScreenSize.height - tapButtonHeight - 50;
    CGRect tapButtonFrame = CGRectMake(tapButtonX, tapButtonY, tapButtonWidth, tapButtonHeight);
    _tapButton = [[UIButton alloc] initWithFrame:tapButtonFrame];
    [_tapButton setTitle:@"Tap" forState:UIControlStateNormal];
    [_tapButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_tapButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    _tapButton.backgroundColor = [UIColor clearColor];
    [_tapButton addTarget:self action:@selector(tapButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat resetButtonX = tapButtonX * 2;
    CGRect resetButtonFrame = CGRectMake(resetButtonX, tapButtonY, tapButtonWidth, tapButtonHeight);
    _resetButton = [[UIButton alloc] initWithFrame:resetButtonFrame];
    [_resetButton setTitle:@"Reset" forState:UIControlStateNormal];
    [_resetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_resetButton addTarget:self action:@selector(resetButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_tapButton];
    [self.view addSubview:_resetButton];
    [self.view addSubview:_heartRateLabel];
    [self.view addSubview:_timerLabel];
}

- (void)viewDidLoad
{
    LogMethod;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tappedTime = 0;
    _heartRate = 0;
    _tappedSeconds = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)tapButtonTapped:(id)sender {
    LogMethod;
    _tappedTime++;
    [_tappedSeconds addObject:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]];
    [self updateLabels];
}

- (void)resetButtonTapped:(id)sender {
    LogMethod;
    _tappedTime = 0;
    _heartRate = 0;
    [_tappedSeconds removeAllObjects];
    [self updateLabels];
}

- (void)updateLabels{
    NSInteger tapCount = [_tappedSeconds count];
    if (tapCount < 3) {
        [_heartRateLabel setText:[NSString stringWithFormat:@"%d", _heartRate]];
        [_timerLabel setText:@"+00.00"];
        return;
    }
    NSNumber *lastTapTime = [_tappedSeconds lastObject];
    NSNumber *lastSecondTapTime = [_tappedSeconds objectAtIndex:tapCount - 2];
    NSNumber *lastThirdTapTime = [_tappedSeconds objectAtIndex:tapCount - 3];
    double offset1 = [lastSecondTapTime doubleValue] - [lastThirdTapTime doubleValue];
    double offset2 = [lastTapTime doubleValue] - [lastSecondTapTime doubleValue];
    double offset = offset2 - offset1;
    [_timerLabel setText:[NSString stringWithFormat:offset < 0 ? @"%06.2f": @"+%05.2f", offset]];
    
    //double averageOffset = (offset1 + offset2) / 2;
    
    double totalOffset = [[_tappedSeconds lastObject] doubleValue] - [[_tappedSeconds firstObject] doubleValue];
    double averageOffset = totalOffset / (tapCount - 1);
    _heartRate = 60 / averageOffset;
    [_heartRateLabel setText:[NSString stringWithFormat:@"%d", _heartRate]];
    //NSLog(@"%0.2f", offset2 - offset1);
}
@end
