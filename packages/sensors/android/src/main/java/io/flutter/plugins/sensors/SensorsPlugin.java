// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.sensors;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

import androidx.annotation.NonNull;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import java.util.ArrayList;
import java.util.List;

/** SensorsPlugin */
public class SensorsPlugin implements EventChannel.StreamHandler {
  private static final String ACCELEROMETER_CHANNEL_NAME = "plugins.flutter.io/sensors/accelerometer";
  private static final String GYROSCOPE_CHANNEL_NAME = "plugins.flutter.io/sensors/gyroscope";
  private static final String USER_ACCELEROMETER_CHANNEL_NAME = "plugins.flutter.io/sensors/user_accel";
  private static final String ROTATION_VECTOR_CHANNEL_NAME = "plugins.flutter.io/sensors/rotation_vector";
  private static final String GAME_ROTATION_VECTOR_CHANNEL_NAME = "plugins.flutter.io/sensors/game_rotation_vector";
  private static final String GEOMAGNETIC_ROTATION_VECTOR_CHANNEL_NAME = "plugins.flutter.io/sensors/geomagnetic_rotation_vector";
  private static final String MAGNETIC_FIELD_CHANNEL_NAME = "plugins.flutter.io/sensors/magnetic_field";


  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final EventChannel accelerometerChannel = new EventChannel(registrar.messenger(), ACCELEROMETER_CHANNEL_NAME);
    accelerometerChannel.setStreamHandler(new SensorsPlugin(registrar.context(), Sensor.TYPE_ACCELEROMETER));

    final EventChannel userAccelChannel = new EventChannel(registrar.messenger(), USER_ACCELEROMETER_CHANNEL_NAME);
    userAccelChannel.setStreamHandler(new SensorsPlugin(registrar.context(), Sensor.TYPE_LINEAR_ACCELERATION));

    final EventChannel gyroscopeChannel = new EventChannel(registrar.messenger(), GYROSCOPE_CHANNEL_NAME);
    gyroscopeChannel.setStreamHandler(new SensorsPlugin(registrar.context(), Sensor.TYPE_GYROSCOPE));

    final EventChannel rotationVectorChannel = new EventChannel(registrar.messenger(), ROTATION_VECTOR_CHANNEL_NAME);
    rotationVectorChannel.setStreamHandler(new SensorsPlugin(registrar.context(), Sensor.TYPE_ROTATION_VECTOR));

    final EventChannel gameRotationVectorChannel = new EventChannel(registrar.messenger(), GAME_ROTATION_VECTOR_CHANNEL_NAME);
    gameRotationVectorChannel.setStreamHandler(new SensorsPlugin(registrar.context(), Sensor.TYPE_GAME_ROTATION_VECTOR));

    final EventChannel geomagneticRotationVectorChannel = new EventChannel(registrar.messenger(), GEOMAGNETIC_ROTATION_VECTOR_CHANNEL_NAME);
    geomagneticRotationVectorChannel.setStreamHandler(new SensorsPlugin(registrar.context(), Sensor.TYPE_GEOMAGNETIC_ROTATION_VECTOR));

    final EventChannel magneticFieldChannel = new EventChannel(registrar.messenger(), MAGNETIC_FIELD_CHANNEL_NAME);
    magneticFieldChannel.setStreamHandler(new SensorsPlugin(registrar.context(), Sensor.TYPE_MAGNETIC_FIELD));

    final MethodChannel methodGetRotationMatrixChannel = new MethodChannel(registrar.messenger(), MethodGetRotation.CHANNEL);
    methodGetRotationMatrixChannel.setMethodCallHandler(new MethodGetRotation());

    final MethodChannel methodGetOrientationChannel = new MethodChannel(registrar.messenger(), MethodGetOrientation.CHANNEL);
    methodGetOrientationChannel.setMethodCallHandler(new MethodGetOrientation());
  }

  private SensorEventListener sensorEventListener;
  private final SensorManager sensorManager;
  private final Sensor sensor;

  private SensorsPlugin(Context context, int sensorType) {
    sensorManager = (SensorManager) context.getSystemService(context.SENSOR_SERVICE);
    sensor = sensorManager.getDefaultSensor(sensorType);
  }

  @Override
  public void onListen(Object arguments, EventChannel.EventSink events) {
    sensorEventListener = createSensorEventListener(events);
    sensorManager.registerListener(sensorEventListener, sensor, (int) (1000000 / (int) arguments));
  }

  @Override
  public void onCancel(Object arguments) {
    sensorManager.unregisterListener(sensorEventListener);
  }

  SensorEventListener createSensorEventListener(final EventChannel.EventSink events) {
    return new SensorEventListener() {
      @Override
      public void onAccuracyChanged(Sensor sensor, int accuracy) {
      }

      @Override
      public void onSensorChanged(SensorEvent event) {
        final long timestamp_in_us = event.timestamp/1000;
        final ArrayList<Object> sensorValues = new ArrayList(event.values.length + 1);
        sensorValues.add(timestamp_in_us);
        for (double v : event.values) {
          sensorValues.add(v);
        }
        events.success(sensorValues);
      }
    };
  }
}

class MethodUtil {
  public static float[] toFloatArray(List<Double> a) {
    if(a == null || a.isEmpty()) {
      return null;
    }
    final int size = a.size();
    final float[] r = new float[size];
    for(int i=0; i<size; i++) {
      r[i] = a.get(i).floatValue();
    }
    return r;
  }
  public static List<Double> toDoubleList(float[] a) {
    if(a == null || a.length == 0) {
      return null;
    }
    final int size = a.length;
    final List<Double> r = new ArrayList<>(size);
    for(float f : a) {
      r.add(Double.valueOf(f));
    }
    return r;
  }
}

class MethodGetRotation implements MethodChannel.MethodCallHandler {
  static final String CHANNEL = "plugins.flutter.io/sensors/get_rotation_matrix";
  static final String GET_MATRIX = "getRotationMatrix";
  static final String GET_MATRIX_FROM_VECTOR = "getRotationMatrixFromRotationVector";
  static final String GET_QUATERNION = "getQuaternion";

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
    if (GET_MATRIX.equals(call.method)) {
      final List<Double> accel = call.argument("accel");
      if(accel == null || accel.isEmpty()) {
        result.error("ErrorAccel", "Please pass acclerometer values", null);
        return;
      }
      final List<Double> mag = call.argument("mag");
      if(mag == null || mag.isEmpty()) {
        result.error("ErrorMag", "Please pass magnetrometer values", null);
        return;
      }
      final float[] ret = getRotationMatrix(MethodUtil.toFloatArray(accel), MethodUtil.toFloatArray(mag));
      if(ret == null) {
        result.error("Unknown Error", "An error occured in getRotationMatrix", null);
        return;
      } else {
        result.success(MethodUtil.toDoubleList(ret));
        return;
      }
    } else if (GET_MATRIX_FROM_VECTOR.equals(call.method)) {
      final List<Double> rotationVec = call.argument("rotationVec");
      if(rotationVec == null || rotationVec.isEmpty()) {
        result.error("ErrorRotationVec", "Please pass rotation vector values", null);
        return;
      }
      result.success(MethodUtil.toDoubleList(getRotationMatrixFromVector(MethodUtil.toFloatArray(rotationVec))));
      return;
    } else if (GET_QUATERNION.equals(call.method)) {
      final List<Double> rotationVec = call.argument("rotationVec");
      if(rotationVec == null || rotationVec.isEmpty()) {
        result.error("ErrorRotationVec", "Please pass rotation vector values", null);
        return;
      }
      result.success(MethodUtil.toDoubleList(getQuaternion(MethodUtil.toFloatArray(rotationVec))));
      return;
    } else {
      result.notImplemented();
    }
  }

  static float[] getRotationMatrix(float[] accel, float[] mag) {
    final float[] rotationMatrix = new float[9];
    if(SensorManager.getRotationMatrix(rotationMatrix, null, accel, mag)) {
      return rotationMatrix;
    } else {
      return null;
    }
  }

  static float[] getRotationMatrixFromVector(float[] rotationVec) {
    final float[] rotationMatrix = new float[9];
    SensorManager.getRotationMatrixFromVector(rotationMatrix, rotationVec);
    return rotationMatrix;
  }

  static float[] getQuaternion(float[] rotationVec) {
    final float[] quaternion = new float[4];
    SensorManager.getQuaternionFromVector(quaternion, rotationVec);
    return quaternion;
  }
}

class MethodGetOrientation implements MethodChannel.MethodCallHandler {
  static final String CHANNEL = "plugins.flutter.io/sensors/get_orientation";
  static final String FROM_SENSOR = "getOrientation";
  static final String FROM_MATRIX = "getOrientationFromRotationMatrix";

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
    if (FROM_SENSOR.equals(call.method)) {
      final List<Double> accel = call.argument("accel");
      if(accel == null || accel.isEmpty()) {
        result.error("ErrorAccel", "Please pass acclerometer values", null);
        return;
      }
      final List<Double> mag = call.argument("mag");
      if(mag == null || mag.isEmpty()) {
        result.error("ErrorMag", "Please pass magnetrometer values", null);
        return;
      }
      final float[] rotationMatrix = MethodGetRotation.getRotationMatrix(MethodUtil.toFloatArray((accel)), MethodUtil.toFloatArray(mag));
      if(rotationMatrix == null) {
        result.error("Unknown Error", "An error occured in getRotationMatrix", null);
        return;
      } else {
        float[] ret = getOrientationFromMatrix(rotationMatrix);
        result.success(MethodUtil.toDoubleList(ret));
        return;
      }
    } else if (FROM_MATRIX.equals(call.method)) {
      final List<Double> rotationMatrix = call.argument("rotationMatrix");
      float[] ret = getOrientationFromMatrix(MethodUtil.toFloatArray(rotationMatrix));
      result.success(MethodUtil.toDoubleList(ret));
    } else {
      result.notImplemented();
    }
  }

  static float[] getOrientationFromMatrix(float[] rotationMatrix) {
    final float[] orientation = new float[3];
    SensorManager.getOrientation(rotationMatrix, orientation);
    return orientation;
  }
}
