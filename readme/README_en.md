# BodyBank Enterprise SDK Readme
This SDK takes care of...

1. Creation & Restoration of token
2. Creation of new body size estimation request
3. Subscription of body size estimations' status
4. Getting result data of body size estimations

NO UI IS PROVIDED BY THIS SDK.

We provide an [UI SDK](https://github.com/bodybank-sdk/BodyBank-SDK-iOS-UI).
And the source of UI SDK is open, so please fork or take a look inside for yourself.

## Version
2018-12-21-1
SDK Version 0.0.35

## Update History
- 2018-12-21 Added failOnAutomaticEstimationFailure
- 2018-12-19 Added Android SDK

## Install
### iOS
Use cocoapods.

```
pod 'BodyBankEnterprise'
```

## Usage


### Set up
#### iOS
Include the `bodybank-config.json` file into main bundle by dragging the file into project navigator on Xcode.
The file is provided after making a contract.

### Mobile SDK

#### Token Provider 
Instantiate the `DefaultTokenProvider` and set `restoreTokenBlock`.
This block is called whenever a token is nearly expired or expired.
#### iOS
```swift
let tokenProvider = DefaultTokenProvider()
tokenProvider.setRestoreTokenBlock(block: {[unowned self] callback in
    let token = BodyBankToken()
    //Refresh token and create a BodyBank token from jwt_token & identity_id
    //Then call a callback with (token, error)
    //For example, if you want to get a token using firebase function
    let functions = Functions.functions()
    functions.httpsCallable("getBodyBankJWTToken").call {(result, error) in
        if let error = error{
            print(error.localizedDescription)
            callback(nil, error)
        }else{
            var token = BodyBankToken()
            if let jwtToken = (result?.data as? Dictionary<String, Any>)?["jwt_token"] as? String{
                token.jwtToken = jwtToken
            }
            if let identityId = (result?.data as? Dictionary<String, Any>)?["identity_id"] as? String{
                token.identityId = identityId
            }
            callback(token, nil)
        }
    }
})

```

#### DirectTokenProvider for development use only

Instantiate the `DirectTokenProvider` which is a descendent of `DefaultTokenProvider`
#### iOS
```swift
    let tokenProvider = DirectTokenProvider(apiUrl: "https://api.<SHORT IDENTIFIER>.enterprise.bodybank.com", apiKey: "API KEY")
    tokenProvider.tokenDuration =  86400
    tokenProvider.userId = "unique user id"
    try! BodyBankEnterprise.initialize(tokenProvider: tokenProvider)
```

#### SDK initialization
#### iOS
Initialize BodyBank in `AppDelegate.swift`
```
import BodyBankEnterprise

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool{
    let tokenProvider = DefaultTokenProvider()
    tokenProvider.setRestoreTokenBlock(block: {[unowned self] callback in
        let token = BodyBankToken()
        //Refresh token and specify jwt_token & identity_id
        callback(token, nil)
    })
    BodyBankEnterprise.initialize(tokenProvider: tokenProvider)
    return true
}
```

#### Modifying JWT Token after initialization
The active Default Token Provider can be fetched by
#### iOS
```swift
BodyBankEnterprise.defaultTokenProvider()

```
Please modify jwt using this reference.

#### Create New BodyBank Estimation Request

#### iOS
```swift
var params = EstimationParameter()
params.frontImage = Estimation.shared.frontImage
params.sideImage = Estimation.shared.sideImage
params.heightInCm = Estimation.shared.heightInCm
params.weightInKg = Estimation.shared.weight!
params.failOnAutomaticEstimationFailure = true
params.age = 30
params.gender = .male
BodyBankEnterprise.createEstimationRequest(estimationParameter: params, callback: { (request, errors) in
    if error == nil{
        print(request?.id)
    }else{
        print(error)
    }
})
```

#### Get BodyBank Estimation Requests
#### iOS
```swift
// List estimation requests
BodyBankEnterprise.listEstimationRequests(limit: 20, nextToken: nil, callback: { (requests, nextToken, errors) in
    print(requests)
})

// Get estimation request and result detail
BodyBankEnterprise.getEstimationRequest(id: id, callback: { (request, errors) in
    print(request)
})

```

#### Subscribe & Unsubscribe Changes

#### iOS
```swift
BodyBankEnterprise.subscribeUpdateOfEstimationRequests(callback: { (request, errorss) in
    print(errors)
})


BodyBankEnterprise.unsubscribeEstimationRequests()

```

#### Get images

#### iOS
```swift
let url = request.frontImage?.downloadableURL
//Do anything with pre-signed downloadable URL
//It has expiration time.

```




