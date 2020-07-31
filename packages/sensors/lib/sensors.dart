import 'dart:async';
import 'package:flutter/services.dart';

const EventChannel _accelerometerEventChannel =
    EventChannel('plugins.flutter.io/sensors/accelerometer');

const EventChannel _userAccelerometerEventChannel =
    EventChannel('plugins.flutter.io/sensors/user_accel');

const EventChannel _gyroscopeEventChannel =
    EventChannel('plugins.flutter.io/sensors/gyroscope');

class AccelerometerEvent {
  AccelerometerEvent(int tus, this.x, this.y, this.z)
      : t = DateTime.fromMillisecondsSinceEpoch(tus);

  /// creation time of sensor data
  final DateTime t;

  /// Acceleration force along the x axis (including gravity) measured in m/s^2.
  final double x;

  /// Acceleration force along the y axis (including gravity) measured in m/s^2.
  final double y;

  /// Acceleration force along the z axis (including gravity) measured in m/s^2.
  final double z;

  @override
  String toString() => '[AccelerometerEvent (x: $x, y: $y, z: $z)]';
}

class GyroscopeEvent {
  GyroscopeEvent(int tus, this.x, this.y, this.z)
      : t = DateTime.fromMillisecondsSinceEpoch(tus);

  /// creation time of sensor data
  final DateTime t;

  /// Rate of rotation around the x axis measured in rad/s.
  final double x;

  /// Rate of rotation around the y axis measured in rad/s.
  final double y;

  /// Rate of rotation around the z axis measured in rad/s.
  final double z;

  @override
  String toString() => '[GyroscopeEvent (x: $x, y: $y, z: $z)]';
}

class UserAccelerometerEvent {
  UserAccelerometerEvent(int tus, this.x, this.y, this.z)
      : t = DateTime.fromMillisecondsSinceEpoch(tus);

  /// creation time of sensor data
  final DateTime t;

  /// Acceleration force along the x axis (excluding gravity) measured in m/s^2.
  final double x;

  /// Acceleration force along the y axis (excluding gravity) measured in m/s^2.
  final double y;

  /// Acceleration force along the z axis (excluding gravity) measured in m/s^2.
  final double z;

  @override
  String toString() => '[UserAccelerometerEvent (x: $x, y: $y, z: $z)]';
}

Stream<AccelerometerEvent> _accelerometerEvents;
Stream<GyroscopeEvent> _gyroscopeEvents;
Stream<UserAccelerometerEvent> _userAccelerometerEvents;

final int _sampleRateDefault = 15;
int _sampleRate;

/// Set the specified sample rate if it is greater than zero.
void setSensorsSampleRate(int sampleRate) {
  _sampleRate = (sampleRate > 0) ? sampleRate : _sampleRate;
}

/// A broadcast stream of events from the device accelerometer.
Stream<AccelerometerEvent> get accelerometerEvents {
  if (_accelerometerEvents == null) {
    _accelerometerEvents = _accelerometerEventChannel
        .receiveBroadcastStream(_sampleRate ?? _sampleRateDefault)
        .map((dynamic event) =>
            AccelerometerEvent(event[0], event[1], event[2], event[3]));
  }
  return _accelerometerEvents;
}

/// A broadcast stream of events from the device gyroscope.
Stream<GyroscopeEvent> get gyroscopeEvents {
  if (_gyroscopeEvents == null) {
    _gyroscopeEvents = _gyroscopeEventChannel
        .receiveBroadcastStream(_sampleRate ?? _sampleRateDefault)
        .map((dynamic event) =>
            GyroscopeEvent(event[0], event[1], event[2], event[3]));
  }
  return _gyroscopeEvents;
}

/// Events from the device accelerometer with gravity removed.
Stream<UserAccelerometerEvent> get userAccelerometerEvents {
  if (_userAccelerometerEvents == null) {
    _userAccelerometerEvents = _userAccelerometerEventChannel
        .receiveBroadcastStream(_sampleRate ?? _sampleRateDefault)
        .map((dynamic event) =>
            UserAccelerometerEvent(event[0], event[1], event[2], event[3]));
  }
  return _userAccelerometerEvents;
}
