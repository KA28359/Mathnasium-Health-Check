# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Mathnasium Health Check' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Mathnasium Health Check
    pod 'GoogleAPIClientForREST/Sheets'
    pod 'GoogleSignIn'
    pod 'SwiftJWT'
    pod 'Alamofire'

    post_install do |installer|
      installer.pods_project.build_configurations.each do |config|
        if config.name != 'Release'
          config.build_settings["VALID_ARCHS[sdk=iphonesimulator*]"] = "arm64 arm64e x86_64"
        end
      end
    end

end
