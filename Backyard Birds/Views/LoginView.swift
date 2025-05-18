import SwiftUI

struct LoginView: View {
    @Environment(AuthController.self) private var authController

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?

    @FocusState private var emailIsFocused: Bool

    var body: some View {
        ZStack {
            Image("Billede")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: 16) {
                    Text("Login")
                        .font(.title)
                        .foregroundColor(.white)

                    TextField("Email", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal, 30)
                        .focused($emailIsFocused)

                    SecureField("Password", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal, 30)

                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }

                    Button("Log ind") {
                        Task {
                            do {
                                try await authController.logIn(
                                    email: email,
                                    password: password
                                )
                            } catch {
                                errorMessage = error.localizedDescription
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 10)
                    .fontWeight(.bold)
                }
                .padding()
                .frame(maxWidth: 320)
                .background(Color.green.opacity(0.5))
                .cornerRadius(16)
                .shadow(radius: 10)
                .padding(.bottom, 40)
            }
        }
        .task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            emailIsFocused = true
        }
    }
}
