//
//  SignUpWebService.swift
//  TDDPractice
//
//  Created by 김윤석 on 2022/01/24.
//

import Foundation

class SignUpWebService {
    private var urlSession: URLSession
    private let urlString: String
    
    init(urlString: String, urlSession: URLSession = .shared) {
        self.urlString = urlString
        self.urlSession = urlSession
    }
    
    func signup(withForm signFormModel: SignupFormRequestModel, completion: @escaping (SignupResponseModel?, SignupError?)-> Void) {
        
        guard let url = URL(string: urlString) else {
            completion(nil, SignupError.invalidRequestURLString)
            return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try? JSONEncoder().encode(signFormModel)
        
        urlSession.dataTask(with: request) { data, response, error in
            if let requestError = error {
                completion(nil, SignupError.failedRequest(description: requestError.localizedDescription))
                return
            }
            
             if let data = data,
                let signResponseModel = try? JSONDecoder().decode(SignupResponseModel.self, from: data) {
                 completion(signResponseModel, nil)
             } else {
                 completion(nil, SignupError.invalidResponseModelParsing)
             }
            
        }.resume()
    }
}
