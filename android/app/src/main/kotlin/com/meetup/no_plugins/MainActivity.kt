package com.meetup.no_plugins

import android.Manifest
import android.annotation.TargetApi
import android.content.Context
import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugins.GeneratedPluginRegistrant
import android.content.pm.PackageManager
import android.content.Intent
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.net.Uri
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import android.hardware.SensorManager

class MainActivity : FlutterActivity() {

  companion object {
    const val METHOD_CHANNEL: String = "com.meetup.no_plugins/methodChannelDemo"
    const val EVENT_CHANNEL: String = "com.meetup.no_plugins/eventChannelDemo"
    const val CALL_REQUEST_CODE = 101
  }

  private lateinit var mSensorManager: SensorManager
  private lateinit var mAccelerometer: Sensor

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    mSensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
    mAccelerometer = mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)

    MethodChannel(flutterView, METHOD_CHANNEL).setMethodCallHandler { methodCall, result ->
      when {
        methodCall.method == "getOSVersion" -> getOSVersion(result)
        methodCall.method == "isCameraAvailable" -> isCameraAvailable(result)
        methodCall.method == "callNumber" -> callNumber(methodCall.argument("number"))
        else -> result.notImplemented()
      }
    }

    EventChannel(flutterView, EVENT_CHANNEL).setStreamHandler(object : StreamHandler {
      override fun onListen(
        arguments: Any?,
        events: EventSink?
      ) {
        emitDeviceOrientation(events)
      }

      override fun onCancel(arguments: Any?) {

      }

    })
  }

  private fun getOSVersion(result: Result) {
    val version = VERSION.RELEASE
    if (!version.isNullOrEmpty()) {
      result.success(version)
    } else {
      result.error("UNAVAILABLE", "Version is not available.", null)
    }
  }

  private fun isCameraAvailable(result: Result) {
    if (packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA)) {
      result.success(mapOf("status" to "Camera is available"))
    } else {
      result.error("UNAVAILABLE", "No camera hardware", null)
    }
  }

  private fun callNumber(phoneNumber: String?) {
    if (VERSION.SDK_INT < VERSION_CODES.M) {
      makeCall(phoneNumber)
    } else {
      if (checkSelfPermission(Manifest.permission.CALL_PHONE) != PackageManager.PERMISSION_GRANTED) {
        makeRequest()
      } else {
        makeCall(phoneNumber)
      }
    }
  }

  private fun makeCall(phoneNumber: String?) {
    val callIntent = Intent(Intent.ACTION_CALL)
    callIntent.data = Uri.parse("tel:$phoneNumber")
    startActivity(callIntent)
  }

  private fun emitDeviceOrientation(events: EventSink?) {
    mSensorManager.registerListener(object : SensorEventListener {
      override fun onSensorChanged(sensorEvent: SensorEvent?) {
        if (sensorEvent?.sensor?.type == Sensor.TYPE_ACCELEROMETER) {
          if (Math.abs(sensorEvent.values[1]) > Math.abs(sensorEvent.values[0])) {
            //Mainly portrait
            if (sensorEvent.values[1] > 0.75) {
              events?.success("Portrait")
            } else if (sensorEvent.values[1] < -0.75) {
              events?.success("Portrait Upside down")
            }
          } else {
            //Mainly landscape
            if (sensorEvent.values[0] > 0.75) {
              events?.success("Landscape Right")
            } else if (sensorEvent.values[0] < -0.75) {
              events?.success("Landscape Left")
            }
          }
        }
      }

      override fun onAccuracyChanged(
        sensor: Sensor?,
        accuracy: Int
      ) {

      }
    }, mAccelerometer, SensorManager.SENSOR_DELAY_NORMAL)
  }

  @TargetApi(VERSION_CODES.M)
  private fun setupPermissions() {
    val permission = checkSelfPermission(Manifest.permission.CALL_PHONE)
    if (permission != PackageManager.PERMISSION_GRANTED) {
      makeRequest()
    }
  }

  @TargetApi(VERSION_CODES.M)
  private fun makeRequest() {
    requestPermissions(
        arrayOf(Manifest.permission.CALL_PHONE),
        CALL_REQUEST_CODE
    )
  }

  override fun onRequestPermissionsResult(
    requestCode: Int,
    permissions: Array<String>,
    grantResults: IntArray
  ) {
    when (requestCode) {
      CALL_REQUEST_CODE -> {

        if (grantResults.isEmpty() || grantResults[0] != PackageManager.PERMISSION_GRANTED) {
          //Permission denied
        } else {
          //Permission granted
        }
      }
    }
  }
}
