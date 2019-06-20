import UIKit
import Flutter
import CoreLocation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.meetup.no_plugins/demo",
                                              binaryMessenger: controller)
    channel.setMethodCallHandler({
        [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
        switch call.method {
        case "getOSVersion" :
            self?.getOSVersion(result: result)
        default :
            result(FlutterMethodNotImplemented)
        }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func getOSVersion(result: FlutterResult){
        let version = UIDevice.current.systemVersion
        result(String(version))
    }
    
    private func isCameraAvailable(result: FlutterResult){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            result(Bool(true))
        }else{
            //This makes more sense as the device lack the hardware
            result(FlutterError(code: "UNAVAILABLE", message: "No camera hardware", details: nil))
        }
    }
    
    private func isLocationEnabled(result: FlutterResult){
        if CLLocationManager.locationServicesEnabled() {
            result(Bool(true))
        } else {
            result(FlutterError(code: "DISABLED", message: "Location is turned off", details: nil))
        }
    }
    
    
    private func callNumber(phoneNumber:String) {
        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }
}
