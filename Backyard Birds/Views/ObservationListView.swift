import FirebaseFirestore
import SwiftUI

struct ObservationListView: View {
    @Environment(AuthController.self) private var authController
    @State private var observations: [BirdObservation] = []
    @State private var selectedSpecies: Species = .alle

    private var firestoreService = FirestoreObservationService()

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.1, green: 0.3, blue: 0.1)
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Mine observationer")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 16)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Filtrér art")
                            .font(.title3)
                            .foregroundColor(.white)
                            .fontWeight(.semibold)

                        Picker("Art", selection: $selectedSpecies) {
                            ForEach(Species.allCases) { species in
                                Text(species.displayName).tag(species)
                            }
                        }
                        .pickerStyle(.menu)
                        .accentColor(.white)
                        .onChange(of: selectedSpecies) { oldValue, newValue in
                            fetchFilteredObservations()
                        }
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)

                    if observations.isEmpty {
                        Spacer()
                        Text("Ingen observationer endnu.")
                            .font(.title2)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                        Spacer()
                    } else {
                        List {
                            ForEach(observations) { observation in
                                NavigationLink(destination: ObservationDetailView(observation: observation)) {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(observation.species.capitalized)
                                            .font(.title3)
                                            .fontWeight(.semibold)

                                        Text(observation.date.formatted(date: .abbreviated, time: .shortened))
                                            .font(.body)
                                    }
                                    .padding(.vertical, 12)
                                }
                            }
                            .onDelete(perform: deleteObservation)
                        }
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            fetchFilteredObservations()
        }
        .onDisappear {
            firestoreService.stopListening()
        }
    }

    private func fetchFilteredObservations() {
        guard let uid = authController.user?.uid else { return }

        firestoreService.listenToUserObservations(
            userID: uid,
            species: selectedSpecies == .alle ? nil : selectedSpecies.rawValue
        ) { fetched in
            self.observations = fetched
        }
    }

    private func deleteObservation(at offsets: IndexSet) {
        for index in offsets {
            let observation = observations[index]
            firestoreService.deleteObservation(observation)
        }
    }
}
