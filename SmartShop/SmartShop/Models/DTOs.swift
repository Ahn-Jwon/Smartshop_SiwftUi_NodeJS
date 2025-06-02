//
//  DTOs.swift
//  SmartShop
//
//  Created by 안재원 on 2025/06/02.
//

import Foundation

struct RegisterResponse: Codable {
    let message: String?
    let success: Bool
}

struct ErrorResponse: Codable {
    let message: String?
}
