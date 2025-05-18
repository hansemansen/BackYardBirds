import SwiftUI
import FirebaseAuth

struct AddObservationView: View {
    @Environment(AuthController.self) private var authController
    @StateObject private var firestoreController = FirestoreController()
    @Binding var isPresented: Bool

    @State private var selectedSpecies: Species = .solsort
    @State private var note: String = ""
    @State private var showingErrorAlert = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Fugleart").foregroundColor(.white)) {
                    Picker("Vælg art", selection: $selectedSpecies) {
                        ForEach(Species.actualSpecies) { art in
                            Text(art.displayName).foregroundColor(.black).tag(art)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section(header: Text("Note").foregroundColor(.white)) {
                    TextEditor(text: $note)
                        .frame(height: 100)
                        .foregroundColor(.black)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(red: 0.1, green: 0.3, blue: 0.1))
            .navigationTitle("Ny observation")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Gem") {
                        Task {
                            await gemObservation()
                        }
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuller") {
                        isPresented = false
                    }
                }
            }
            .alert("Fejl", isPresented: $showingErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(firestoreController.errorMessage ?? "Ukendt fejl")
            }
        }
        .onChange(of: firestoreController.didSucceed) { oldValue, newValue in
            if newValue {
                isPresented = false
            }
        }
    }

    private func gemObservation() async {
        if let uid = authController.user?.uid {
            await firestoreController.addObservation(
                species: selectedSpecies,
                note: note,
                userID: uid
            )

            if firestoreController.errorMessage != nil {
                showingErrorAlert = true
            }
        }
    }
}
