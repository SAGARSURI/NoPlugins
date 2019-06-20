package com.meetup.no_plugins

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
  companion object {
    const val CHANNEL : String = "com.meetup.no_plugins/demo"
  }
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    MethodChannel(flutterView, CHANNEL).setMethodCallHandler { methodCall, result ->
      if(methodCall.method == "getOSVersion"){
        getOSVersion(result)
      }else{
        result.notImplemented()
      }
    }
  }

  private fun getOSVersion(result: Result) {
    val version = android.os.Build.VERSION.RELEASE
    if(!version.isNullOrEmpty()){
      result.success(version)
    } else {
      result.error("UNAVAILABLE", "Version is not available.", null)
    }
  }
}
