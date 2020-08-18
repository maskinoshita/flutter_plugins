// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Flutter/Flutter.h>

@interface FLTSensorsPlugin : NSObject <FlutterPlugin>
@end

@interface FLTUserAccelStreamHandler : NSObject <FlutterStreamHandler>
@end

@interface FLTAccelerometerStreamHandler : NSObject <FlutterStreamHandler>
@end

@interface FLTGyroscopeStreamHandler : NSObject <FlutterStreamHandler>
@end

@interface FLTAccelerometerUncalibratedStreamHandler : NSObject <FlutterStreamHandler>
@end

@interface FLTGravityStreamHandler : NSObject<FlutterStreamHandler>
@end

@interface FLTGyroscopeUncalibratedStreamHandler : NSObject<FlutterStreamHandler>
@end

@interface FLTRotationVectorStreamHandler : NSObject<FlutterStreamHandler>
@end

@interface FLTGameRotationVectorStreamHandler : NSObject<FlutterStreamHandler>
@end

@interface FLTMagneticFieldStreamHandler : NSObject<FlutterStreamHandler>
@end

@interface FLTMagneticFieldUncalibratedStreamHandler : NSObject<FlutterStreamHandler>
@end

@interface FLTRotationMatrixStreamHandler : NSObject<FlutterStreamHandler>
@end

@interface FLTQuaternionStreamHandler : NSObject<FlutterStreamHandler>
@end

@interface FLTOrientationStreamHandler : NSObject<FlutterStreamHandler>
@end