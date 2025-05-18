import Foundation
import FirebaseFirestore
import CoreLocation

@MainActor
class FirestoreController: ObservableObject {
    private let firestoreService = FirestoreService()
    private let locationManager = CLLocationManager()

    @Published var didSucceed: Bool = false
    @Published var errorMessage: String?

    func addObservation(species: Species, note: String, userID: String) async {
        do {
            let location = try await fetchLocation()

            let observation = BirdObservation(
                id: UUID().uuidString,
                species: species.rawValue,
                date: Date(),
                note: note,
                location: GeoPoint(latitude: location.latitude, longitude: location.longitude)
            )

            firestoreService.saveObservation(observation)
            didSucceed = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func fetchLocation() async throws -> CLLocationCoordinate2D {
        guard let location = locationManager.location else {
            throw LocationError.notAvailable
        }
        return location.coordinate
    }

    enum LocationError: Error, LocalizedError {
        case notAvailable

        var errorDescription: String? {
            switch self {
            case .notAvailable:
                return "Lokation ikke tilgængelig – slå placering til i indstillinger."
            }
        }
    }
}
