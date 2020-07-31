// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.sensors;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/** SensorsPlugin */
public class SensorsPlugin implements EventChannel.StreamHandler {
  private static final String ACCELEROMETER_CHANNEL_NAME = "plugins.flutter.io/sensors/accelerometer";
  private static final String GYROSCOPE_CHANNEL_NAME = "plugins.flutter.io/sensors/gyroscope";
  private static final String USER_ACCELEROMETER_CHANNEL_NAME = "plugins.flutter.io/sensors/user_accel";



  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final EventChannel accelerometerChannel = new EventChannel(registrar.messenger(), ACCELEROMETER_CHANNEL_NAME);
    accelerometerChannel.setStreamHandler(new SensorsPlugin(registrar.context(), Sensor.TYPE_ACCELEROMETER));

    final EventChannel userAccelChannel = new EventChannel(registrar.messenger(), USER_ACCELEROMETER_CHANNEL_NAME);
    userAccelChannel.setStreamHandler(new SensorsPlugin(registrar.context(), Sensor.TYPE_LINEAR_ACCELERATION));

    final EventChannel gyroscopeChannel = new EventChannel(registrar.messenger(), GYROSCOPE_CHANNEL_NAME);
    gyroscopeChannel.setStreamHandler(new SensorsPlugin(registrar.context(), Sensor.TYPE_GYROSCOPE));
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
        ArrayList<Object> sensorValues = new ArrayList(event.values.length + 1);
        sensorValues.add(timestamp_in_us);
        for (double v : event.values) {
          sensorValues.add(v);
        }
        events.success(sensorValues);
      }
    };
  }
}
