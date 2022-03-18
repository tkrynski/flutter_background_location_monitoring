#import "FlutterBackgroundLocationMonitoringPlugin.h"
#if __has_include(<flutter_background_location_monitoring/flutter_background_location_monitoring-Swift.h>)
#import <flutter_background_location_monitoring/flutter_background_location_monitoring-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_background_location_monitoring-Swift.h"
#endif

@implementation FlutterBackgroundLocationMonitoringPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterBackgroundLocationMonitoringPlugin registerWithRegistrar:registrar];
}
@end
