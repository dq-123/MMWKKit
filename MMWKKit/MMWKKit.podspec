

Pod::Spec.new do |s|

  s.name         = "MMWKKit"
  s.version      = "1.2.5"
  s.summary      = "MMKit_WK"

  s.license      = { :type => "Apache-2.0", :file => "LICENSE" }
  s.homepage     = "https://google.com"
  s.author       = { "CoderDwang" => "Customer Service System" }

  s.platform     = :ios
  s.ios.deployment_target = "8.0"
  s.frameworks = "CoreLocation", "MobileCoreServices", "Security", "CoreGraphics", "SystemConfiguration", "CoreTelephony", "CoreFoundation", "CFNetwork", "JavaScriptCore", "UIKit", "Foundation"
  s.weak_frameworks = "UserNotifications"
  s.libraries = "sqlite3", "icucore", "c++", "resolv", "z"
  s.resources     = "MMKitResouce.bundle"
  s.xcconfig = {'OTHER_LDFLAGS' => '-ObjC'}
  s.xcconfig = {'OTHER_LDFLAGS' => '-all_load'}
  s.xcconfig = {'ENABLE_BITCODE' => 'NO'}
  s.source       = { :git => ""}
  s.vendored_frameworks = 'MMKit_WK.framework'

end


