//
//  String+Extensions.swift
//  SmartShop
//
//  Created by 안재원 on 2025/06/05.
//

import Foundation

extension String {
    
    var isEmptyOrWhitespace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
