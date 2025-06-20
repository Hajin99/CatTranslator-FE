//
//  JoinResponse.swift
//  CatTranslator
//
//  Created by 김하진 on 6/20/25.
//

import Foundation

struct JoinResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let reslt: JoinResult?
}

struct JoinResult: Codable {
    let memberId: Int
    let createdAt: String
}
