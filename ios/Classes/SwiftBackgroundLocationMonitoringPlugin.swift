import Flutter
import UIKit

public class SwiftBackgroundLocationMonitoringPlugin: NSObject, FlutterPlugin {
  static var locationManager: CLLocationManager?
  static var channel: FlutterMethodChannel?

  public static func register(with registrar: FlutterPluginRegistrar) {
    SwiftBackgroundLocationPlugin.channel = FlutterMethodChannel(name: "background_location_monitoring", binaryMessenger: registrar.messenger())
    let instance = SwiftBackgroundLocationMonitoringPlugin()
    registrar.addMethodCallDelegate(instance, channel: SwiftBackgroundLocationPlugin.channel)

    // not sure if this is needed
    // SwiftBackgroundLocationMonitoringPlugin.channel?.setMethodCallHandler(instance.handle)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let locationManager = CLLocationManager()
    SwiftBackgroundLocationMonitoringPlugin.locationManager = locationManager
    locationManager?.delegate = self
    locationManager?.requestAlwaysAuthorization()
    locationManager?.allowsBackgroundLocationUpdates = true
    locationManager?.pausesLocationUpdatesAutomatically = false
    locationManager?.activityType = CLActivityType.other
    if #available(iOS 11.0, *) {
        locationManager?.showsBackgroundLocationIndicator = true;
    }

    SwiftBackgroundLocationMonitoringPlugin.channel?.invokeMethod("location", arguments: "method")

    if (call.method == "start_monitoring") {
        // not sure what this is for
        // SwiftBackgroundLocationPlugin.channel?.invokeMethod("location", arguments: "start_monitoring")

        let args = call.arguments as? Dictionary<String, Any>
        let distanceFilter = args?["distance_filter"] as? Double
        SwiftBackgroundLocationPlugin.locationManager?.distanceFilter = distanceFilter ?? 0

        // start monitoring the service.  request always authorization
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            // The device does not support this service.
            return
        }
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways,
             .authorizedWhenInUse,
             .restricted,
             .denied:
            // Handle unauthorized
            locationManager.requestAlwaysAuthorization()
        @unknown default:
            break
        }
        locationManager?.startMonitoringSignificantLocationChanges()
        locationManager?.startMonitoringVisits()

    } else if (call.method == "stop_monitoring") {
        // not sure what this is for
        // SwiftBackgroundLocationPlugin.channel?.invokeMethod("location", arguments: "stop_monitoring")
        SwiftBackgroundLocationPlugin.locationManager?.stopUpdatingLocation()
    }
    result(true)
  }

  func locationManager(_ manager: CLLocationManager,
                       didChangeAuthorization status: CLAuthorizationStatus) {
      switch status {
      case .authorizedAlways:
        locationManager?.startMonitoringSignificantLocationChanges()
          locationManager.startMonitoringVisits()
      case .notDetermined,
           .authorizedWhenInUse,
           .restricted,
           .denied:
           // Handle unauthorized
          locationManager?.startMonitoringSignificantLocationChanges()
          locationManager.startMonitoringVisits()
      @unknown default:
          break
      }
  }

  func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
    let visit = [
        "latitude": visit.coordinate.latitude,
        "longitude": visit.coordinate.longitude,
        "accuracy": visit.horizontalAccuracy,
        "arrivalTime": visit.arrivalDate.timeIntervalSince1970 * 1000,
        "departureTime": visit.departureDate.timeIntervalSince1970 * 1000,
        "is_mock": false
    ] as [String : Any]

    SwiftBackgroundLocationMonitoringPlugin.channel?.invokeMethod("visit", arguments: visit)
  }
  private func postDebugVisit(for visit: CLVisit) {
      let location = CLLocation(coordinate: visit.coordinate,
                                altitude: 0,
                                horizontalAccuracy: visit.horizontalAccuracy,
                                verticalAccuracy: 0,
                                timestamp: visit.arrivalDate)
      if (visit.departureDate != NSDate.distantFuture) {
          postDebugGeocodedLocation(for: location, title: "End visit \(visit.departureDate)")
      } else {
          postDebugGeocodedLocation(for: location, title: "Start visit \(visit.arrivalDate)")
      }
  }
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let lastLocation = locations.last {
      let location = [
          "speed": lastLocation.speed,
          "altitude": lastLocation.altitude,
          "latitude": lastLocation.coordinate.latitude,
          "longitude": lastLocation.coordinate.longitude,
          "accuracy": lastLocation.horizontalAccuracy,
          "bearing": lastLocation.course,
          "time": lastLocation.timestamp.timeIntervalSince1970 * 1000,
          "is_mock": false
      ] as [String : Any]

      SwiftBackgroundLocationMonitoringPlugin.channel?.invokeMethod("location", arguments: location)
    }
  }
}
