# BodyBank Enterprise SDK Readme
本SDKは下記の機能を提供します。

1. トークンの発行・再発行
2. body size estimationリクエストの作成
3. body size estimationのステータスのサブスクリプション
4. body size estimationsの結果データ取得

本SDKにはUIは一切含まれません。

UIのサンプルとして、[UI SDK](https://github.com/bodybank-sdk/BodyBank-SDK-iOS-UI)を提供しています。  
UI SDKのソースはopenですので、必要に応じてforkもしくは実装の確認などにご利用ください。

なお、UI SDKは本SDKと同時に利用することを前提とした作りとなっております。  
UI SDKそのものはアプリとして立ち上げることは出来ません。ご了承ください。  

## Supported iOS Version
iOS10 or higher

## Requirement
ご契約後に次のアイテムをお渡しします。

- bodybank-config.json
- Bodybank API key
- Bodybank API endpoint

`bodybank-config.json`はプロジェクトルートに存在する必要があります。  
Xcodeのプロジェクトナビゲーターにドラッグし、追加してください。  

`API key`及び`API endpoint`はトークンの取得の際に利用します。  

また、body size estimationのリクエスト作成には下記の項目が必要となります。  

- 身長
- 体重
- 年齢
- 性別
- 測定対象の正面写真 (撮影角度が水平である必要あり)
- 測定対象の側面写真 (撮影角度が水平である必要あり)

そのため、SDK利用者は最低限として下記を実装する必要があります。

- 身長、体重、年齢、性別の入力フォーム
- 傾き検知が可能なカメラビュー

## インストール
cocoapodsからインストールが可能です。

```
pod 'BodyBankEnterprise'
```

## 利用方法
### Token Provider 

本SDKが提供する機能を利用するため、トークンの発行が必要です。  

`AppDelegate.swift`内で`DefaultTokenProvider`をインスタンス化し、トークン取得処理を`restoreTokenBlock`にセットしてください。  
`restoreTokenBlock`はトークンが失効ないし失効しかけている場合にSDK内部的に呼ばれます。  

なお、下記のサンプルコードにおいては、トークン取得処理をGoogle Cloud Functionsに登録し、意図的に隠蔽しています。  
これは、アプリ内への`API key`及び`API endpoint`の記述を避け、流出を防ぐためです。  
SDKを利用される方は、自社APIサーバもしくはCloud Functionsなどを用い、`API key`及び`API endpoint`の秘匿に努めていただくようお願いします。

```swift
let tokenProvider = DefaultTokenProvider() // DefaultTokenProviderのインスタンス化

tokenProvider.setRestoreTokenBlock(block: {[unowned self] callback in
  let token = BodyBankToken() // BodyBankTokenのインスタンス化

  // トークンを再発行して得られるjwt_token と identity_idからBodyBankTokenを作成します
  // tokenの取得が成功・失敗いずれの場合も、最後にcallback(token, error)をコールしてください
  // 下記はCloud Functionsを用いた場合のトークン取得処理の例となっています
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

#### トークン取得処理

`API key`及び`API endpoint`を利用して、トークンを取得することができます。  
また、`userId`はユーザーのユニークな情報をハッシュ化したものなどを推奨します。  

実装はSDK利用者の環境によりますが、例としてGoogle Cloud Functionsに実装した場合のjavascriptでの取得処理は下記のようになります。  

```javascript
exports.getBodyBankJWTToken = functions.https.onCall((data, context) => {
    if (!context.auth) {
        throw new functions.https.HttpsError("failed-precondition", 'Only authenticated user can call this function')
    }

    const apiKey = "YOUR_API_KEY";
    const apiEndpoint = "YOUR_API_ENDPOINT";
    const userId = "HASHED_USER_ID"; // ユーザーidをそのまま入れるのではなく、ユーザーを特定できる文字列のHash値などをご利用ください

    return new Promise((resolve, reject) => {
        return request.post(apiEndpoint, {
            headers: {"x-api-key": apiKey},
            json: {user_id: userId}
        }, (error, response, body) => {
            if (error) {
                reject(error)
            } else {
                const identityId = body.content.token.identity_id;
                const documentReference = admin.firestore().collection('version').doc('1').collection('TABLE_NAME').doc(userId);
                documentReference.set({"bodyBankUserId": identityId}, {merge: true}).then((value) => {
                    resolve(body.content.token);
                }).catch((reason) => {
                    reject(reason);
                });
            }
        });
    });
});
```


#### 開発用Token Provider

開発用に取り急ぎトークンを取得したい場合、`DirectTokenProvider`を利用することができます。  

```swift
let tokenProvider = DirectTokenProvider(apiUrl: "https://api.<SHORT IDENTIFIER>.enterprise.bodybank.com", apiKey: "API key")

tokenProvider.tokenDuration = 86400 // こちらは必須項目ですので、そのまま記載ください。
tokenProvider.userId = "unique user id" // こちらで指定したuserIdに対してユニークなトークンが発行されます。
```

### SDKの初期化処理

`AppDelegate.swift`内でSDKの初期化を行ってください。
初期化の際には、前述した`tokenProvider`が必要となります。

```swift
import BodyBankEnterprise

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool{
  let tokenProvider = DefaultTokenProvider()

  tokenProvider.setRestoreTokenBlock(block: {[unowned self] callback in
    let token = BodyBankToken()　// (補足※1)
    // トークンを再発行して得られるjwt_token と identity_idからBodyBankTokenを作成します
    callback(token, nil)
  })

  try! BodyBankEnterprise.initialize(tokenProvider: tokenProvider)

  return true
}
```

### SDKの初期化処理(補足※1）
上記のGoogle Cloud Functionsで作成した
getBodyBankJWTTokenを使用した場合, 以下の様にTokenを入れることができます
```
if Auth.auth().currentUser != nil {
            
            // Google Cloud Functions　で用意したFunctionを叩き、tokenとidを取得する
            let functions = Functions.functions()
            functions.httpsCallable("getBodyBankJWTToken").call {(result, error) in

                if let error = error {
                    callback((nil, error))
                    return
                }
                
                //　上記※１の実態 (通信で取得してきたtokenを入れる)
                var token = BodyBankToken()
                
                if let jwtToken = (result?.data as? Dictionary<String, Any>)?["jwt_token"] as? String{
                    token.jwtToken = jwtToken
                }
                                        
                if let identityId = (result?.data as? Dictionary<String, Any>)?["identity_id"] as? String{
                    token.identityId = identityId
                }

                callback((token, nil))
            }
        }
```

### SDK初期化後のjwtトークン修正

アクティブな`DefaultTokenProvider`は下記のように取得できます。  

```swift
BodyBankEnterprise.defaultTokenProvider()
```

必要に応じて、上記を利用してjwtトークンを書き換えてください。

### リクエストステータスのサブスクリプション

推定が完了するには数十秒程度の時間がかかりますので、推定完了もしくは失敗のタイミングで何かしらの処理を行う場合、  
`subscribeUpdateOfEstimationRequests`でリクエストステータスの変更をsubscribeできます。  
最終的なリクエストのステータスは`completed`または`failed`ですので、成功・失敗に応じた処理を行いたい場合は下記サンプルのように記述してください。  

subscribeは、リクエストを送信する前に有効化してください。  

また、subscribeを解除したい場合は`unsubscribeEstimationRequests`をコールしてください。

```swift
BodyBankEnterprise.subscribeUpdateOfEstimationRequests(callback: { (request, errors) in
  if let errors = errors{
    print(errors)
  } else {
    if let request = request, let id = request.id {
      if request.status == .completed {
        // 成功時の処理
      } else if request.status == .failed {
        // 失敗時の処理
      }
    }
  }
})


BodyBankEnterprise.unsubscribeEstimationRequests()

```

### body size estimationの新規リクエスト作成

`createEstimationRequest`で、新規推定リクエストの作成を行うことができます。  
第一引数の`estimationParameter`には、`EstimationParameter`型を利用してください。  
第二引数のcallbackは、推定リクエストが正常に作成された場合・作成出来なかった場合、いずれの場合もコールされます。  
下記サンプルのように、必要な処理を設定してください。  

リクエストは、全ての必須パラメータが揃うタイミング(カメラで正面・側面写真を取り終わった瞬間など)でコールしてください。

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

### 送信済み推定リクエストの取得

利用中ユーザーが行った全ての推定リクエストを取得する`listEstimationRequests`  
引数にidを指定し、特定リクエストの詳細を取得する`getEstimationRequest`  
が用意されています。  

ユーザーが過去に行ったリクエストのリストを出力したい場合や、  
直前のリクエストの詳細結果を取得したい場合などに利用してください。  

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

### 画像の取得

```swift
let url = request.frontImage?.downloadableURL
```
