# VideoControlPanel

## How to use

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