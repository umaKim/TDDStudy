//
//  TDDPracticeTests.swift
//  TDDPracticeTests
//
//  Created by 김윤석 on 2022/01/24.
//

import XCTest
@testable import TDDPractice

class TDDPracticeTests: XCTestCase {

    var signUpTest: SignUpWebService!
    var signFormRequestModel: SignupFormRequestModel!
    
    override func setUp() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: config)
        
        signUpTest = SignUpWebService(urlString: "https://tlyqhtlbn8.execute-api.us-east-1.amazonaws.com/prod/signup-mock-service/users", urlSession: urlSession)
        
        signFormRequestModel = SignupFormRequestModel(firstName: "Kim", lastName: "Nice", email: "g@gmail.com", password: "nice")
    }

    override func tearDown() {
        signUpTest = nil
        signFormRequestModel = nil
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.error = nil
    }

    func testSignupWebService_WhenGivenSuccessfullResponse_ReturnsSuccess() {
        
        //ARRANGE
        let jsonString = "{\"status\":\"ok\"}"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        
        let expectation = self.expectation(description: "signup web service response expectation")
        
        //ACT
        signUpTest.signup(withForm: signFormRequestModel) { (signupResponseModel, error) in
            
            //ASSERT
            XCTAssertEqual(signupResponseModel?.status, "ok")
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 5)
    }
    
    func testSignupWebService_WhenReceivedDifferentJSONResponse_ErrorTookPlace(){
        //ARRANGE
        let jsonString = "{\"path\":\"/users\",\"error\":\"Internal Server Error\"}"
        MockURLProtocol.stubResponseData = jsonString.data(using: .utf8)
        
        let expectation = self.expectation(description: "Signup() method expecation for a response that contains a different JSON structure")
        
        //ACT
        signUpTest.signup(withForm: signFormRequestModel) { (signupResponseModel, error) in
            
            //ASSERT
            XCTAssertNil(signupResponseModel, "The response model for a request containing unknown JSON response, should have been nil")
            XCTAssertEqual(error, SignupError.invalidResponseModelParsing, "signUp() Did not return expected error")
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 5)
    }
    
    func testSignupWebservice_WhenEmptyURLStringProvided_ReturnsError(){
        //ARRANGE
        let expectation = self.expectation(description: "An empty request URL string expectation")
        signUpTest = SignUpWebService(urlString: "")
        
        //ACT
        signUpTest.signup(withForm: signFormRequestModel) { signupResponseModel, error in
            
            //ASSERT
            XCTAssertEqual(error, SignupError.invalidRequestURLString, "the signup() method did not return an expected error for an invalidRequestURLString error")
            XCTAssertNil(signupResponseModel, "When an invalidRequestURLString takes place, the response model must be nil")
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 2)
    }
    
    func testSignupWebService_WhenURLRequestFails_ReturnsErrorMessageDescription() {
        //ARRANGE
        let expectation = self.expectation(description: "A failed Request expecation")
        let errorDescription = "A localized description of an error"
        MockURLProtocol.error = SignupError.failedRequest(description: errorDescription)
        
        //ACT
        signUpTest.signup(withForm: signFormRequestModel) { signupResponseModel, error in
            print(error)
            //ASSERT
//            XCTAssertEqual(error, SignupError.failedRequest(description: errorDescription))
//            XCTAssertEqual(error?.localizedDescription, errorDescription)
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 2)
        
    }
}
