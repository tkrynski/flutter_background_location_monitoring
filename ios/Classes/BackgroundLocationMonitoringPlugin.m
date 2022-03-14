#import "BackgroundLocationMonitoringPlugin.h"
#if __has_include(<background_location_monitoring/background_location_monitoring-Swift.h>)
#import <background_location_monitoring/background_location_monitoring-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "background_location_monitoring-Swift.h"
#endif

@implementation BackgroundLocationMonitoringPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBackgroundLocationMonitoringPlugin registerWithRegistrar:registrar];
}
@end
