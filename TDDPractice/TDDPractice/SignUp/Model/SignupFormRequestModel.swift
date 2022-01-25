//
//  SignupFormRequestModel.swift
//  TDDPractice
//
//  Created by 김윤석 on 2022/01/24.
//

import Foundation

struct SignupFormRequestModel: Encodable{
    let firstName: String
    let lastName: String
    let email: String
    let password: String
}
