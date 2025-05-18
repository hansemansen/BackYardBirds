import SwiftUI

struct ContentView: View {
    @Environment(AuthController.self) private var authController

    var body: some View {
        if authController.isLoggedIn {
            MainAppView()
        } else {
            LoginView()
        }
    }
}
