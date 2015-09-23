# VideoControlPanel

## How to use
### You can use videoContolPanel by adding code:
```objective-c
videoControlPanel = [[VideoControlPanel alloc] initWithFrame:view.frame];
videoControlPanel.delegate = self;
//Set as you want
[videoControlPanel setVideoControlPanelStreamPauseControlEnable:YES];
[videoControlPanel setVideoControlPanelBrightnessControlEnable:YES];
[videoControlPanel setVideoControlPanelVolumeControlEnable:YES];
[videoControlPanel setVideoControlPanelStreamProgressControlEnable:YES];

[view addSubview:videoControlPanel];
```

## VideoControlPanelDelegate
### 
```objective-c
//Capture pause stream command
- (void)videoControlPanelDidCapturedPauseGesture;

//user is dragging with control state
- (void)videoControlPanelDetectDraggingGestureWithControlState:(VideoControlPanelState)controlState andOffset:(CGFloat)offset;

//user did stop dragging gesture with control state
- (void)videoControlPanelDidEndDragGestureWithControlState:(VideoControlPanelState)controlState andOffset:(CGFloat)offset;
```
