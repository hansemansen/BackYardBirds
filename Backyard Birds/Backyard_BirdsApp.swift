//
//  Backyard_BirdsApp.swift
//  Backyard Birds
//
//  Created by dmu mac 26 on 12/05/2025.
//

import FirebaseCore
import SwiftUI

@main
struct Backyard_BirdsApp: App {
    @State private var authController = AuthController()

    init() {
        FirebaseApp.configure()
        Task {
            await StartupController().runStartupFlow()
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(authController)
        }
    }
}
