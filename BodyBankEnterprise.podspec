Pod::Spec.new do |s|
    s.name = 'BodyBankEnterprise'
    s.summary = 'BodyBank Enterprise iOS SDK'
    s.version = '0.1.6'
    s.author = 'Bodygram Inc.'
    s.license = { :type => 'MIT'}
    s.homepage = 'https://github.com/bodybank-sdk/BodyBank-SDK-iOS'
    s.platform = :ios, '10.0'
    s.swift_version = '5.3'
    s.source = {
        :http => "https://github.com/bodybank-sdk/BodyBank-SDK-iOS/raw/v0.1.6/BodyBankEnterprise.framework.zip",
        :sha1 => '823116e7f73cce7bbb747b3073978d2bf00b05cd'
    }
    s.ios.vendored_frameworks = 'BodyBankEnterprise.framework'
    s.dependency 'AWSAppSync', '~> 2.14.3' 
    s.dependency 'AWSS3', '~> 2.11.0'
    s.dependency 'ReachabilitySwift', '~> 4.3.0'
    s.dependency 'FCFileManager', '~> 1.0.20'
    s.dependency 'JWTDecode', '~> 2.3.0'
    s.dependency 'KeychainSwift', '~> 16.0.1'
end
