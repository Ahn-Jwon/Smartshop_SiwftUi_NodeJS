//
//  RigistarationsScreen.swift
//  SmartShop
//
//  Created by 안재원 on 2025/06/05.
//

import SwiftUI

struct RigistarationsScreen: View {
    
    @Environment(\.authenticationController) private var authenticationController //환경을 사용하여 인증컨트롤러 연결
    @Environment(\.dismiss) private var dismiss
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var message: String = ""
    
    private var isFormValid: Bool { // Id와 패스워드의 유무
        !username.isEmptyOrWhitespace && !password.isEmptyOrWhitespace
    }
    
    private func register() async {
        
        do {
            let response = try await authenticationController.register(username: username, password: password)
            
            if response.success {
                dismiss()
            } else {
                message = response.message ?? ""
            }
        } catch {
            message = error.localizedDescription
        }
        
        username = ""
        password = ""
    }
    
    var body: some View {
        Form {
            TextField("User name", text: $username)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
            Button("Register") {
                Task {
                    await register()
                }
            }.disabled(!isFormValid)
            
            Text(message)
        }.navigationTitle("Register")
    }
}

#Preview {
    NavigationStack {
        RigistarationsScreen()
    }.environment(\.authenticationController, .develpoment)
}
