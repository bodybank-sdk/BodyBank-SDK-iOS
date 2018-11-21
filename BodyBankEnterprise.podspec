Pod::Spec.new do |s|
    s.name = 'BodyBankEnterprise'
    s.summary = 'BodyBank Enterprise iOS SDK'
    s.version = '0.0.15'
    s.author = 'Original Inc.'
    s.license = 'Proprietary'
    s.homepage = 'https://originalstitch.com'
    s.platform = :ios, '9.0'
    s.source = {
        :http => "https://github.com/skonb/BodyBankSDK/raw/master/BodyBankEnterprise.framework.zip"
    }
    s.ios.vendored_frameworks = 'BodyBankEnterprise.framework'
    s.dependency 'AWSAppSync', '2.6.24'
    s.dependency 'AWSS3', '2.7.3'
    s.dependency 'FCFileManager', '1.0.20'
    s.dependency 'JWTDecode', '2.1.1'
    s.dependency 'KeychainSwift', '13.0.0'
end
