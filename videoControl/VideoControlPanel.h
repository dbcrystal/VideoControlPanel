//
//  videoControl.h
//  VideoControl
//
//  Created by LeeVic on 9/15/15.
//  Copyright (c) 2015 LAN. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, VideoControlPanelState) {
    videoControlPanelStateNone = 0,
    videoControlPanelStateChangeProgress,
    videoControlPanelStateChangeBrightness,
    videoControlPanelStatechangeVolume
};

@protocol VideoControlPanelDelegate <NSObject>

- (void)videoControlPanelDidCapturedPauseGesture;
- (void)videoControlPanelDetectDraggingGestureWithControlState:(VideoControlPanelState)controlState andOffset:(CGFloat)offset;
- (void)videoControlPanelDidEndDragGestureWithControlState:(VideoControlPanelState)controlState andOffset:(CGFloat)offset;

@end

@interface VideoControlPanel : UIView

@property (nonatomic, weak) id<VideoControlPanelDelegate> delegate;

/**
 *  set pause gesture enable
 *
 *  @param streamPauseControlEnable :If pause gesture is enabled, set as YES. Default is NO.
 */
- (void)setVideoControlPanelStreamPauseControlEnable:(BOOL)streamPauseControlEnable;


/**
 *  set video control gesture enable
 *
 *  @param streamProgressControlEnable :If user can control stream with gesture, set as YES. Default is NO.
 */
- (void)setVideoControlPanelStreamProgressControlEnable:(BOOL)streamProgressControlEnable;

/**
 *  set brightness control enable
 *
 *  @param brightnessControlEnable :If user can change Screen brightnesswith gesture, set as YES. Default is NO.
 */
- (void)setVideoControlPanelBrightnessControlEnable:(BOOL)brightnessControlEnable;

/**
 *  set volume control enable
 *
 *  @param volumeControlEnable :If user can changeSystem volume by gesture, set as YES. Default is NO.
 */
- (void)setVideoControlPanelVolumeControlEnable:(BOOL)volumeControlEnable;

@end
