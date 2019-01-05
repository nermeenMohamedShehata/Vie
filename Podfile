# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'Vie' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!
    
    # Pods for Vie
    #  #Network Layer dependencies
    pod 'Siesta', '~> 1.0'
    pod 'Siesta/UI', '~> 1.0'
    pod 'SwiftyJSON', '~> 4.0'
    #Utils/Extensions
    pod 'SwifterSwift'
    #For Localizable
    pod 'MOLH'
    #Cache
    pod 'Cache'
    #FireBase
    pod 'Firebase'
    pod 'Firebase/Auth'
    pod 'Firebase/Database'
    pod 'Firebase/Core'
    pod 'Firebase/DynamicLinks'
end
post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
