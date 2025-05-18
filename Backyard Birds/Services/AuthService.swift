//
//  FireStoreService.swift
//  Backyard Birds
//
//  Created by dmu mac 26 on 14/05/2025.
//

import FirebaseAuth

class AuthService {
    
    func signIn(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func currentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    func createUser(email: String, password: String, displayName: String) async throws {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = authResult.user

            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = displayName
            try await changeRequest.commitChanges()

            print("Firebase bruger oprettet: \(displayName) | \(email)")
        } catch {
            if let err = error as NSError?, err.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                print("Email allerede i brug: \(email)")
            } else {
                throw error
            }
        }
    }
}

