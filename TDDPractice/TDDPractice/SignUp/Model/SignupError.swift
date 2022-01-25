//
//  SignupError.swift
//  TDDPractice
//
//  Created by 김윤석 on 2022/01/24.
//

import Foundation

enum SignupError: LocalizedError, Equatable {
    case invalidResponseModelParsing
    case invalidRequestURLString
    case failedRequest(description: String)
    
    var errorDescription: String?{
        switch self {
        case .failedRequest(let description):
            return description
            
        case .invalidRequestURLString, .invalidResponseModelParsing:
            return ""
        }
    }
}
