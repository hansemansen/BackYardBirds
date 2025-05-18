import Foundation
import FirebaseFirestore

struct BirdObservation: Identifiable, Codable {
    var id: String
    var species: String
    var date: Date
    var note: String
    var location: GeoPoint
}
