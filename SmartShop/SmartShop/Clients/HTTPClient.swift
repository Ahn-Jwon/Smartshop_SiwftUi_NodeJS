//
//  HTTPClient.swift
//  SmartShop
//
//  Created by 안재원 on 2025/06/02.
//

// MARK: 네트워크 통신을 할 서비스와 유사

import Foundation


// MARK: 네트워크 에러타입 정의
enum NetworkError: Error {
    case badRequest                     // URL이 잘못될 경우
    case decodingError(Error)           // JSON 디코딩 실패
    case invalidResponse                // HTTPURLResponse 형식 틀림
    case errorResponse(ErrorResponse)   // 서버에서 보내준 에러 응답
}

// MARK: Error의 설명 케이스로 구성
extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .badRequest:
                return NSLocalizedString("Bad Request (400): Unable to perform the request.", comment: "badRequestError")
            case .decodingError(let error):
                return NSLocalizedString("Unable to decode successfully. \(error)", comment: "decodingError")
            case .invalidResponse:
                return NSLocalizedString("Invalid response.", comment: "invalidResponse")
            case .errorResponse(let errorResponse):
                return NSLocalizedString("Error \(errorResponse.message ?? "")", comment: "Error Response")
        }
    }
}

// MARK: HTTP 메서드 정의
enum HTTPMethod {
    case get([URLQueryItem])    // GET 요청: 쿼리 파라미터 포함
    case post(Data?)            // POST 요청: JSON 데이터 포함 가능
    case delete                 // DELETE 요청
    case put(Data?)             // PUT 요청: JSON 데이터 포함 가능
    
    var name: String {
        switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            case .delete:
                return "DELETE"
            case .put:
                return "PUT"
        }
    }
}

// MARK: 요청에 필요한 리소스 정의
struct Resource<T: Codable> {
    let url: URL                            // API 엔드포인트
    var method: HTTPMethod = .get([])       // HTTP 메서드
    var headers: [String: String]? = nil    // 커스텀 헤더 (optional)
    var modelType: T.Type                   // 디코딩할 데이터 타입
}


// MARK: - HTTP 요청을 담당하는 클라이언트
struct HTTPClient {
    private let session: URLSession
    
    init() {  // 초기화 시 기본 헤더 설정 (JSON 형식)
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        self.session = URLSession(configuration: configuration)
    }
    
    // MARK: - 네트워크 요청 실행 함수
    func load<T: Codable>(_ resource: Resource<T>) async throws -> T {
        var request = URLRequest(url: resource.url)
        // HTTP 메서드에 따라 요청 구성
        switch resource.method {
            case .get(let queryItems):
                var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: false)
                components?.queryItems = queryItems
                guard let url = components?.url else {
                    throw NetworkError.badRequest
                }
                request.url = url
            case .post(let data), .put(let data):
                request.httpMethod = resource.method.name
                request.httpBody = data
                
            case .delete:
                request.httpMethod = resource.method.name
        }
        
        // 커스텀 헤더 추가
        if let headers = resource.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        // 실제 네트워크 요청 수행
        let (data, response) = try await session.data(for: request)
        
        // 응답 유효성 확인
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        // HTTP 상태 코드 확인
        switch httpResponse.statusCode {
            case 200...299:
                break // 정상 처리
            default:  // 서버가 보낸 에러 메시지를 파싱
                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                throw NetworkError.errorResponse(errorResponse)
        }
        // JSON 디코딩 시도
        do {
            let result = try JSONDecoder().decode(resource.modelType, from: data)
            return result
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}

extension HTTPClient {
    // MARK: - 개발용 싱글톤 인스턴스
    static var development: HTTPClient {
        HTTPClient()
    }
    
}

