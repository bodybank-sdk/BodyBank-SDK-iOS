Pod::Spec.new do |s|
    s.name = 'BodyBankEnterprise'
    s.summary = 'BodyBank Enterprise iOS SDK'
    s.version = '0.1.0'
    s.author = 'Bodygram Inc.'
    s.license = { :type => 'MIT'}
    s.homepage = 'https://github.com/bodybank-sdk/BodyBank-SDK-iOS'
    s.platform = :ios, '10.0'
    s.swift_version = '4.2'
    s.source = {
        :http => "https://github.com/bodybank-sdk/BodyBank-SDK-iOS/raw/master/BodyBankEnterprise.framework.zip"
    }
    s.ios.vendored_frameworks = 'BodyBankEnterprise.framework'
    s.dependency 'AWSAppSync', '2.9.1'
    s.dependency 'AWSS3', '2.8.4'
    s.dependency 'ReachabilitySwift', '4.3.0'
    s.dependency 'FCFileManager', '1.0.20'
    s.dependency 'JWTDecode', '2.1.1'
    s.dependency 'KeychainSwift', '13.0.0'
end
