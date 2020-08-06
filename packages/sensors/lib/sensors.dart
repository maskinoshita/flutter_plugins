import 'dart:async';
import 'package:flutter/services.dart';

const EventChannel _accelerometerEventChannel =
    EventChannel('plugins.flutter.io/sensors/accelerometer');

const EventChannel _accelerometerUncalibratedEventChannel =
    EventChannel('plugins.flutter.io/sensors/accelerometer_uncalibrated');

const EventChannel _gravityEventChannel =
    EventChannel('plugins.flutter.io/sensors/gravity');

const EventChannel _userAccelerometerEventChannel =
    EventChannel('plugins.flutter.io/sensors/user_accel');

const EventChannel _gyroscopeEventChannel =
    EventChannel('plugins.flutter.io/sensors/gyroscope');

const EventChannel _gyroscopeUncalibratedEventChannel =
    EventChannel('plugins.flutter.io/sensors/gyroscope_uncalibrated');

const EventChannel _rotationVectorEventChannel =
    EventChannel('plugins.flutter.io/sensors/rotation_vector');

const EventChannel _gameRotationVectorEventChannel =
    EventChannel('plugins.flutter.io/sensors/game_rotation_vector');

const EventChannel _geomagneticRotationVectorEventChannel =
    EventChannel('plugins.flutter.io/sensors/geomagnetic_rotation_vector');

const EventChannel _magneticFieldEventChannel =
    EventChannel('plugins.flutter.io/sensors/magnetic_field');

const EventChannel _magneticFieldUncalibratedEventChannel =
    EventChannel('plugins.flutter.io/sensors/magnetic_field_uncalibrated');

const MethodChannel _getRotationMethodChannel =
    MethodChannel('plugins.flutter.io/sensors/get_rotation_matrix');

const MethodChannel _getOrientationMethodChannel =
    MethodChannel('plugins.flutter.io/sensors/get_orientation');

class AccelerometerEvent {
  AccelerometerEvent(int tms, this.x, this.y, this.z)
      : t = DateTime.fromMillisecondsSinceEpoch(tms);

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

class AccelerometerUncalibratedEvent {
  AccelerometerUncalibratedEvent(
      int tms,
      this.uncalibratedX,
      this.uncalibratedY,
      this.uncalibratedZ,
      this.biasX,
      this.biasY,
      this.biasZ)
      : t = DateTime.fromMillisecondsSinceEpoch(tms);

  /// creation time of sensor data
  final DateTime t;

  /// Uncalibrated acceleration force along the x axis (including gravity) measured in m/s^2.
  final double uncalibratedX;

  /// Uncalibrated acceleration along the y axis (including gravity) measured in m/s^2.
  final double uncalibratedY;

  /// Uncalibrated acceleration along the z axis (including gravity) measured in m/s^2.
  final double uncalibratedZ;

  /// Acceleration bias along the x axis (including gravity) measured in m/s^2.
  final double biasX;

  /// Acceleration bias along the x axis (including gravity) measured in m/s^2.
  final double biasY;

  /// Acceleration bias along the x axis (including gravity) measured in m/s^2.
  final double biasZ;
}

class GravityEvent {
  GravityEvent(int tms, this.x, this.y, this.z)
      : t = DateTime.fromMillisecondsSinceEpoch(tms);

  /// creation time of sensor data
  final DateTime t;

  /// Gravity force along the x axis measured in m/s^2.
  final double x;

  /// Gravity force along the y axis measured in m/s^2.
  final double y;

  /// Gravity force along the z axis measured in m/s^2.
  final double z;

  @override
  String toString() => '[AccelerometerEvent (x: $x, y: $y, z: $z)]';
}

class GyroscopeEvent {
  GyroscopeEvent(int tms, this.x, this.y, this.z)
      : t = DateTime.fromMillisecondsSinceEpoch(tms);

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

class GyroscopeUncalibratedEvent {
  GyroscopeUncalibratedEvent(int tms, this.uncalibratedX, this.uncalibratedY,
      this.uncalibratedZ, this.biasX, this.biasY, this.biasZ)
      : t = DateTime.fromMillisecondsSinceEpoch(tms);

  /// creation time of sensor data
  final DateTime t;

  /// Uncalibrated rate of rotation around the x axis measured in rad/s.
  final double uncalibratedX;

  /// Uncalibrated rate of rotation around the y axis measured in rad/s.
  final double uncalibratedY;

  /// Uncalibrated rate of rotation around the z axis measured in rad/s.
  final double uncalibratedZ;

  /// Rate bias of rotation around the x axis measured in rad/s.
  final double biasX;

  /// Rate bias of rotation around the y axis measured in rad/s.
  final double biasY;

  /// Rate bias of rotation around the z axis measured in rad/s.
  final double biasZ;
}

class UserAccelerometerEvent {
  UserAccelerometerEvent(int tms, this.x, this.y, this.z)
      : t = DateTime.fromMillisecondsSinceEpoch(tms);

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
  RotationVectorEvent(int tms, this.x, this.y, this.z, this.scalar)
      : t = DateTime.fromMillisecondsSinceEpoch(tms);

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
  GameRotationVectorEvent(int tms, this.x, this.y, this.z)
      : t = DateTime.fromMillisecondsSinceEpoch(tms);

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
  GeomagneticRotationVectorEvent(int tms, this.x, this.y, this.z)
      : t = DateTime.fromMillisecondsSinceEpoch(tms);

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
  MagneticFieldEvent(int tms, this.x, this.y, this.z)
      : t = DateTime.fromMillisecondsSinceEpoch(tms);

  /// creation time of sensor data
  final DateTime t;

  /// Magnetic field strength along the x axis in uT
  final double x;

  /// Magnetic field strength along the y axis in uT
  final double y;

  /// Magnetic field strength along the z axis in uT
  final double z;

  @override
  String toString() => '[MagneticFieldEvent (x: $x, y: $y, z: $z)]';
}

class MagneticFieldUncalibratedEvent {
  MagneticFieldUncalibratedEvent(
      int tms,
      this.uncalibratedX,
      this.uncalibratedY,
      this.uncalibratedZ,
      this.biasX,
      this.biasY,
      this.biasZ)
      : t = DateTime.fromMillisecondsSinceEpoch(tms);

  /// creation time of sensor data
  final DateTime t;

  /// Magnetic field strength (including hard iron) along the x axis in uT
  final double uncalibratedX;

  /// Magnetic field strength (including hard iron) along the y axis in uT
  final double uncalibratedY;

  /// Magnetic field strength (including hard iron) along the z axis in uT
  final double uncalibratedZ;

  /// Bias of magnetic field strength along the x axis in uT
  final double biasX;

  /// Bias of magnetic field strength along the y axis in uT
  final double biasY;

  /// Bias of magnetic field strength along the z axis in uT
  final double biasZ;
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
Stream<AccelerometerUncalibratedEvent> _accelerometerUncalibratedEvents;
Stream<GravityEvent> _gravityEvents;
Stream<GyroscopeEvent> _gyroscopeEvents;
Stream<GyroscopeUncalibratedEvent> _gyroscopeUncalibratedEvents;
Stream<UserAccelerometerEvent> _userAccelerometerEvents;
Stream<RotationVectorEvent> _rotationVectorEvents;
Stream<GameRotationVectorEvent> _gameRotationVectorEvents;
Stream<GeomagneticRotationVectorEvent> _geomagneticRotationVectorEvents;
Stream<MagneticFieldEvent> _magneticFieldEvents;
Stream<MagneticFieldUncalibratedEvent> _magneticFieldUncalibratedEvents;

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

/// A broadcast stream of events from the device accelerometer uncalibrated.
Stream<AccelerometerUncalibratedEvent> get accelerometerUncalibratedEvents {
  if (_accelerometerUncalibratedEvents == null) {
    _accelerometerUncalibratedEvents = _accelerometerUncalibratedEventChannel
        .receiveBroadcastStream(_sampleRate ?? _sampleRateDefault)
        .map((dynamic event) => AccelerometerUncalibratedEvent(event[0],
            event[1], event[2], event[3], event[4], event[5], event[6]));
  }
  return _accelerometerUncalibratedEvents;
}

/// A broadcast stream of events from gravity.
Stream<GravityEvent> get gravityEvents {
  if (_gravityEvents == null) {
    _gravityEvents = _gravityEventChannel
        .receiveBroadcastStream(_sampleRate ?? _sampleRateDefault)
        .map((dynamic event) =>
            GravityEvent(event[0], event[1], event[2], event[3]));
  }
  return _gravityEvents;
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

/// A broadcast stream of events from the device gyroscope.
Stream<GyroscopeUncalibratedEvent> get gyroscopeUncalibratedEvents {
  if (_gyroscopeUncalibratedEvents == null) {
    _gyroscopeUncalibratedEvents = _gyroscopeUncalibratedEventChannel
        .receiveBroadcastStream(_sampleRate ?? _sampleRateDefault)
        .map((dynamic event) => GyroscopeUncalibratedEvent(event[0], event[1],
            event[2], event[3], event[4], event[5], event[6]));
  }
  return _gyroscopeUncalibratedEvents;
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
  if (_magneticFieldEvents == null) {
    _magneticFieldEvents = _magneticFieldEventChannel
        .receiveBroadcastStream(_sampleRate ?? _sampleRateDefault)
        .map((dynamic event) =>
            MagneticFieldEvent(event[0], event[1], event[2], event[3]));
  }
  return _magneticFieldEvents;
}

/// Events from the magnetic field uncalibrated.
Stream<MagneticFieldUncalibratedEvent> get magneticFieldUncalibratedEvents {
  if (_magneticFieldUncalibratedEvents == null) {
    _magneticFieldUncalibratedEvents = _magneticFieldUncalibratedEventChannel
        .receiveBroadcastStream(_sampleRate ?? _sampleRateDefault)
        .map((dynamic event) => MagneticFieldUncalibratedEvent(event[0],
            event[1], event[2], event[3], event[4], event[5], event[6]));
  }
  return _magneticFieldUncalibratedEvents;
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
