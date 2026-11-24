// Copyright 2024 LiveKit, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'package:meta/meta.dart';
import 'package:synchronized/synchronized.dart';

import 'video.dart';

typedef _Authorize = Future<rtc.AuthStatus> Function(rtc.MediaStreamTrack);

class _EffectsSettings {
  final lock = Lock();
  _Authorize? authorize;
  rtc.PipelineMode? pipelineMode;
  double? blurPower;
  rtc.EffectsSdkImage? backgroundImage;
  bool? beautificationEnabled;
  double? beautificationPower;
  double? zoomLevel;
  bool? sharpeningEnabled;
  double? sharpeningStrength;
  rtc.ColorCorrectionMode? colorCorrectionMode;
  double? colorFilterStrength;
  rtc.EffectsSdkImage? colorGradingReference;
  bool? noiseSuppressionEnabled;
  bool? portraitLightingEnabled;
  rtc.PortraitLightingOptions? portraitLightingOptions;
  rtc.ColorCorrectionConfig? colorCorrectionConfig;
}

final _settingsByTrack = Expando<_EffectsSettings>();

/// Video Effects SDK extensions to enable/disable SDK's filters
extension VideoEffectsSDKExt on LocalVideoTrack {
  _EffectsSettings get _settings => _settingsByTrack[this] ??= _EffectsSettings();

  rtc.MediaStreamTrack get _effectsTrack => mediaStream.getVideoTracks().first;

  Future<void> _update<T>(
    T value,
    Future<void> Function(rtc.MediaStreamTrack, T) apply,
    void Function(T) remember,
  ) => _settings.lock.synchronized(() async {
    await apply(_effectsTrack, value);
    remember(value);
  });

  Future<rtc.AuthStatus> _authenticate(_Authorize authorize) => _settings.lock.synchronized(() async {
    final status = await authorize(_effectsTrack);
    if (status == rtc.AuthStatus.active) _settings.authorize = authorize;
    return status;
  });

  /// Initializes Video Effects SDK for the web.
  ///
  /// Should be called before the first `LocalVideoTrack.createCameraTrack` call.
  /// For native platforms do nothing.
  /// - [customerID]: Unique customerID for authentication
  /// - [preload]: Start preloading models if true.
  /// - [config]: Optional Web SDK configuration.
  static void initialize(String customerID, {bool preload = false, rtc.VideoEffectSDKConfig? config}) {
    return rtc.VideoEffectsSdk.initialize(customerID, preload: preload, config: config);
  }

  /// Authenticates SDK using remote service (for Android & iOS).
  ///
  /// Method performs https request to obtain license for customerID.
  /// For the web, this method waits until models are loaded.
  /// - [customerID]: License key for authentication
  /// - [apiUrl]: Optional custom authentication api server url
  /// - Returns: [AuthStatus] indicating authentication result
  Future<rtc.AuthStatus> auth(String customerID, {String? apiUrl}) async {
    return _authenticate((track) => rtc.VideoEffectsSdk.auth(track, customerID, apiUrl: apiUrl));
  }

  /// Offline authorization with a secret key.
  ///
  /// Authorizes the Effects SDK instance similar to [auth], but performs license verification without web requests.
  /// Internet connection is not required.
  /// - [localKey]: Unique client's secret key. DO NOT reveal it.
  /// - Returns: [AuthStatus] indicating authentication result
  Future<rtc.AuthStatus> localAuth(String localKey) async {
    return _authenticate((track) => rtc.VideoEffectsSdk.localAuth(track, localKey));
  }

  /// Gets the current background processing mode for a media track.
  ///
  /// - Returns: Current [PipelineMode]
  Future<rtc.PipelineMode> getPipelineMode() async {
    return rtc.VideoEffectsSdk.getPipelineMode(_effectsTrack);
  }

  /// Sets background processing mode for a media track.
  ///
  /// - [mode]: New processing mode to apply
  Future<void> setPipelineMode(rtc.PipelineMode mode) {
    return _update(mode, rtc.VideoEffectsSdk.setPipelineMode, (value) => _settings.pipelineMode = value);
  }

  /// Adjusts blur strength for background blur mode.
  ///
  /// - [blurPower]: Blur strength (0.0 - 1.0)
  Future<void> setBlurPower(double blurPower) {
    return _update(blurPower, rtc.VideoEffectsSdk.setBlurPower, (value) => _settings.blurPower = value);
  }

  /// Sets custom background image for replace mode.
  ///
  /// Has effect only for replace mode.
  /// - [image]: Image to use as background
  Future<void> setBackgroundImage(rtc.EffectsSdkImage image) {
    return _update(image, rtc.VideoEffectsSdk.setBackgroundImage, (value) => _settings.backgroundImage = value);
  }

  /// Enables/disables face beautification effects.
  ///
  /// Improves the appearance of the human face.
  Future<void> enableBeautification(bool enable) {
    return _update(
      enable,
      rtc.VideoEffectsSdk.enableBeautification,
      (value) => _settings.beautificationEnabled = value,
    );
  }

  /// Checks if beautification is currently enabled.
  ///
  /// - Returns: Current enabled status
  Future<bool> isBeautificationEnabled() {
    return rtc.VideoEffectsSdk.isBeautificationEnabled(_effectsTrack);
  }

  /// Adjusts beautification effect strength.
  ///
  /// - [power]: Effect strength (0.0 - 1.0)
  Future<void> setBeautificationPower(double power) {
    return _update(power, rtc.VideoEffectsSdk.setBeautificationPower, (value) => _settings.beautificationPower = value);
  }

  /// Gets current smart zoom level.
  ///
  /// - Returns: Current zoom level
  Future<double> getZoomLevel() {
    return rtc.VideoEffectsSdk.getZoomLevel(_effectsTrack);
  }

  /// Sets smart zoom level.
  ///
  /// When level > 0, crops around the face, 1 means that the face is zoomed into the entire frame.
  /// - [zoomLevel]: zoomLevel (0 - 1)
  Future<void> setZoomLevel(double zoomLevel) {
    return _update(zoomLevel, rtc.VideoEffectsSdk.setZoomLevel, (value) => _settings.zoomLevel = value);
  }

  /// Enables/disables image sharpening.
  ///
  /// Sharpening makes the video look better by enhancing its clarity.
  /// It reduces blurriness in the video.
  /// - [enable]: true to enable, false to disable
  Future<void> enableSharpening(bool enable) {
    return _update(enable, rtc.VideoEffectsSdk.enableSharpening, (value) => _settings.sharpeningEnabled = value);
  }

  /// Gets current sharpening strength.
  ///
  /// - Returns: Current sharpening strength (0.0 - 1.0)
  Future<double> getSharpeningStrength() {
    return rtc.VideoEffectsSdk.getSharpeningStrength(_effectsTrack);
  }

  /// Adjusts image sharpening strength.
  ///
  /// - [strength]: New sharpening strength (0.0 - 1.0), 0 is minimal sharpening (there is still visible effect), 1 maximal
  Future<void> setSharpeningStrength(double strength) {
    return _update(
      strength,
      rtc.VideoEffectsSdk.setSharpeningStrength,
      (value) => _settings.sharpeningStrength = value,
    );
  }

  /// Sets color correction processing mode.
  ///
  /// - [colorCorrectionMode]: New color processing mode
  Future<void> setColorCorrectionMode(rtc.ColorCorrectionMode colorCorrectionMode) {
    return _update(
      colorCorrectionMode,
      rtc.VideoEffectsSdk.setColorCorrectionMode,
      (value) => _settings.colorCorrectionMode = value,
    );
  }

  /// Adjusts color filter strength.
  ///
  /// - [strength]: Filter intensity (0.0 - 1.0)
  Future<void> setColorFilterStrength(double strength) {
    return _update(
      strength,
      rtc.VideoEffectsSdk.setColorFilterStrength,
      (value) => _settings.colorFilterStrength = value,
    );
  }

  /// Sets reference image for color grading mode.
  ///
  /// - [reference]: Reference image for color matching
  Future<void> setColorGradingReference(rtc.EffectsSdkImage reference) {
    return _update(
      reference,
      rtc.VideoEffectsSdk.setColorGradingReference,
      (value) => _settings.colorGradingReference = value,
    );
  }

  /// Enables/disables video noise suppression.
  ///
  /// - [enable]: true to enable, false to disable
  Future<void> enableNoiseSuppression(bool enable) {
    return _update(
      enable,
      rtc.VideoEffectsSdk.enableNoiseSuppression,
      (value) => _settings.noiseSuppressionEnabled = value,
    );
  }

  /// Enables/disables portrait lighting effect.
  ///
  /// - [enable]: true to enable, false to disable
  Future<void> enablePortraitLighting(bool enable) {
    return _update(
      enable,
      rtc.VideoEffectsSdk.enablePortraitLighting,
      (value) => _settings.portraitLightingEnabled = value,
    );
  }

  /// Sets portrait lighting effect options.
  ///
  /// - [options]: New portrait lighting options
  Future<void> setPortraitLightingOptions(rtc.PortraitLightingOptions options) {
    return _update(options, rtc.VideoEffectsSdk.setPortraitLightingOptions, (value) {
      final previous = _settings.portraitLightingOptions;
      _settings.portraitLightingOptions = rtc.PortraitLightingOptions(
        lightStrength: value.lightStrength ?? previous?.lightStrength,
        backgroundDarkness: value.backgroundDarkness ?? previous?.backgroundDarkness,
      );
    });
  }

  /// Sets color correction configuration.
  ///
  /// Applied in [rtc.ColorCorrectionMode.colorCorrectionMode].
  /// - [config]: New color correction configuration
  Future<void> setColorCorrectionConfig(rtc.ColorCorrectionConfig config) {
    return _update(config, rtc.VideoEffectsSdk.setColorCorrectionConfig, (value) {
      final previous = _settings.colorCorrectionConfig;
      _settings.colorCorrectionConfig = rtc.ColorCorrectionConfig(
        autoMode: value.autoMode ?? previous?.autoMode,
        whiteBalance: value.whiteBalance ?? previous?.whiteBalance,
        exposure: value.exposure ?? previous?.exposure,
        temperature: value.temperature ?? previous?.temperature,
        tint: value.tint ?? previous?.tint,
        vibrance: value.vibrance ?? previous?.vibrance,
        contrast: value.contrast ?? previous?.contrast,
        updatePeriodMs: value.updatePeriodMs ?? previous?.updatePeriodMs,
      );
    });
  }
}

@internal
Future<void> restoreVideoEffects(LocalVideoTrack video, rtc.MediaStreamTrack track) async {
  final settings = _settingsByTrack[video];
  if (settings == null) return;
  await settings.lock.synchronized(() async {
    final authorize = settings.authorize;
    if (authorize != null) {
      final status = await authorize(track);
      if (status != rtc.AuthStatus.active) {
        throw StateError('Video Effects SDK authorization failed: ${status.name}');
      }
    }
    if (settings.blurPower case final value?) {
      await rtc.VideoEffectsSdk.setBlurPower(track, value);
    }
    if (settings.backgroundImage case final value?) {
      await rtc.VideoEffectsSdk.setBackgroundImage(track, value);
    }
    if (settings.beautificationPower case final value?) {
      await rtc.VideoEffectsSdk.setBeautificationPower(track, value);
    }
    if (settings.zoomLevel case final value?) {
      await rtc.VideoEffectsSdk.setZoomLevel(track, value);
    }
    if (settings.sharpeningStrength case final value?) {
      await rtc.VideoEffectsSdk.setSharpeningStrength(track, value);
    }
    if (settings.colorFilterStrength case final value?) {
      await rtc.VideoEffectsSdk.setColorFilterStrength(track, value);
    }
    if (settings.colorGradingReference case final value?) {
      await rtc.VideoEffectsSdk.setColorGradingReference(track, value);
    }
    if (settings.portraitLightingOptions case final value?) {
      await rtc.VideoEffectsSdk.setPortraitLightingOptions(track, value);
    }
    if (settings.colorCorrectionConfig case final value?) {
      await rtc.VideoEffectsSdk.setColorCorrectionConfig(track, value);
    }
    if (settings.pipelineMode case final value?) {
      await rtc.VideoEffectsSdk.setPipelineMode(track, value);
    }
    if (settings.beautificationEnabled case final value?) {
      await rtc.VideoEffectsSdk.enableBeautification(track, value);
    }
    if (settings.sharpeningEnabled case final value?) {
      await rtc.VideoEffectsSdk.enableSharpening(track, value);
    }
    if (settings.colorCorrectionMode case final value?) {
      await rtc.VideoEffectsSdk.setColorCorrectionMode(track, value);
    }
    if (settings.noiseSuppressionEnabled case final value?) {
      await rtc.VideoEffectsSdk.enableNoiseSuppression(track, value);
    }
    if (settings.portraitLightingEnabled case final value?) {
      await rtc.VideoEffectsSdk.enablePortraitLighting(track, value);
    }
  });
}
