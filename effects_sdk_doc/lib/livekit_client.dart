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

/// Flutter Client SDK to LiveKit with Effects SDK extension.  
/// For original documentation [see](https://docs.livekit.io/reference/client-sdk-flutter/).
library livekit_client;

export 'src/track/local/effects_sdk.dart';

export 'package:flutter_webrtc/flutter_webrtc.dart' 
    show AuthStatus, EffectsSdkImage, RawImageFormat, PipelineMode, ColorCorrectionMode;
