//
//  AuthenticationController.swift
//  SmartShop
//
//  Created by 안재원 on 2025/06/02.
//

import Foundation

// MARK: 로그인 회원가입 인증 컨트롤러
struct AuthenticationController {
    
    let httpClient: HTTPClient
    
    func register(username: String, password: String) async throws -> RegisterResponse {
        
        let body = ["username": username, "password": password]
        let bodyData = try JSONEncoder().encode(body)
        
        let resource = Resource(url: Constants.Urls.register, method: .post(bodyData), modelType: RegisterResponse.self)
        let response = try await httpClient.load(resource)
        
        return response
    }
}

// MARK: 개발 목적으로 제공한 것
extension AuthenticationController {
    static var develpoment: AuthenticationController {
        AuthenticationController(httpClient: HTTPClient())
    }
}
