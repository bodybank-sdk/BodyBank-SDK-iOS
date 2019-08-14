Pod::Spec.new do |s|
    s.name = 'BodyBankEnterprise'
    s.summary = 'BodyBank Enterprise iOS SDK'
    s.version = '0.0.48'
    s.author = 'Original Inc.'
    s.license = 'Proprietary'
    s.homepage = 'https://originalstitch.com'
    s.platform = :ios, '9.0'
    s.swift_version = '4.2'
    s.source = {
        :http => "https://github.com/bodybank-sdk/BodyBank-SDK-iOS/raw/feature/0.0.48/BodyBankEnterprise.framework.zip",
        :sha1 => '122508af7fb02a2db8536a5cc68c14e0f63060f4'
    }
    s.ios.vendored_frameworks = 'BodyBankEnterprise.framework'
    s.dependency 'AWSAppSync', '2.9.1'
    s.dependency 'AWSS3', '2.8.4'
    s.dependency 'ReachabilitySwift', '4.3.0'
    s.dependency 'FCFileManager', '1.0.20'
    s.dependency 'JWTDecode', '2.1.1'
    s.dependency 'KeychainSwift', '13.0.0'
end
