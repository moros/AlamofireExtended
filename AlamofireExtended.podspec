Pod::Spec.new do |spec|
    spec.name      = 'AlamofireExtended'
    spec.version   = '1.0.1'
    spec.license   = 'MIT'
    spec.summary   = 'Extension to Alamofire fire to make mocking easier.'
    spec.homepage  = 'https://github.com/moros/AlamofireExtended'
    spec.author    = { "Doug Mason" => "androidsoong@gmail.com" }
    spec.source    = { :git => "https://github.com/moros/AlamofireExtended.git", :tag => spec.version.to_s }
    
    spec.ios.deployment_target      = '10.0'
    spec.osx.deployment_target      = '10.12'
    spec.tvos.deployment_target     = '10.0'
    spec.watchos.deployment_target  = '3.0'
    
    spec.swift_versions = ['5.0', '5.1']
    spec.source_files   = 'Sources/**/*.swift'
    spec.dependency 'Alamofire', '~> 4.9.0'
end
