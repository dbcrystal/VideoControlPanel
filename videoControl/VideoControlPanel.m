//
//  videoControl.m
//  VideoControl
//
//  Created by LeeVic on 9/15/15.
//  Copyright (c) 2015 LAN. All rights reserved.
//

#import "VideoControlPanel.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoControlPanel ()

@property (nonatomic, strong) UIButton *controlButton;

@property (nonatomic, assign) CGPoint initDragPoint;
@property (nonatomic, assign) CGPoint lastDragPoint;

@property (nonatomic, assign) VideoControlPanelState currentState;

@property (nonatomic, strong) MPVolumeView *volumeView;

@property (nonatomic, assign) BOOL streamPauseControlEnable;
@property (nonatomic, assign) BOOL streamProgressControlEnable;
@property (nonatomic, assign) BOOL brightnessControlEnable;
@property (nonatomic, assign) BOOL volumeControlEnable;

@property (nonatomic, assign) CGFloat volumeValue;

@end

@implementation VideoControlPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.backgroundColor = [UIColor clearColor];
    
    self.controlButton = [[UIButton alloc] initWithFrame:self.frame];
    self.controlButton.backgroundColor = [UIColor clearColor];
    [self addSubview:self.controlButton];
    
    UIButton *testButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    testButton.backgroundColor = [UIColor blackColor];
    [testButton addTarget:self action:@selector(testButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    testButton.hidden = YES;
    [self addSubview:testButton];
    
    [self resetUI];
}

/**
 *  set pause gesture enable
 *
 *  @param streamPauseControlEnable :If pause gesture is enabled, set as YES.
 */
- (void)setVideoControlPanelStreamPauseControlEnable:(BOOL)streamPauseControlEnable
{
    self.streamPauseControlEnable = streamPauseControlEnable;
    if (self.streamPauseControlEnable) {
        [self.controlButton addTarget:self
                               action:@selector(controlButtonTouchDownRepeat:event:)
                     forControlEvents:UIControlEventTouchDownRepeat];
    } else {
        [self.controlButton removeTarget:self
                                  action:@selector(controlButtonTouchDownRepeat:event:)
                        forControlEvents:UIControlEventTouchDownRepeat];
    }
}

/**
 *  set video control gesture enable
 *
 *  @param streamProgressControlEnable :If user can control stream with gesture, set as YES.
 */
- (void)setVideoControlPanelStreamProgressControlEnable:(BOOL)streamProgressControlEnable
{
    self.streamProgressControlEnable = streamProgressControlEnable;
    if (self.streamProgressControlEnable) {
        [self.controlButton addTarget:self
                               action:@selector(controlButtonDragInside:event:)
                     forControlEvents:UIControlEventTouchDragInside];
        [self.controlButton addTarget:self
                               action:@selector(testButtonTapped)
                     forControlEvents:UIControlEventTouchUpInside];
    }
}

/**
 *  set brightness control enable
 *
 *  @param brightnessControlEnable :If user can change Screen brightnesswith gesture, set as YES.
 */
- (void)setVideoControlPanelBrightnessControlEnable:(BOOL)brightnessControlEnable
{
    self.brightnessControlEnable = brightnessControlEnable;
    if (self.brightnessControlEnable) {
        [self.controlButton addTarget:self
                               action:@selector(controlButtonDragInside:event:)
                     forControlEvents:UIControlEventTouchDragInside];
        [self.controlButton addTarget:self
                               action:@selector(testButtonTapped)
                     forControlEvents:UIControlEventTouchUpInside];
    }
}

/**
 *  set volume control enable
 *
 *  @param volumeControlEnable :If user can changeSystem volume by gesture, set as YES.
 */
- (void)setVideoControlPanelVolumeControlEnable:(BOOL)volumeControlEnable
{
    self.volumeControlEnable = volumeControlEnable;
    if (self.volumeControlEnable) {
        [self.controlButton addTarget:self
                               action:@selector(controlButtonDragInside:event:)
                     forControlEvents:UIControlEventTouchDragInside];
        [self.controlButton addTarget:self
                               action:@selector(testButtonTapped)
                     forControlEvents:UIControlEventTouchUpInside];
        
        self.volumeView = [[MPVolumeView alloc] init];
        self.volumeValue = [[AVAudioSession sharedInstance] outputVolume];
    }
}

- (void)resetUI
{
    self.currentState = videoControlPanelStateNone;
    self.initDragPoint = CGPointZero;
    self.lastDragPoint = CGPointZero;
    self.volumeValue = [[AVAudioSession sharedInstance] outputVolume];
    
    [self setVideoControlPanelStreamPauseControlEnable:NO];
    [self setVideoControlPanelStreamProgressControlEnable:NO];
    [self setVideoControlPanelBrightnessControlEnable:NO];
    [self setVideoControlPanelVolumeControlEnable:NO];
}

- (void)controlButtonTouchDownRepeat:(id)sender event:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    if(touch.tapCount == 2) {
        if ([self.delegate respondsToSelector:@selector(videoControlPanelDidCapturedPauseGesture)]) {
            [self.delegate videoControlPanelDidCapturedPauseGesture];
        }
    }
    else {
        NSLog(@"otherwise");
    }
}

- (void)controlButtonDragInside:(id)sender event:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    
    if (self.lastDragPoint.x == 0 && self.lastDragPoint.y == 0) {
        self.initDragPoint = location;
        self.lastDragPoint = location;
        return;
    }
    
    if (self.currentState == videoControlPanelStateNone) {
        [self detectCurrentDragStateWithCurrentTouchPoint:location];
    }
    
    
    
    switch (self.currentState) {
        case videoControlPanelStateChangeProgress:
        {
            if ([self.delegate respondsToSelector:@selector(videoControlPanelDetectDraggingGestureWithControlState:andOffset:)]) {
                [self.delegate videoControlPanelDetectDraggingGestureWithControlState:videoControlPanelStateChangeProgress
                                                                            andOffset:self.lastDragPoint.x - self.initDragPoint.x];
            }
        }
            break;
        case videoControlPanelStateChangeBrightness:
        {
            if ([self.delegate respondsToSelector:@selector(videoControlPanelDetectDraggingGestureWithControlState:andOffset:)]) {
                [self.delegate videoControlPanelDetectDraggingGestureWithControlState:videoControlPanelStateChangeBrightness
                                                                            andOffset:self.lastDragPoint.y - self.initDragPoint.y];
            }
            CGFloat brightness = [UIScreen mainScreen].brightness;
            [[UIScreen mainScreen] setBrightness:brightness-(location.y-self.lastDragPoint.y)/500];
        }
            break;
        case videoControlPanelStatechangeVolume:
        {
            if ([self.delegate respondsToSelector:@selector(videoControlPanelDetectDraggingGestureWithControlState:andOffset:)]) {
                [self.delegate videoControlPanelDetectDraggingGestureWithControlState:videoControlPanelStatechangeVolume
                                                                            andOffset:self.lastDragPoint.y - self.initDragPoint.y];
            }
            UISlider* volumeViewSlider = nil;
            for (UIView *view in [self.volumeView subviews]){
                if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                    volumeViewSlider = (UISlider*)view;
                    break;
                }
            }
            self.volumeValue = self.volumeValue-(location.y-self.lastDragPoint.y)/500;
            [volumeViewSlider setValue:self.volumeValue animated:YES];
            [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
            break;
        default:
            break;
    }
    
    self.lastDragPoint = location;
}

- (void)detectCurrentDragStateWithCurrentTouchPoint:(CGPoint)currentTouchPoint
{
    CGFloat offsetX = currentTouchPoint.x - self.lastDragPoint.x;
    CGFloat offsetY = currentTouchPoint.y - self.lastDragPoint.y;
    
    if (fabs(offsetY)>fabs(offsetX)) {
        NSLog(@"up/down");
        [self checkVideoControlStateIfIsBrightnessOrVolume];
    } else if (fabs(offsetX)>fabs(offsetY)) {
        NSLog(@"left/right");
        if (self.streamProgressControlEnable) {
            self.currentState = videoControlPanelStateChangeProgress;
        }
    }
}

- (void)checkVideoControlStateIfIsBrightnessOrVolume
{
    if (self.brightnessControlEnable == YES && self.volumeControlEnable == YES) {
        if (self.initDragPoint.x < self.frame.size.width/2) {
            self.currentState = videoControlPanelStateChangeBrightness;
        } else {
            self.currentState = videoControlPanelStatechangeVolume;
        }
    } else {
        if (self.brightnessControlEnable == YES) {
            self.currentState = videoControlPanelStateChangeBrightness;
        } else if (self.volumeControlEnable == YES) {
            self.currentState = videoControlPanelStatechangeVolume;
        }
    }
}

- (void)testButtonTapped
{
    if (self.currentState == videoControlPanelStateNone) {
        return;
    }
    NSLog(@"drag ended!!!!!!!!!");
    NSLog(@"system volume is %f", [[AVAudioSession sharedInstance] outputVolume]);
    switch (self.currentState) {
        case videoControlPanelStateChangeProgress:
        {
            if ([self.delegate respondsToSelector:@selector(videoControlPanelDidEndDragGestureWithControlState:andOffset:)]) {
                [self.delegate videoControlPanelDidEndDragGestureWithControlState:videoControlPanelStateChangeProgress
                                                                        andOffset:self.lastDragPoint.x - self.initDragPoint.x];
            }
        }
            break;
        case videoControlPanelStateChangeBrightness:
        {
            if ([self.delegate respondsToSelector:@selector(videoControlPanelDidEndDragGestureWithControlState:andOffset:)]) {
                [self.delegate videoControlPanelDidEndDragGestureWithControlState:videoControlPanelStateChangeBrightness
                                                                        andOffset:self.lastDragPoint.y - self.initDragPoint.y];
            }
        }
            break;
        case videoControlPanelStatechangeVolume:
        {
            if ([self.delegate respondsToSelector:@selector(videoControlPanelDidEndDragGestureWithControlState:andOffset:)]) {
                [self.delegate videoControlPanelDidEndDragGestureWithControlState:videoControlPanelStatechangeVolume
                                                                        andOffset:self.lastDragPoint.y - self.initDragPoint.y];
            }
        }
            break;
        default:
            break;
    }
    
    self.currentState = videoControlPanelStateNone;
    self.lastDragPoint = CGPointZero;
}

@end
