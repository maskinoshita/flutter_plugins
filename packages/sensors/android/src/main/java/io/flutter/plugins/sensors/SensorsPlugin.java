// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.sensors;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

import android.os.SystemClock;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import java.util.ArrayList;

/** SensorsPlugin */
public class SensorsPlugin {
  private static final String ACCELEROMETER_CHANNEL_NAME = "plugins.flutter.io/sensors/accelerometer";
  private static final String ACCELEROMETER_UNCALIBRATED_CHANNEL_NAME = "plugins.flutter.io/sensors/accelerometer_uncalibrated";
  private static final String GRAVITY_CHANNEL_NAME = "plugins.flutter.io/sensors/gravity";
  private static final String GYROSCOPE_CHANNEL_NAME = "plugins.flutter.io/sensors/gyroscope";
  private static final String GYROSCOPE_UNCALIBRATED_CHANNEL_NAME = "plugins.flutter.io/sensors/gyroscope_uncalibrated";
  private static final String USER_ACCELEROMETER_CHANNEL_NAME = "plugins.flutter.io/sensors/user_accel";
  private static final String ROTATION_VECTOR_CHANNEL_NAME = "plugins.flutter.io/sensors/rotation_vector";
  private static final String GAME_ROTATION_VECTOR_CHANNEL_NAME = "plugins.flutter.io/sensors/game_rotation_vector";
  private static final String GEOMAGNETIC_ROTATION_VECTOR_CHANNEL_NAME = "plugins.flutter.io/sensors/geomagnetic_rotation_vector";
  private static final String MAGNETIC_FIELD_CHANNEL_NAME = "plugins.flutter.io/sensors/magnetic_field";
  private static final String MAGNETIC_FIELD_UNCALIBRATED_CHANNEL_NAME = "plugins.flutter.io/sensors/magnetic_field_uncalibrated";
  private static final String ROTATION_MATRIX_CHANNEL_NAME = "plugins.flutter.io/sensors/rotation_matrix";
  private static final String QUATERNION_CHANNEL_NAME = "plugins.flutter.io/sensors/quaternion";
  private static final String ORIENTATION_CHANNEL_NAME = "plugins.flutter.io/sensors/orientation";

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final EventChannel accelerometerChannel = new EventChannel(registrar.messenger(), ACCELEROMETER_CHANNEL_NAME);
    accelerometerChannel.setStreamHandler(new GenericSensorHandler(registrar.context(), Sensor.TYPE_ACCELEROMETER));

    final EventChannel accelerometerUncalibratedChannel = new EventChannel(registrar.messenger(), ACCELEROMETER_UNCALIBRATED_CHANNEL_NAME);
    accelerometerUncalibratedChannel.setStreamHandler(new GenericSensorHandler(registrar.context(), Sensor.TYPE_ACCELEROMETER_UNCALIBRATED));

    final EventChannel gravityChannel = new EventChannel(registrar.messenger(), GRAVITY_CHANNEL_NAME);
    gravityChannel.setStreamHandler(new GenericSensorHandler(registrar.context(), Sensor.TYPE_GRAVITY));

    final EventChannel userAccelChannel = new EventChannel(registrar.messenger(), USER_ACCELEROMETER_CHANNEL_NAME);
    userAccelChannel.setStreamHandler(new GenericSensorHandler(registrar.context(), Sensor.TYPE_LINEAR_ACCELERATION));

    final EventChannel gyroscopeChannel = new EventChannel(registrar.messenger(), GYROSCOPE_CHANNEL_NAME);
    gyroscopeChannel.setStreamHandler(new GenericSensorHandler(registrar.context(), Sensor.TYPE_GYROSCOPE));

    final EventChannel gyroscopeUncalibratedChannel = new EventChannel(registrar.messenger(), GYROSCOPE_UNCALIBRATED_CHANNEL_NAME);
    gyroscopeUncalibratedChannel.setStreamHandler(new GenericSensorHandler(registrar.context(), Sensor.TYPE_GYROSCOPE_UNCALIBRATED));

    final EventChannel rotationVectorChannel = new EventChannel(registrar.messenger(), ROTATION_VECTOR_CHANNEL_NAME);
    rotationVectorChannel.setStreamHandler(new GenericSensorHandler(registrar.context(), Sensor.TYPE_ROTATION_VECTOR));

    final EventChannel gameRotationVectorChannel = new EventChannel(registrar.messenger(), GAME_ROTATION_VECTOR_CHANNEL_NAME);
    gameRotationVectorChannel.setStreamHandler(new GenericSensorHandler(registrar.context(), Sensor.TYPE_GAME_ROTATION_VECTOR));

    final EventChannel geomagneticRotationVectorChannel = new EventChannel(registrar.messenger(), GEOMAGNETIC_ROTATION_VECTOR_CHANNEL_NAME);
    geomagneticRotationVectorChannel.setStreamHandler(new GenericSensorHandler(registrar.context(), Sensor.TYPE_GEOMAGNETIC_ROTATION_VECTOR));

    final EventChannel magneticFieldChannel = new EventChannel(registrar.messenger(), MAGNETIC_FIELD_CHANNEL_NAME);
    magneticFieldChannel.setStreamHandler(new GenericSensorHandler(registrar.context(), Sensor.TYPE_MAGNETIC_FIELD));

    final EventChannel magneticFieldUncalibratedChannel = new EventChannel(registrar.messenger(), MAGNETIC_FIELD_UNCALIBRATED_CHANNEL_NAME);
    magneticFieldUncalibratedChannel.setStreamHandler(new GenericSensorHandler(registrar.context(), Sensor.TYPE_MAGNETIC_FIELD_UNCALIBRATED));

    final EventChannel rotationMatrixChannel = new EventChannel(registrar.messenger(), ROTATION_MATRIX_CHANNEL_NAME);
    rotationMatrixChannel.setStreamHandler(new HandlerFromRotationVector(registrar.context()) {
      @Override
      protected float[] fromRotationVector(final float[] rv) {
        final float[] rotationMat = new float[9];
        SensorManager.getRotationMatrixFromVector(rotationMat, rv);
        return rotationMat;
      }
    });

    final EventChannel quaternionChannel = new EventChannel(registrar.messenger(), QUATERNION_CHANNEL_NAME);
    quaternionChannel.setStreamHandler(new HandlerFromRotationVector(registrar.context()) {
      @Override
      protected float[] fromRotationVector(final float[] rv) {
        final float[] quaternion = new float[4];
        SensorManager.getQuaternionFromVector(quaternion, rv);
        return quaternion;
      }
    });

    final EventChannel orientationChannel = new EventChannel(registrar.messenger(), ORIENTATION_CHANNEL_NAME);
    orientationChannel.setStreamHandler(new HandlerFromRotationVector(registrar.context()) {
      @Override
      protected float[] fromRotationVector(final float[] rv) {
        final float[] rotationMat = new float[9];
        SensorManager.getRotationMatrixFromVector(rotationMat, rv);
        final float[] orientation = new float[3];
        SensorManager.getOrientation(rotationMat, orientation);
        return orientation;
      }
    });
  }

  public static abstract class GenericSensorEventListener implements SensorEventListener {
    private final long BOOT_TIME_MS_EPOCH = System.currentTimeMillis() - SystemClock.elapsedRealtimeNanos() / 1000000;

    public long calc_timestamp_ms_epoch(long timestamp_ns) {
      return BOOT_TIME_MS_EPOCH + timestamp_ns / 1000000;
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) {
    }

    @Override
    abstract public void onSensorChanged(SensorEvent sensorEvent);
  }

  public static class GenericSensorHandler implements EventChannel.StreamHandler {
    private SensorEventListener sensorEventListener;
    private final SensorManager sensorManager;
    private final Sensor sensor;
  
    private GenericSensorHandler(Context context, int sensorType) {
      sensorManager = (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);
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
  
    protected SensorEventListener createSensorEventListener(final EventChannel.EventSink events) {
      return new GenericSensorEventListener() {
        @Override
        public void onSensorChanged(SensorEvent event) {
          final long timestamp_ms_epoch = calc_timestamp_ms_epoch(event.timestamp);
          final ArrayList<Object> sensorValues = new ArrayList<>(event.values.length + 1);
          sensorValues.add(timestamp_ms_epoch);
          for (double v : event.values) {
            sensorValues.add(v);
          }
          events.success(sensorValues);
        }
      };
    }
  }

  public static abstract class HandlerFromRotationVector extends GenericSensorHandler {
    private  HandlerFromRotationVector(Context context) {
      super(context, Sensor.TYPE_ROTATION_VECTOR);
    }

    abstract protected float[] fromRotationVector(final float[] rv);

    @Override
    protected SensorEventListener createSensorEventListener(final EventChannel.EventSink events) {
      return new GenericSensorEventListener() {
        @Override
        public void onSensorChanged(SensorEvent event) {
          final long timestamp_ms_epoch = calc_timestamp_ms_epoch(event.timestamp);
          final float[] values = fromRotationVector(event.values);
          final ArrayList<Object> sensorValues = new ArrayList<>(values.length + 1);
          sensorValues.add(timestamp_ms_epoch);
          for (double v : values) {
            sensorValues.add(v);
          }
          events.success(sensorValues);
        }
      };
    }
  }
}