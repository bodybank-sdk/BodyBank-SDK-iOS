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
            return BodyBankToken(jwtToken: "eyJraWQiOiJhcC1ub3J0aGVhc3QtMTEiLCJ0eXAiOiJKV1MiLCJhbGciOiJSUzUxMiJ9.eyJzdWIiOiJhcC1ub3J0aGVhc3QtMTo5NmIzYTRiNC1hYWY4LTRiMjUtYjFkMS1iN2FlZjlkNTg5YjQiLCJhdWQiOiJhcC1ub3J0aGVhc3QtMTo1YTMwMjdjOS0yNmIxLTRkNzItYTE0MC0wZmNjZDA1MWIzNGIiLCJhbXIiOlsiYXV0aGVudGljYXRlZCIsImNvbS5ib2R5YmFuay5lbnRlcnByaXNlLnNhbXBsZSIsImNvbS5ib2R5YmFuay5lbnRlcnByaXNlLnNhbXBsZTphcC1ub3J0aGVhc3QtMTo1YTMwMjdjOS0yNmIxLTRkNzItYTE0MC0wZmNjZDA1MWIzNGI6c2tvbmIrdGVzdEBtZS5jb20iXSwiaXNzIjoiaHR0cHM6Ly9jb2duaXRvLWlkZW50aXR5LmFtYXpvbmF3cy5jb20iLCJleHAiOjE1Mzk3NjYwOTUsImlhdCI6MTUzOTc2NTE5NX0.C46DAFtCumwXy8P-S9Oq2OYFMkHcaz8ZN6g5Cj2ki1KZU2he-k2nBLe0ho_zAVBpZhIWmVJjXHFTaj4L4iK6n8ng2ExJ_QVsdCPmMXqSE19flP9Sp3Hi6In4kn_Wry8AxoJmV5HDGVsAaHGtx4QaXbyYFvm7Mt85wzFX1ZtcNAlsxE87ehN27zRBS8_JMZzYcAithwNDcjTK7MHVns37SVEBjCugotI5LlQ5VRTVOPWubDaNoLFtCPGE5sFLAsly6cM32zjILd30sbiEmJRXGvrqK5T9nGQhC8BtpQAgjNFS-BH7IQgUMuZRw5pXRpgzuBCi_M7Zj2CTQ06OFQBPug", identityId: "ap-northeast-1:96b3a4b4-aaf8-4b25-b1d1-b7aef9d589b4")
        }
    }
}
