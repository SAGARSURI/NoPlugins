import UIKit
import Flutter
import CoreMotion

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {
    
    let motionManager = CMMotionManager()
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
                if error != nil{
                    events(FlutterError(code: "FAILED", message: error.debugDescription, details: nil))
                }else{
                    if (data?.acceleration)!.x >= 0.75 {
                        events(String("Landscape Left"))
                    }else if (data?.acceleration)!.x <= -0.75{
                        events(String("Landscape Right"))
                    }else if(data?.acceleration)!.y <= -0.75 {
                        events(String("Portrait"))
                    }else if (data?.acceleration)!.y >= 0.75 {
                        events(String("Portrait Upside down"))
                    }
                }
            }
        }
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
    
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.meetup.no_plugins/methodChannelDemo",
                                              binaryMessenger: controller)
    
    //Channel to listen for incoming messages
    let streamChannel = FlutterEventChannel(name: "com.meetup.no_plugins/eventChannelDemo", binaryMessenger: controller)
    streamChannel.setStreamHandler(self)
    
    
    
    channel.setMethodCallHandler({
        [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
        switch call.method {
        case "getOSVersion" :
            self?.getOSVersion(result: result)
        case "isCameraAvailable" :
            self?.isCameraAvailable(result: result)
        case "callNumber" :
            let args = call.arguments as! [String: String]
            let phoneNumber = args["number"]!
            self?.callNumber(phoneNumber: phoneNumber)
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
            result(["status": "Camera is available"])
        }else{
            //This makes more sense as the device lack the hardware
            result(FlutterError(code: "UNAVAILABLE", message: "No camera hardware", details: nil))
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
