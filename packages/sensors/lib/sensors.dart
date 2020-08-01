import 'dart:async';
import 'package:flutter/services.dart';

const EventChannel _accelerometerEventChannel =
    EventChannel('plugins.flutter.io/sensors/accelerometer');

const EventChannel _userAccelerometerEventChannel =
    EventChannel('plugins.flutter.io/sensors/user_accel');

const EventChannel _gyroscopeEventChannel =
    EventChannel('plugins.flutter.io/sensors/gyroscope');

const EventChannel _rotationVectorEventChannel =
    EventChannel('plugins.flutter.io/sensors/rotation_vector');

const EventChannel _gameRotationVectorEventChannel =
    EventChannel('plugins.flutter.io/sensors/game_rotation_vector');

const EventChannel _geomagneticRotationVectorEventChannel =
    EventChannel('plugins.flutter.io/sensors/geomagnetic_rotation_vector');

const EventChannel _magneticFieldEventChannel =
    EventChannel('plugins.flutter.io/sensors/magnetic_field');

const MethodChannel _getRotationMethodChannel =
    MethodChannel('plugins.flutter.io/sensors/get_rotation_matrix');

const MethodChannel _getOrientationMethodChannel =
    MethodChannel('plugins.flutter.io/sensors/get_orientation');

class AccelerometerEvent {
  AccelerometerEvent(int tus, this.x, this.y, this.z)
      : t = DateTime.fromMicrosecondsSinceEpoch(tus);

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
      : t = DateTime.fromMicrosecondsSinceEpoch(tus);

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
      : t = DateTime.fromMicrosecondsSinceEpoch(tus);

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

class RotationVectorEvent {
  RotationVectorEvent(int tus, this.x, this.y, this.z, this.scalar)
      : t = DateTime.fromMicrosecondsSinceEpoch(tus);

  /// creation time of sensor data
  final DateTime t;

  /// Rotation vector angle along the x axis
  final double x;

  /// Rotation vector angle along the y axis
  final double y;

  /// Rotation vector angle along the z axis
  final double z;

  /// Scalar of ration vector
  final double scalar;

  @override
  String toString() =>
      '[RotationVectorEvent (x: $x, y: $y, z: $z, scalar: $scalar)]';
}

class GameRotationVectorEvent {
  GameRotationVectorEvent(int tus, this.x, this.y, this.z)
      : t = DateTime.fromMicrosecondsSinceEpoch(tus);

  /// creation time of sensor data
  final DateTime t;

  /// Game rotation vector angle along the x axis
  final double x;

  /// Game rotation vector angle along the y axis
  final double y;

  /// Game rotation vector angle along the z axis
  final double z;

  @override
  String toString() => '[GameRotationVectorEvent (x: $x, y: $y, z: $z)]';
}

class GeomagneticRotationVectorEvent {
  GeomagneticRotationVectorEvent(int tus, this.x, this.y, this.z)
      : t = DateTime.fromMicrosecondsSinceEpoch(tus);

  /// creation time of sensor data
  final DateTime t;

  /// Game rotation vector angle along the x axis
  final double x;

  /// Game rotation vector angle along the y axis
  final double y;

  /// Game rotation vector angle along the z axis
  final double z;

  @override
  String toString() => '[GeomagneticRotationVectorEvent (x: $x, y: $y, z: $z)]';
}

class MagneticFieldEvent {
  MagneticFieldEvent(int tus, this.x, this.y, this.z)
      : t = DateTime.fromMicrosecondsSinceEpoch(tus);

  /// creation time of sensor data
  final DateTime t;

  /// Game rotation vector angle along the x axis
  final double x;

  /// Game rotation vector angle along the y axis
  final double y;

  /// Game rotation vector angle along the z axis
  final double z;

  @override
  String toString() => '[MagneticFieldEvent (x: $x, y: $y, z: $z)]';
}

class DeviceOrientation {
  DeviceOrientation(this.azimuth, this.pitch, this.roll);

  /// azimuth angle (rotation angle for z axis)
  final double azimuth; // z

  /// gradient angle (rotation angle for x axis)
  final double pitch; // x

  /// rotation angle (rotaiton angle for y axis)
  final double roll; // y
}

Stream<AccelerometerEvent> _accelerometerEvents;
Stream<GyroscopeEvent> _gyroscopeEvents;
Stream<UserAccelerometerEvent> _userAccelerometerEvents;
Stream<RotationVectorEvent> _rotationVectorEvents;
Stream<GameRotationVectorEvent> _gameRotationVectorEvents;
Stream<GeomagneticRotationVectorEvent> _geomagneticRotationVectorEvents;
Stream<MagneticFieldEvent> _magneticFieldEvents;

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

/// Events from the device rotation vector.
Stream<RotationVectorEvent> get rotationVectorEvents {
  if (_rotationVectorEvents == null) {
    _rotationVectorEvents = _rotationVectorEventChannel
        .receiveBroadcastStream(_sampleRate ?? _sampleRateDefault)
        .map((dynamic event) => RotationVectorEvent(
            event[0], event[1], event[2], event[3], event[4]));
  }
  return _rotationVectorEvents;
}

/// Events from the device rotation vector without using magnetic field.
Stream<GameRotationVectorEvent> get gameRotationVectorEvents {
  if (_userAccelerometerEvents == null) {
    _gameRotationVectorEvents = _gameRotationVectorEventChannel
        .receiveBroadcastStream(_sampleRate ?? _sampleRateDefault)
        .map((dynamic event) =>
            GameRotationVectorEvent(event[0], event[1], event[2], event[3]));
  }
  return _gameRotationVectorEvents;
}

/// Events from the device rotation vector with magnetic field.
Stream<GeomagneticRotationVectorEvent> get geomagneticRotationVectorEvents {
  if (_geomagneticRotationVectorEvents == null) {
    _geomagneticRotationVectorEvents = _geomagneticRotationVectorEventChannel
        .receiveBroadcastStream(_sampleRate ?? _sampleRateDefault)
        .map((dynamic event) => GeomagneticRotationVectorEvent(
            event[0], event[1], event[2], event[3]));
  }
  return _geomagneticRotationVectorEvents;
}

/// Events from the magnetic field.
Stream<MagneticFieldEvent> get magneticFieldEvents {
  if (_userAccelerometerEvents == null) {
    _magneticFieldEvents = _magneticFieldEventChannel
        .receiveBroadcastStream(_sampleRate ?? _sampleRateDefault)
        .map((dynamic event) =>
            MagneticFieldEvent(event[0], event[1], event[2], event[3]));
  }
  return _magneticFieldEvents;
}

Future<List<double>> getRotationMatrix(
    AccelerometerEvent accel, MagneticFieldEvent mag) async {
  final List<double> accelList = [accel.x, accel.y, accel.z];
  final List<double> magList = [mag.x, mag.y, mag.z];
  final List<dynamic> ret = await _getRotationMethodChannel.invokeMethod(
      'getRotationMatrix',
      <String, dynamic>{'accel': accelList, 'mag': magList});
  return ret.cast<double>();
}

Future<List<double>> getRotationMatrixFromRotationVector(
    RotationVectorEvent rotationVec) async {
  final List<double> rotVecList = [
    rotationVec.x,
    rotationVec.y,
    rotationVec.z,
    rotationVec.scalar
  ];
  final List<dynamic> ret = await _getRotationMethodChannel.invokeMethod(
      'getRotationMatrixFromRotationVector',
      <String, dynamic>{'rotationVec': rotVecList});
  return ret.cast<double>();
}

Future<List<double>> getQuaternion(RotationVectorEvent rotationVec) async {
  final List<double> rotVecList = [
    rotationVec.x,
    rotationVec.y,
    rotationVec.z,
    rotationVec.scalar
  ];
  final List<dynamic> ret = await _getRotationMethodChannel.invokeMethod(
      'getQuaternion', <String, dynamic>{'rotationVec': rotVecList});
  return ret.cast<double>();
}

Future<DeviceOrientation> getOrientation(
    AccelerometerEvent accel, MagneticFieldEvent mag) async {
  final List<double> accelList = [accel.x, accel.y, accel.z];
  final List<double> magList = [mag.x, mag.y, mag.z];
  final List<dynamic> list = await _getOrientationMethodChannel.invokeMethod(
      'getOrientation', <String, dynamic>{'accel': accelList, 'mag': magList});
  return DeviceOrientation(list[0], list[1], list[2]);
}

Future<DeviceOrientation> getOrientationFromRotationMatrix(
    List<double> rotationMatrix) async {
  final List<dynamic> list = await _getOrientationMethodChannel.invokeMethod(
      'getOrientationFromRotationMatrix',
      <String, dynamic>{'rotationMatrix': rotationMatrix});
  return DeviceOrientation(list[0], list[1], list[2]);
}
