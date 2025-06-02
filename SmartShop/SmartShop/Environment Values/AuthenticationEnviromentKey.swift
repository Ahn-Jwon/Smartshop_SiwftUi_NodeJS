//
//  AuthenticationEnviromentKey.swift
//  SmartShop
//
//  Created by 안재원 on 2025/06/02.
//

import Foundation
import SwiftUI

// MARK: 환경Key
private struct AuthenticationEnviromentKey: EnvironmentKey {
    static let defaultValue = AuthenticationController(httpClient: HTTPClient())
}

extension EnvironmentValues {
    var authenticationController: AuthenticationController {
        get { self[AuthenticationEnviromentKey.self] }
        set { self[AuthenticationEnviromentKey.self] = newValue }
    }
}
