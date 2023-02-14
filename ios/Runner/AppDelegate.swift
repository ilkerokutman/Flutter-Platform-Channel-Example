import UIKit
import Flutter
import CoreLocation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    
    
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
      guard let controller = window?.rootViewController as? FlutterViewController else {
        fatalError("rootViewController is not type FlutterViewController")
      }
      
      let myMethodChannel = FlutterMethodChannel(name: "abc", binaryMessenger: controller.binaryMessenger)
      
      myMethodChannel.setMethodCallHandler({
          [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
          
          guard call.method == "ozge" else {
              result("not implemented")
              return
          }
          
          self?.runMyMethod(result: result)
      })
      
      let myEventChannel = FlutterEventChannel(name: "xyz", binaryMessenger: controller.binaryMessenger)
      
      myEventChannel.setStreamHandler(self)
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        print("event stream started")
        self.eventSink = eventSink
        ///
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        print("event stream canceled")
        eventSink = nil
        return nil
    }
    
    
    private func runMyMethod(result: FlutterResult) {
        Radar.shared.start()
        let time = Date()
        result("\(time)")
    }
    
    public func broadcastLocation(location: CLLocation) {
        let coordinates = "lat: \(location.coordinate.latitude), lon: \(location.coordinate.longitude)"
        
        guard let sink = eventSink else {
            return
        }
        sink(coordinates)
    }
}
