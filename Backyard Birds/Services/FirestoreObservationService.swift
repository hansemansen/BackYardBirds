import FirebaseFirestore
import FirebaseAuth

class FirestoreObservationService {
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    func listenToUserObservations(
        userID: String,
        species: String? = nil,
        onUpdate: @escaping ([BirdObservation]) -> Void
    ) {
        listener?.remove()

        var query: Query = db.collection(userID)

        if let species = species {
            query = query.whereField("species", isEqualTo: species.lowercased())
        }

        listener = query.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                print("Firestore fejl: \(error?.localizedDescription ?? "ukendt")")
                onUpdate([])
                return
            }

            let observations = snapshot.documents.compactMap { doc in
                try? doc.data(as: BirdObservation.self)
            }
            .sorted(by: { $0.date > $1.date }) 

            onUpdate(observations)
        }
    }

    func stopListening() {
        listener?.remove()
        listener = nil
    }

    func deleteObservation(_ observation: BirdObservation) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("❗️Bruger ikke logget ind.")
            return
        }

        db.collection(uid).document(observation.id).delete { error in
            if let error = error {
                print("Fejl ved sletning: \(error.localizedDescription)")
            } else {
                print("Observation slettet: \(observation.id)")
            }
        }
    }
}
