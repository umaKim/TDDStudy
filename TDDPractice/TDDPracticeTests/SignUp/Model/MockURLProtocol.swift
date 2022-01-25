//
//  MockURLProtocol.swift
//  TDDPracticeTests
//
//  Created by 김윤석 on 2022/01/24.
//

import Foundation

class MockURLProtocol: URLProtocol {
    static var stubResponseData: Data?
    static var error: Error?
    
    override class func canInit(with request: URLRequest) -> Bool {
        
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        self.client?.urlProtocol(self, didLoad: MockURLProtocol.stubResponseData ?? Data())
        if let signupError = MockURLProtocol.error{
            self.client?.urlProtocol(self, didFailWithError: signupError)
        } else {
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    override func stopLoading() {
        
    }
}
