import Flutter
import UIKit

public class SwiftFlutterBackgroundLocationMonitoringPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_background_location_monitoring", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterBackgroundLocationMonitoringPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
