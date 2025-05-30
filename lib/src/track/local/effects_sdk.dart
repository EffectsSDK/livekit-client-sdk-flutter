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
import 'video.dart';

/// Video Effects SDK extensions to enable/disable SDK's filters
extension VideoEffectsSDKExt on LocalVideoTrack {
  
  /// Authenticates SDK using remote service.
  ///
  /// Method performs https request to obtain license for customerID.
  /// - [customerID]: License key for authentication
  /// - [apiUrl]: Optional custom authentication api server url
  /// - Returns: [AuthStatus] indicating authentication result
  Future<rtc.AuthStatus> auth(String customerID, {String? apiUrl}) async {
    return rtc.VideoEffectsSdk.auth(mediaStreamTrack, customerID, apiUrl:apiUrl);
  }

  /// Offline authorization with a secret key.
  /// 
  /// Authorizes the Effects SDK instance similar to [auth], but performs license verification without web requests. 
  /// Internet connection is not required.
  /// - [localKey]: Unique client’s secret key. DO NOT reveal it.
  /// - Returns: [AuthStatus] indicating authentication result
  Future<rtc.AuthStatus> localAuth(String localKey) async {
    return rtc.VideoEffectsSdk.localAuth(mediaStreamTrack, localKey);
  }

  /// Gets the current background processing mode for a media track.
  ///
  /// - Returns: Current [PipelineMode]
  Future<rtc.PipelineMode> getPipelineMode() async {
    return rtc.VideoEffectsSdk.getPipelineMode(mediaStreamTrack);
  }

  /// Sets background processing mode for a media track.
  /// 
  /// - [pipelineMode]: New processing mode to apply
  Future<void> setPipelineMode(rtc.PipelineMode mode) {
    return rtc.VideoEffectsSdk.setPipelineMode(mediaStreamTrack, mode);
  }

  /// Adjusts blur strength for background blur mode.
  ///
  /// - [blurPower]: Blur strength (0.0 - 1.0)
  Future<void> setBlurPower(double blurPower) {
    return rtc.VideoEffectsSdk.setBlurPower(mediaStreamTrack, blurPower);
  }

  /// Sets custom background image for replace mode.
  ///
  /// Has effect only for replace mode.
  /// - [image]: Image to use as background
  Future<void> setBackgroundImage(rtc.EffectsSdkImage image) {
    return rtc.VideoEffectsSdk.setBackgroundImage(mediaStreamTrack, image);
  }

  /// Enables/disables face beautification effects.
  /// 
  /// Improves the appearance of the human face.
  Future<void> enableBeautification(bool enable) {
    return rtc.VideoEffectsSdk.enableBeautification(mediaStreamTrack, enable);
  }

  /// Checks if beautification is currently enabled.
  ///
  /// - Returns: Current enabled status
  Future<bool> isBeautificationEnabled() {
    return rtc.VideoEffectsSdk.isBeautificationEnabled(mediaStreamTrack);
  }

  /// Adjusts beautification effect strength.
  ///
  /// - [power]: Effect strength (0.0 - 1.0)
  Future<void> setBeautificationPower(double power) {
    return rtc.VideoEffectsSdk.setBeautificationPower(mediaStreamTrack, power);
  }

  /// Gets current smart zoom level.
  ///
  /// - Returns: Current zoom level 
  Future<double> getZoomLevel() {
    return rtc.VideoEffectsSdk.getZoomLevel(mediaStreamTrack);
  }

  /// Sets smart zoom level.
  ///
  /// When level > 0, crops around the face, 1 means that the face is zoomed into the entire frame.
  /// - [zoomLevel]: zoomLevel (0 - 1)
  Future<void> setZoomLevel(double zoomLevel) {
    return rtc.VideoEffectsSdk.setZoomLevel(mediaStreamTrack, zoomLevel);
  }

  /// Enables/disables image sharpening.
  ///
  /// Sharpening makes the video look better by enhancing its clarity. 
  /// It reduces blurriness in the video.
  /// - [enable]: true to enable, false to disable
  Future<void> enableSharpening(bool enable) {
    return rtc.VideoEffectsSdk.enableSharpening(mediaStreamTrack, enable);
  }

  /// Gets current sharpening strength.
  ///
  /// - Returns: Current sharpening strength (0.0 - 1.0)
  Future<double> getSharpeningStrength() {
    return rtc.VideoEffectsSdk.getSharpeningStrength(mediaStreamTrack);
  }

  /// Adjusts image sharpening strength.
  ///
  /// - [strength]: New sharpening strength (0.0 - 1.0), 0 is minimal sharpening (there is still visible effect), 1 maximal
  Future<void> setSharpeningStrength(double strength) {
    return rtc.VideoEffectsSdk.setSharpeningStrength(mediaStreamTrack, strength);
  }

  /// Sets color correction processing mode.
  ///
  /// - [colorCorrectionMode]: New color processing mode
  Future<void> setColorCorrectionMode(rtc.ColorCorrectionMode colorCorrectionMode) {
    return rtc.VideoEffectsSdk.setColorCorrectionMode(
        mediaStreamTrack,
        colorCorrectionMode
    );
  }

  /// Adjusts color filter strength.
  ///
  /// - [strength]: Filter intensity (0.0 - 1.0)
  Future<void> setColorFilterStrength(double strength) {
    return rtc.VideoEffectsSdk.setColorFilterStrength(mediaStreamTrack, strength);
  }

  /// Sets reference image for color grading mode.
  ///
  /// - [reference]: Reference image for color matching
  Future<void> setColorGradingReference(rtc.EffectsSdkImage reference) {
    return rtc.VideoEffectsSdk.setColorGradingReference(mediaStreamTrack, reference);
  }
}
