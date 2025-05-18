//
//  StartupController.swift
//  Backyard Birds
//
//  Created by dmu mac 26 on 12/05/2025.
//

import Foundation

class StartupController {
    
    private let seedFlagKey = "SeedUsers"
    
    func runStartupFlow() async {
        guard shouldSeedUsers() else {
            print("Brugere er allerede oprettede")
            return
        }
        
        do {
            let users = try await RandomUserService().fetchUsers(count: 10)
            
            for user in users {
                let email = user.email
                let password = user.login.password
                let displayName = user.login.username

                guard password.count >= 6 else {
                       print("Password for kort (\(password)) for: \(email)")
                       continue
                   }

                   do {
                       try await AuthService().createUser(
                           email: email,
                           password: password,
                           displayName: displayName
                       )
                       print("Oprettet: \(displayName) | \(email) | Password: \(password)")
                   } catch {
                       print("Fejl ved oprettelse af \(email): \(error)")
                   }
               }
            
            markAsSeeded()
            print("Alle brugere oprettet og markeret som seedet")
            
        } catch {
            print("Fejl under opstart: \(error)")
        }
    }
    
    private func shouldSeedUsers() -> Bool {
        return !UserDefaults.standard.bool(forKey: seedFlagKey)
    }

    private func markAsSeeded() {
        UserDefaults.standard.set(true, forKey: seedFlagKey)
    }
}
