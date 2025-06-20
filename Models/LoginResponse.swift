//
//  LoginResponse.swift
//  CatTranslator
//
//  Created by 김하진 on 6/20/25.
//

import Foundation

struct LoginResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let reslt: LoginResult?
}

struct LoginResult: Codable {
    let memberId: Int
    let nickname: String?
    let accessToken: String
}
