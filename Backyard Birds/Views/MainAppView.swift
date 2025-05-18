import SwiftUI

struct MainAppView: View {
    @Environment(AuthController.self) private var authController
    @State var showAddObservationView = false
    private let locationController = LocationController() 

    var body: some View {
        let username = authController.user?.displayName ?? "Ukendt"

        NavigationStack {
            ZStack {
                Image("Billede")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack {
                    Spacer()

                    VStack(spacing: 20) {
                        Text("Velkommen, \(username)!")
                            .font(.title2)
                            .foregroundColor(.white)
                            .fontWeight(.bold)

                        NavigationLink("Alle observationer") {
                            ObservationListView()
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .font(.title3)
                        .fontWeight(.bold)

                        Button("Indtast observation") {
                            showAddObservationView = true
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .font(.title3)
                        .fontWeight(.bold)

                        Button("Log ud") {
                            authController.logOut()
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .font(.title3)
                        .foregroundColor(.white)
                        .tint(.red)
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
            .sheet(isPresented: $showAddObservationView) {
                AddObservationView(isPresented: $showAddObservationView)
                    .presentationDetents([.medium])
            }
        }
        .onAppear {
            locationController.requestAuthorization()
            SoundManager.shared.play("KikkerPaaFugle") 
        }
    }
}
