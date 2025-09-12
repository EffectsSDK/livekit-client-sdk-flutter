# LiveKit Flutter SDK with Video Effects SDK

This repository contains the fork of [livekit flutter](https://github.com/livekit/client-sdk-flutter) with [Video Effects SDK](https://effectssdk.ai) integration. **Video Effects SDK** has built-in real-time AI video enhancements that makes video meeting experience more effective and comfortable to your application.  
  
Similar to [Flutter-WebRTC](https://github.com/flutter-webrtc/flutter-webrtc) this fork adds functional of **Video Effects SDK** into [livekit flutter](https://github.com/livekit/client-sdk-flutter) API and you can easily use it. **Video Effects SDK** has effect only when enabled, the SDK applies enhancements to frames in local video stream, else is the same as original livekit.  
  
Supported platforms:  
* Android
* iOS
* Web

## LiveKit demo app

There are some changes in **client-sdk-flutter/example** app, so you can build it as is from this repository.

## How to use

There is some API differences between Web platform and mobile platforms.

Add livekit dependency into your project, if If original **livekit** is already used, replace it with this fork.
```yaml
dependencies:
  livekit_client:
    git:
      url: https://github.com/EffectsSDK/livekit-client-sdk-flutter.git
```

For the web, add the next line to your index.html.
```html
<script src="https://effectssdk.ai/sdk/web/3.5.7/tsvb-web.js"></script>
```
Call [VideoEffectsSDKExt.initialize](https://effectssdk.ai/sdk/livekit-flutter/livekit_client/VideoEffectsSDKExt/initialize.html) method before the first `LocalVideoTrack.createCameraTrack` call.
```dart
VideoEffectsSDKExt.initialize('YOUR_CUSTOMER_ID');
```

1. Create cameraVideoTrack by using LocalVideoTrack.createCameraTrack() with effectsEdkRequired flag
2. Call auth() method with your customer key if Android/iOS platform.
3. Set Effects SDK parameters for your video track

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
AuthStatus status = await _videoTrack!.auth('YOUR_CUSTOMER_ID');
switch (status){
    case AuthStatus.active:
      await _videoTrack!.setPipelineMode(PipelineMode.blur);
      await _videoTrack!.setBlurPower(0.6);
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

## Trial Evaluation

A Customer ID is required for the Effects SDK.

To receive a new trial Customer ID, please fill out the contact form on the [effectssdk.ai](https://effectssdk.ai/request-trial) website.

## EffectsSDK Documentation

[Video Effects SDK Extension API Reference](https://effectssdk.ai/sdk/livekit-flutter/livekit_client/VideoEffectsSDKExt.html)  

Check platform specifications:
1. [iOS](https://github.com/EffectsSDK/swift-video-effects-sdk)
2. [android](https://github.com/EffectsSDK/android-integration-sample)

## Technical details

All additional LocalVideoTrack methods was implemented as extension functions. Also,
we create custom CameraVideoCapturer instance for Effects SDK camera pipeline(android).
You can modify our solution as you need or try another way for integration (for example with custom VideoProcessor).
Also you can replace CameraPipeline to lite version of it.

## Additional links

1. Platform documentation ([iOS](https://effectssdk.ai/sdk/ios/documentation/tsvb), [android](https://github.com/EffectsSDK/android-integration-sample), [web](https://effectssdk.ai/sdk/web/docs/classes/tsvb.html))
2. Effects SDK [site](https://effectssdk.ai/)
3. Original livekit API documentation [site](https://docs.livekit.io/reference/client-sdk-flutter/)

