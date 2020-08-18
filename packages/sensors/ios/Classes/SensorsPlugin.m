// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "SensorsPlugin.h"
#import <CoreMotion/CoreMotion.h>

@implementation FLTSensorsPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FLTAccelerometerStreamHandler* accelerometerStreamHandler =
      [[FLTAccelerometerStreamHandler alloc] init];
  FlutterEventChannel* accelerometerChannel =
      [FlutterEventChannel eventChannelWithName:@"plugins.flutter.io/sensors/accelerometer"
                                binaryMessenger:[registrar messenger]];
  [accelerometerChannel setStreamHandler:accelerometerStreamHandler];

  FLTUserAccelStreamHandler* userAccelerometerStreamHandler =
      [[FLTUserAccelStreamHandler alloc] init];
  FlutterEventChannel* userAccelerometerChannel =
      [FlutterEventChannel eventChannelWithName:@"plugins.flutter.io/sensors/user_accel"
                                binaryMessenger:[registrar messenger]];
  [userAccelerometerChannel setStreamHandler:userAccelerometerStreamHandler];

  FLTGyroscopeStreamHandler* gyroscopeStreamHandler = [[FLTGyroscopeStreamHandler alloc] init];
  FlutterEventChannel* gyroscopeChannel =
      [FlutterEventChannel eventChannelWithName:@"plugins.flutter.io/sensors/gyroscope"
                                binaryMessenger:[registrar messenger]];
  [gyroscopeChannel setStreamHandler:gyroscopeStreamHandler];

  FLTAccelerometerUncalibratedStreamHandler* accelerometerUncalibratedStreamHandler =
    [[FLTAccelerometerUncalibratedStreamHandler alloc] init];
  FlutterEventChannel* accelerometerUncalibratedChannel =
    [FlutterEventChannel eventChannelWithName:@"plugins.flutter.io/sensors/acclerometer_uncalibrated"
                                binaryMessenger:[registrar messenger]];
 [accelerometerUncalibratedChannel setStreamHandler:accelerometerUncalibratedStreamHandler];
 
  FLTGravityStreamHandler* gravityStreamHandler =
      [[FLTGravityStreamHandler alloc] init];
  FlutterEventChannel* gravityChannel =
      [FlutterEventChannel eventChannelWithName:@"plugins.flutter.io/sensors/gravity"
                                binaryMessenger:[registrar messenger]];
  [gravityChannel setStreamHandler:gravityStreamHandler];

  FLTGyroscopeUncalibratedStreamHandler* gyroscopeUncalibratedStreamHandler =
      [[FLTGyroscopeUncalibratedStreamHandler alloc] init];
  FlutterEventChannel* gyroscopeUncalibratedChannel =
      [FlutterEventChannel eventChannelWithName:@"plugins.flutter.io/sensors/gyroscope_uncalibrated"
                                binaryMessenger:[registrar messenger]];
  [gyroscopeUncalibratedChannel setStreamHandler:gyroscopeUncalibratedStreamHandler];

  FLTRotationVectorStreamHandler* rotationVectorStreamHandler =
      [[FLTRotationVectorStreamHandler alloc] init];
  FlutterEventChannel* rotationVectorChannel =
      [FlutterEventChannel eventChannelWithName:@"plugins.flutter.io/sensors/rotation_vector"
                                binaryMessenger:[registrar messenger]];
  [rotationVectorChannel setStreamHandler:rotationVectorStreamHandler];

  FLTGameRotationVectorStreamHandler* gameRotationVectorStreamHandler =
      [[FLTGameRotationVectorStreamHandler alloc] init];
  FlutterEventChannel* gameRotationVectorChannel =
      [FlutterEventChannel eventChannelWithName:@"plugins.flutter.io/sensors/game_rotation_vector"
                                binaryMessenger:[registrar messenger]];
  [gameRotationVectorChannel setStreamHandler:gameRotationVectorStreamHandler];

  FLTMagneticFieldStreamHandler* magneticFieldStreamHandler =
      [[FLTMagneticFieldStreamHandler alloc] init];
  FlutterEventChannel* magneticFieldChannel =
      [FlutterEventChannel eventChannelWithName:@"plugins.flutter.io/sensors/magnetic_field"
                                binaryMessenger:[registrar messenger]];
  [magneticFieldChannel setStreamHandler:magneticFieldStreamHandler];

  FLTMagneticFieldUncalibratedStreamHandler* magneticFieldUncalibratedStreamHandler =
      [[FLTMagneticFieldUncalibratedStreamHandler alloc] init];
  FlutterEventChannel* magneticFieldUncalibratedChannel =
      [FlutterEventChannel eventChannelWithName:@"plugins.flutter.io/sensors/magnetic_field_uncalibrated"
                                binaryMessenger:[registrar messenger]];
  [magneticFieldUncalibratedChannel setStreamHandler:magneticFieldUncalibratedStreamHandler];

  FLTRotationMatrixStreamHandler* rotationMatrixStreamHandler =
      [[FLTRotationMatrixStreamHandler alloc] init];
  FlutterEventChannel* rotationMatrixChannel =
      [FlutterEventChannel eventChannelWithName:@"plugins.flutter.io/sensors/rotation_matrix"
                                binaryMessenger:[registrar messenger]];
  [rotationMatrixChannel setStreamHandler:rotationMatrixStreamHandler];

  FLTQuaternionStreamHandler* quaternionStreamHandler =
      [[FLTQuaternionStreamHandler alloc] init];
  FlutterEventChannel* quaternionChannel =
      [FlutterEventChannel eventChannelWithName:@"plugins.flutter.io/sensors/quaternion"
                                binaryMessenger:[registrar messenger]];
  [quaternionChannel setStreamHandler:quaternionStreamHandler];

  FLTOrientationStreamHandler* orientationStreamHandler =
      [[FLTOrientationStreamHandler alloc] init];
  FlutterEventChannel* orientationChannel =
      [FlutterEventChannel eventChannelWithName:@"plugins.flutter.io/sensors/orientation"
                                binaryMessenger:[registrar messenger]];
  [orientationChannel setStreamHandler:orientationStreamHandler];
}

@end

const double GRAVITY = 9.81;
CMMotionManager* _motionManager;
NSOperationQueue* _accelerometerQueue;
int _accelerometerQueueNum;
NSOperationQueue* _deviceMotionQueue;
int _deviceMotionQueueNum;
NSOperationQueue* _gyroscopeQueue;
int _gyroscopeQueueNum;
NSOperationQueue* _magnetometerQueue;
int _magnetometerQueueNum;

NSTimeInterval _offset;
NSTimeInterval _timestampToEpoch(double timestampFromBoot) {
  if(!_offset) {
    _offset = [[NSDate date] timeIntervalSince1970] - [NSProcessInfo processInfo].systemUptime;
  }
  return timestampFromBoot + _offset;
}

void _initMotionManager() {
  if (!_motionManager) {
    _motionManager = [[CMMotionManager alloc] init];
  }
}

void _initAccelometerQueue() {
  if(!_accelerometerQueue) {
    _accelerometerQueue = [[NSOperationQueue alloc] init];
    _accelerometerQueueNum = 0;
  }
  ++_accelerometerQueueNum;
}

void _initDeviceMotionQueue() {
  if(!_deviceMotionQueue) {
    _deviceMotionQueue = [[NSOperationQueue alloc] init];
    _deviceMotionQueueNum = 0;
  }
  ++_deviceMotionQueueNum;
}

void _initGyroscopeQueue() {
  if(!_gyroscopeQueue) {
    _gyroscopeQueue = [[NSOperationQueue alloc] init];
    _gyroscopeQueueNum = 0;
  }
  ++_gyroscopeQueueNum;
}

void _initMagnetometerQueue() {
  if(!_magnetometerQueue) {
    _magnetometerQueue = [[NSOperationQueue alloc] init];
    _magnetometerQueueNum = 0;
  }
  ++_magnetometerQueueNum;
}

static void sendTriplet(FlutterEventSink sink, long millisecondsEpoch, double x, double y, double z) {
  NSArray*  array = [NSArray arrayWithObjects:
    [NSNumber numberWithLong: millisecondsEpoch],
    [NSNumber numberWithDouble: x],
    [NSNumber numberWithDouble: y],
    [NSNumber numberWithDouble: z],
    nil
  ];
  sink(array);
}

static void sendQuartet(FlutterEventSink sink, long millisecondsEpoch, double w, double x, double y, double z) {
  NSArray*  array = [NSArray arrayWithObjects:
    [NSNumber numberWithLong: millisecondsEpoch],
    [NSNumber numberWithDouble: w],
    [NSNumber numberWithDouble: x],
    [NSNumber numberWithDouble: y],
    [NSNumber numberWithDouble: z],
    nil
  ];
  sink(array);
}

static void sendSextet(FlutterEventSink sink, long millisecondsEpoch, double x, double y, double z, double rx, double ry, double rz) {
  NSArray*  array = [NSArray arrayWithObjects:
    [NSNumber numberWithLong: millisecondsEpoch],
    [NSNumber numberWithDouble: x],
    [NSNumber numberWithDouble: y],
    [NSNumber numberWithDouble: z],
    [NSNumber numberWithDouble: rx],
    [NSNumber numberWithDouble: ry],
    [NSNumber numberWithDouble: rz],
    nil
  ];
  sink(array);
}

static void sendMatrix(FlutterEventSink sink, long millisecondsEpoch, double m11, double m12, double m13, double m21, double m22, double m23, double m31, double m32, double m33) {
  NSArray*  array = [NSArray arrayWithObjects:
    [NSNumber numberWithLong: millisecondsEpoch],
    [NSNumber numberWithDouble: m11],
    [NSNumber numberWithDouble: m12],
    [NSNumber numberWithDouble: m13],
    [NSNumber numberWithDouble: m21],
    [NSNumber numberWithDouble: m22],
    [NSNumber numberWithDouble: m23],
    [NSNumber numberWithDouble: m31],
    [NSNumber numberWithDouble: m32],
    [NSNumber numberWithDouble: m33],
    nil
  ];
  sink(array);
}

@implementation FLTAccelerometerStreamHandler

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
  _initMotionManager();
  _motionManager.accelerometerUpdateInterval = (float)1 / [arguments integerValue];
  _initAccelometerQueue();
  [_motionManager
      startAccelerometerUpdatesToQueue: [[NSOperationQueue alloc]init]// _accelerometerQueue
                           withHandler:^(CMAccelerometerData* data, NSError* error) {
                             double secondsEpoch = _timestampToEpoch(data.timestamp);
                             CMAcceleration acceleration = data.acceleration;
                             // Multiply by gravity, and adjust sign values to
                             // align with Android.
                             sendTriplet(eventSink, (long) secondsEpoch * 1000, -acceleration.x * GRAVITY, -acceleration.y * GRAVITY,
                                         -acceleration.z * GRAVITY);
                           }];
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  if(--_accelerometerQueueNum == 0) {
    [_motionManager stopAccelerometerUpdates];
  }
  return nil;
}

@end

@implementation FLTUserAccelStreamHandler

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
  _initMotionManager();
  _motionManager.deviceMotionUpdateInterval = (float)1 / [arguments integerValue];
  _initDeviceMotionQueue();
  [_motionManager
      startDeviceMotionUpdatesUsingReferenceFrame: CMAttitudeReferenceFrameXArbitraryCorrectedZVertical
                          toQueue:[[NSOperationQueue alloc]init]//_deviceMotionQueue
                          withHandler:^(CMDeviceMotion* data, NSError* error) {
                            double secondsEpoch = _timestampToEpoch(data.timestamp);
                            CMAcceleration acceleration = data.userAcceleration;
                            // Multiply by gravity, and adjust sign values to align with Android.
                             sendTriplet(eventSink, (long) secondsEpoch * 1000, -acceleration.x * GRAVITY, -acceleration.y * GRAVITY,
                                       -acceleration.z * GRAVITY);
                          }];
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  if(--_deviceMotionQueueNum == 0) {
    [_motionManager stopDeviceMotionUpdates];
  }
  return nil;
}

@end

@implementation FLTGyroscopeStreamHandler

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
  _initMotionManager();
  _motionManager.gyroUpdateInterval = (float)1 / [arguments integerValue];
  _initGyroscopeQueue();
  [_motionManager
      startGyroUpdatesToQueue:[[NSOperationQueue alloc]init]//_gyroscopeQueue
                  withHandler:^(CMGyroData* data, NSError* error) {
                    double secondsEpoch = _timestampToEpoch(data.timestamp);
                    CMRotationRate rotationRate = data.rotationRate;
                    sendTriplet(eventSink, (long) secondsEpoch * 1000, rotationRate.x, rotationRate.y, rotationRate.z);
                  }];
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  if(--_gyroscopeQueueNum == 0) {
    [_motionManager stopGyroUpdates];
  }
  return nil;
}

@end

@implementation FLTAccelerometerUncalibratedStreamHandler

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
  _initMotionManager();
  _motionManager.accelerometerUpdateInterval = (float)1 / [arguments integerValue];
  _initAccelometerQueue();
  [_motionManager 
      startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc]init]//_accelerometerQueue
                           withHandler:^(CMAccelerometerData* data, NSError* error) {
                             double secondsEpoch = _timestampToEpoch(data.timestamp);
                             CMAcceleration acceleration = data.acceleration;
                             // Multiply by gravity, and adjust sign values to
                             // align with Android.
                             sendSextet(eventSink, (long) secondsEpoch * 1000, -acceleration.x * GRAVITY, -acceleration.y * GRAVITY,
                                         -acceleration.z * GRAVITY, 0.0, 0.0, 0.0);
                           }];
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  if(--_accelerometerQueueNum == 0) {
    [_motionManager stopAccelerometerUpdates];
  }
  return nil;
}

@end

@implementation FLTGravityStreamHandler

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
  _initMotionManager();
  _motionManager.accelerometerUpdateInterval = (float)1 / [arguments integerValue];
  _initDeviceMotionQueue();
  [_motionManager
      startDeviceMotionUpdatesUsingReferenceFrame: CMAttitudeReferenceFrameXArbitraryCorrectedZVertical
                          toQueue:[[NSOperationQueue alloc]init]//_deviceMotionQueue
                          withHandler:^(CMDeviceMotion* data, NSError* error) {
                            double secondsEpoch = _timestampToEpoch(data.timestamp);
                            CMAcceleration gravity = data.gravity;
                            // Multiply by gravity, and adjust sign values to align with Android.
                             sendTriplet(eventSink, (long) secondsEpoch * 1000, -gravity.x * GRAVITY, -gravity.y * GRAVITY,
                                         -gravity.z * GRAVITY);
                          }];
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  if(--_deviceMotionQueueNum == 0) {
    [_motionManager stopAccelerometerUpdates];
  }
  return nil;
}

@end

@implementation FLTGyroscopeUncalibratedStreamHandler

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
  _initMotionManager();
  _motionManager.gyroUpdateInterval = (float)1 / [arguments integerValue];
  _initGyroscopeQueue();
  [_motionManager
      startGyroUpdatesToQueue:[[NSOperationQueue alloc]init]//_gyroscopeQueue
                  withHandler:^(CMGyroData* data, NSError* error) {
                    double secondsEpoch = _timestampToEpoch(data.timestamp);
                    CMRotationRate rotationRate = data.rotationRate;
                    sendSextet(eventSink, (long) secondsEpoch * 1000, rotationRate.x, rotationRate.y, rotationRate.z,
                      0.0, 0.0, 0.0);
                  }];
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  if(--_gyroscopeQueueNum == 0) {
    [_motionManager stopGyroUpdates];
  }
  return nil;
}

@end

@implementation FLTRotationVectorStreamHandler

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
  _initMotionManager();
  _motionManager.deviceMotionUpdateInterval = (float)1 / [arguments integerValue];
  _initDeviceMotionQueue();
  [_motionManager
      startDeviceMotionUpdatesUsingReferenceFrame: CMAttitudeReferenceFrameXArbitraryCorrectedZVertical
                          toQueue:[[NSOperationQueue alloc]init]//_deviceMotionQueue
                          withHandler:^(CMDeviceMotion* data, NSError* error) {
                            double secondsEpoch = _timestampToEpoch(data.timestamp);
                            CMQuaternion quad = data.attitude.quaternion;
                            sendQuartet(eventSink, (long) secondsEpoch * 1000, quad.w, quad.x, quad.y, quad.z);
                          }];
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  if(--_deviceMotionQueueNum == 0) {
    [_motionManager stopDeviceMotionUpdates];
  }
  return nil;
}

@end

@implementation FLTGameRotationVectorStreamHandler

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
  _initMotionManager();
  _motionManager.deviceMotionUpdateInterval = (float)1 / [arguments integerValue];
  _initDeviceMotionQueue();
  [_motionManager
      startDeviceMotionUpdatesUsingReferenceFrame: CMAttitudeReferenceFrameXArbitraryCorrectedZVertical
                          toQueue:[[NSOperationQueue alloc]init]//_deviceMotionQueue
                          withHandler:^(CMDeviceMotion* data, NSError* error) {
                            double secondsEpoch = _timestampToEpoch(data.timestamp);
                            CMQuaternion quad = data.attitude.quaternion;
                            sendTriplet(eventSink, (long) secondsEpoch * 1000, quad.x, quad.y, quad.z);
                          }];
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  if(--_deviceMotionQueueNum == 0) {
    [_motionManager stopDeviceMotionUpdates];
  }
  return nil;
}

@end

@implementation FLTMagneticFieldStreamHandler

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
  _initMotionManager();
  _motionManager.deviceMotionUpdateInterval = (float)1 / [arguments integerValue];
  _initDeviceMotionQueue();
  [_motionManager
      startDeviceMotionUpdatesUsingReferenceFrame: CMAttitudeReferenceFrameXArbitraryCorrectedZVertical
                          toQueue:[[NSOperationQueue alloc]init]//_deviceMotionQueue
                          withHandler:^(CMDeviceMotion* data, NSError* error) {
                            double secondsEpoch = _timestampToEpoch(data.timestamp);
                            CMMagneticField mag = data.magneticField.field;
                            sendTriplet(eventSink, (long) secondsEpoch * 1000, mag.x, mag.y, mag.z);
                          }];
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  if(--_deviceMotionQueueNum == 0) {
    [_motionManager stopDeviceMotionUpdates];
  }
  return nil;
}

@end

@implementation FLTMagneticFieldUncalibratedStreamHandler

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
  _initMotionManager();
  _motionManager.deviceMotionUpdateInterval = (float)1 / [arguments integerValue];
  _initMagnetometerQueue();
  [_motionManager
      startMagnetometerUpdatesToQueue: [[NSOperationQueue alloc]init]//_magnetometerQueue
                          withHandler:^(CMMagnetometerData* data, NSError* error) {
                            double secondsEpoch = _timestampToEpoch(data.timestamp);
                            CMMagneticField mag = data.magneticField;
                            sendSextet(eventSink, (long) secondsEpoch * 1000, mag.x, mag.y, mag.z,
                              0.0, 0.0, 0.0);
                          }];
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  if(--_magnetometerQueueNum == 0) {
    [_motionManager stopMagnetometerUpdates];
  }
  return nil;
}

@end

@implementation FLTRotationMatrixStreamHandler

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
  _initMotionManager();
  _motionManager.deviceMotionUpdateInterval = (float)1 / [arguments integerValue];
  _initDeviceMotionQueue();
  [_motionManager
      startDeviceMotionUpdatesUsingReferenceFrame: CMAttitudeReferenceFrameXArbitraryCorrectedZVertical
                          toQueue:[[NSOperationQueue alloc]init]//_deviceMotionQueue
                          withHandler:^(CMDeviceMotion* data, NSError* error) {
                            double secondsEpoch = _timestampToEpoch(data.timestamp);
                            CMRotationMatrix mat = data.attitude.rotationMatrix;
                            sendMatrix(eventSink, (long) secondsEpoch * 1000,
                              mat.m11, mat.m12, mat.m13, mat.m21, mat.m22, mat.m23, mat.m31, mat.m32, mat.m33
                            );
                          }];
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  if(--_deviceMotionQueueNum == 0) {
    [_motionManager stopDeviceMotionUpdates];
  }
  return nil;
}

@end

@implementation FLTQuaternionStreamHandler

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
  _initMotionManager();
  _motionManager.deviceMotionUpdateInterval = (float)1 / [arguments integerValue];
  _initDeviceMotionQueue();
  [_motionManager
      startDeviceMotionUpdatesUsingReferenceFrame: CMAttitudeReferenceFrameXArbitraryCorrectedZVertical
                          toQueue:[[NSOperationQueue alloc]init]//_deviceMotionQueue
                          withHandler:^(CMDeviceMotion* data, NSError* error) {
                            double secondsEpoch = _timestampToEpoch(data.timestamp);
                            CMQuaternion quad = data.attitude.quaternion;
                            sendQuartet(eventSink, (long) secondsEpoch * 1000, quad.w, quad.x, quad.y, quad.z);
                          }];
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  if(--_deviceMotionQueueNum == 0) {
    [_motionManager stopDeviceMotionUpdates];
  }
  return nil;
}

@end

@implementation FLTOrientationStreamHandler

- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
  _initMotionManager();
  _motionManager.deviceMotionUpdateInterval = (float)1 / [arguments integerValue];
  _initDeviceMotionQueue();
  [_motionManager
      startDeviceMotionUpdatesUsingReferenceFrame: CMAttitudeReferenceFrameXArbitraryCorrectedZVertical
                          toQueue:[[NSOperationQueue alloc]init]//_deviceMotionQueue
                          withHandler:^(CMDeviceMotion* data, NSError* error) {
                            double secondsEpoch = _timestampToEpoch(data.timestamp);
                            CMAttitude* attitude = data.attitude;
                            sendTriplet(eventSink, (long) secondsEpoch * 1000, attitude.roll, attitude.pitch, attitude.yaw);
                          }];
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
  if(--_deviceMotionQueueNum == 0) {
    [_motionManager stopDeviceMotionUpdates];
  }
  return nil;
}

@end
