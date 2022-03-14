import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class BackgroundLocationMonitoring {
  static const MethodChannel _channel = MethodChannel('background_location_monitoring');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static stopLocationService() async {
    return await _channel.invokeMethod('stop_monitoring');
  }

  static startVisitMonitoring(Function(Location) location) async {
    return await _channel.invokeMethod('start_monitoring');
  }

  static getLocationUpdates(Function(Location) locationCallback) {
    // add a handler on the channel to receive updates from the native classes
    _channel.setMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'location') {
        var locationData = Map.from(methodCall.arguments);
        locationCallback(
          Location(
              latitude: locationData['latitude'],
              longitude: locationData['longitude'],
              altitude: locationData['altitude'],
              accuracy: locationData['accuracy'],
              bearing: locationData['bearing'],
              speed: locationData['speed'],
              time: locationData['time'],
              isMock: locationData['is_mock']),
        );
      }
    });
  }

  static getVisitUpdates(Function(Visit) visitCallback) {
    // add a handler on the channel to receive updates from the native classes
    _channel.setMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'visit') {
        var visitData = Map.from(methodCall.arguments);
        visitCallback(
          Visit(
              latitude: visitData['latitude'],
              longitude: visitData['longitude'],
              accuracy: visitData['accuracy'],
              arrivalTime: visitData['arrivalTime'],
              departureTime: visitData['departureTime'],
              isMock: visitData['is_mock']),
        );
      }
    });
  }
}

class Location {
  double? latitude;
  double? longitude;
  double? altitude;
  double? bearing;
  double? accuracy;
  double? speed;
  double? time;
  bool? isMock;

  Location(
      {@required this.longitude,
        @required this.latitude,
        @required this.altitude,
        @required this.accuracy,
        @required this.bearing,
        @required this.speed,
        @required this.time,
        @required this.isMock});

  toMap() {
    var obj = {
      'latitude': latitude,
      'longitude': longitude,
      'altitude': altitude,
      'bearing': bearing,
      'accuracy': accuracy,
      'speed': speed,
      'time': time,
      'is_mock': isMock
    };
    return obj;
  }
}

class Visit {
  double? latitude;
  double? longitude;
  double? accuracy;
  double? arrivalTime;
  double? departureTime;
  bool? isMock;

  Visit(
      {@required this.longitude,
        @required this.latitude,
        @required this.accuracy,
        @required this.arrivalTime,
        @required this.departureTime,
        @required this.isMock});

  toMap() {
    var obj = {
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'arrivalTime': arrivalTime,
      'departureTime': departureTime,
      'is_mock': isMock
    };
    return obj;
  }
}
