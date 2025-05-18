import FirebaseAuth

@Observable
class AuthController {
    private let authService = AuthService()
    
    var isLoggedIn = false
    var user: User? = nil

    func checkExistingUser() {
        user = authService.currentUser()
        isLoggedIn = user != nil
    }

    func logIn(email: String, password: String) async throws {
        user = try await authService.signIn(email: email, password: password)
        isLoggedIn = true
    }

    func logOut() {
        do {
            try authService.signOut()
            user = nil
            isLoggedIn = false
        } catch {
            print("Fejl ved log ud: \(error)")
        }
    }
}
