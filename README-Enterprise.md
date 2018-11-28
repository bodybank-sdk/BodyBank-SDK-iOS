# BodyBank Enterprise SDK Readme

## Version
2018-11-27-2
SDK Version 0.0.24

## Install
Use cocoapods.

```
pod 'BodyBankEnterprise'
```

When install, do
```
pod install
```

When update, do
```
pod update BodyBankEnterprise && pod install
```

## Usage


### Set up
Include the `bodybank-config.json` file into main bundle by dragging the file into project navigator on Xcode.
The file is provided after making a contract.

### Mobile SDK

#### Token Provider 
Instantiate the `DefaultTokenProvider` and set `restoreTokenBlock`.
This block is called whenever a token is nearly expired or expired.
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

```swift
    let tokenProvider = DirectTokenProvider(apiUrl: "https://api.<SHORT IDENTIFIER>.enterprise.bodybank.com", apiKey: "API KEY")
    tokenProvider.tokenDuration =  86400
    tokenProvider.userId = "unique user id"
    try! BodyBankEnterprise.initialize(tokenProvider: tokenProvider)
```

This class calls direct http request to the api server to refresh the token.
Please be careful that this embeds API Key in the app is vulnerable to API Key leakage.
Please implment your own `TokenProvider` or `restoreTokenBlock` on `DefaultTokenProvider`

Everytime identityId changes, do
```swift
BodyBankEnterprise.clearCredentials()
```

#### SDK initialization

Initialize BodyBank in `AppDelegate.swift`

```swift
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
```swift
BodyBankEnterprise.defaultTokenProvider()

```
Please modify jwt using this reference.

#### Create New BodyBank Estimation Request
```swift
var params = EstimationParameter()
params.frontImage = Estimation.shared.frontImage
params.sideImage = Estimation.shared.sideImage
params.heightInCm = Estimation.shared.heightInCm
params.weightInKg = Estimation.shared.weight!
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

```swift
BodyBankEnterprise.subscribeUpdateOfEstimationRequests(callback: { (request, errorss) in
    print(errors)
})


BodyBankEnterprise.unsubscribeEstimationRequests()

```

#### Get images
```swift
let url = request.frontImage?.downloadableURL
//Do anything with pre-signed downloadable URL
//It has expiration time.

```



