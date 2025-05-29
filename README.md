# LiveKit Flutter SDK with Video Effects SDK

This repository contains the fork of [livekit flutter](https://github.com/livekit/client-sdk-flutter) with [Video Effects SDK](https://effectssdk.ai) integration. **Video Effects SDK** has built-in real-time AI video enhancements that makes video meeting experience more effective and comfortable to your application.  
  
Similar to [Flutter-WebRTC](https://github.com/flutter-webrtc/flutter-webrtc) this fork adds functional of **Video Effects SDK** into [livekit flutter](https://github.com/livekit/client-sdk-flutter) API and you can easily use it. **Video Effects SDK** has effect only when enabled, the SDK applies enhancements to frames in local video stream, else is the same as original livekit.  
  
Supported platforms:  
* Android
* iOS

## LiveKit demo app

There are some changes in **client-sdk-flutter/example** app, so you can build it as is from this repository.

## How to use

1. Add livekit dependency into your project, if If original **livekit** is already used, replace it with this fork.
```yaml
dependencies:
  livekit_client:
    git:
      url: https://github.com/EffectsSDK/livekit-client-sdk-flutter.git
```

2. Create cameraVideoTrack by using LocalVideoTrack.createCameraTrack() with effectsEdkRequired flag
3. Call auth() method with your customer key
4. Set Effects SDK parameters for your video track

```dart
_videoTrack = await LocalVideoTrack.createCameraTrack(
  CameraCaptureOptions(
      deviceId: _selectedVideoDevice!.deviceId,
      params: _selectedVideoParameters,
      effectsSdkRequired: true,
  )
);
await _videoTrack!.start();
// You can call auth at any time after start.
AuthStatus status = await _videoTrack!.auth('YOUR_CUSTOMER_KEY');
switch (status){
    case AuthStatus.active:
      _videoTrack!.setPipelineMode(PipelineMode.blur);
      _videoTrack!.setBlurPower(0.99);
      break;
    case AuthStatus.expired:
      // TODO: Handle this case.
      break;
    case AuthStatus.inactive:
      // TODO: Handle this case.
      break;
    case AuthStatus.unavailable:
      // TODO: Handle this case.
      break;
}

```

You can manage all sdk parameters without VideoTrack recreation.

## EffectsSDK methods

Check platform specifications:
1. [iOS](https://github.com/EffectsSDK/swift-video-effects-sdk)
2. [android](https://github.com/EffectsSDK/android-integration-sample)

### Effects SDK Image

class EffectsSdkImage

Can be created from:

1. raw data
2. file
3. encoded data
4. rgb color

## Technical details

All additional LocalVideoTrack methods was implemented as extension functions. Also,
we create custom CameraVideoCapturer instance for Effects SDK camera pipeline(android).
You can modify our solution as you need or try another way for integration (for example with custom VideoProcessor).
Also you can replace CameraPipeline to lite version of it.

## Additional links

1. Platform documentation ([iOS](https://effectssdk.ai/sdk/ios/documentation/tsvb), [android](https://github.com/EffectsSDK/android-integration-sample))
2. Effects SDK [site](https://effectssdk.ai/)

