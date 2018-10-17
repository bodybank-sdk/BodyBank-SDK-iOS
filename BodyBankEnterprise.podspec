#
#  Be sure to run `pod spec lint BodyBank.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#
Pod::Spec.new do |s|
    s.name = 'BodyBankEnterprise'
    s.summary = 'BodyBank Enterprise iOS SDK'
    s.version = '0.0.5'
    s.author = 'Original Inc.'
    s.license = 'Proprietary'
    s.homepage = 'https://originalstitch.com'
    s.platform = :ios, '10.0'
    s.source = {
        :http => "https://github.com/skonb/BodyBankSDK/raw/master/BodyBankEnterprise.framework.zip"
    }
    s.ios.vendored_frameworks = 'BodyBankEnterprise.framework'
    s.dependency 'AWSAppSync', '2.6.22'
    s.dependency 'AWSS3', '2.6.32'
    s.dependency 'FCFileManager', '1.0.20'
end
