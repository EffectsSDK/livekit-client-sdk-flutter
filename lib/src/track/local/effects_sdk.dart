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

import 'package:flutter/foundation.dart';

import 'package:flutter_webrtc/flutter_webrtc.dart' as rtc;
import 'video.dart';

//
// Video Effects SDK extensions to enable/disable SDK's filters
//
extension VideoEffectsSDKExt on LocalVideoTrack {
  /**
      Effects SDK get\set extension. Use it to control effects SDK options
   */
  Future<rtc.AuthStatus> auth(String customerID, {String? apiUrl}) async {
    return rtc.Helper.auth(mediaStreamTrack, customerID, apiUrl:apiUrl);
  }

  Future<rtc.AuthStatus> localAuth(String localKey) async {
    return rtc.Helper.localAuth(mediaStreamTrack, localKey);;
  }

  Future<rtc.PipelineMode> getPipelineMode() async {
    return rtc.Helper.getEffectsSdkPipelineMode(mediaStreamTrack);
  }

  Future<void> setPipelineMode(rtc.PipelineMode mode) {
    return rtc.Helper.setEffectsSdkPipelineMode(mediaStreamTrack, mode);
  }

  Future<void> setBlurPower(double blurPower) {
    return rtc.Helper.setEffectsSdkBlurPower(mediaStreamTrack, blurPower);
  }

  Future<void> setBackgroundImage(rtc.EffectsSdkImage image) {
    return rtc.Helper.setEffectsSdkBackgroundImage(mediaStreamTrack, image);
  }

  Future<void> enableBeautification(bool enable) {
    return rtc.Helper.enableEffectsSdkBeautification(mediaStreamTrack, enable);
  }

  Future<bool> isBeautificationEnabled() {
    return rtc.Helper.isEffectsSdkBeautificationEnabled(mediaStreamTrack);
  }

  Future<void> setBeautificationPower(double power) {
    return rtc.Helper.setEffectsSdkBeautificationPower(mediaStreamTrack, power);
  }

  Future<double> getZoomLevel() {
    return rtc.Helper.getEffectsSdkZoomLevel(mediaStreamTrack);
  }

  Future<void> setZoomLevel(double zoomLevel) {
    return rtc.Helper.setEffectsSdkZoomLevel(mediaStreamTrack, zoomLevel);
  }

  Future<void> enableSharpening(bool enable) {
    return rtc.Helper.enableEffectsSdkSharpening(mediaStreamTrack, enable);
  }

  Future<double> getSharpeningStrength() {
    return rtc.Helper.getEffectsSdkSharpeningStrength(mediaStreamTrack);
  }

  Future<void> setSharpeningStrength(double strength) {
    return rtc.Helper.setEffectsSdkSharpeningStrength(mediaStreamTrack, strength);
  }

  Future<void> setColorCorrectionMode(rtc.ColorCorrectionMode colorCorrectionMode) {
    return rtc.Helper.setEffectsSdkColorCorrectionMode(
        mediaStreamTrack,
        colorCorrectionMode
    );
  }

  Future<void> setColorFilterStrength(double strength) {
    return rtc.Helper.setEffectsSdkColorFilterStrength(mediaStreamTrack, strength);
  }

  Future<void> setColorGradingReferenceImage(rtc.EffectsSdkImage reference) {
    return rtc.Helper.setEffectsSdkColorGradingReferenceImage(mediaStreamTrack, reference);
  }
}
