//
//  TokenProvider.swift
//  Bodygram
//
//  Created by Shunpei Kobayashi on 2018/10/03.
//  Copyright © 2018 Original Inc. All rights reserved.
//

import Foundation
import BodyBankEnterprise

class TokenProvider: BodyBankTokenProvider{
    var token: BodyBankToken{
        get{
            return BodyBankToken(jwtToken: "", identityId: "")
        }
    }
}
