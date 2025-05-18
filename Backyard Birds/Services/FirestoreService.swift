import Foundation
import FirebaseFirestore
import FirebaseAuth


class FirestoreService {
    private let db = Firestore.firestore()

    func saveObservation(_ observation: BirdObservation) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Bruger ikke logget ind.")
            return
        }

        do {
            try db.collection(uid)
                .document(observation.id)
                .setData(from: observation)

            print("Observation gemt direkte under users/\(uid)/")
        } catch {
            print("Fejl ved tilføjelse: \(error.localizedDescription)")
        }
    }
    
    func deleteObservation(_ observation: BirdObservation) {
           guard let uid = Auth.auth().currentUser?.uid else {
               print("Bruger ikke logget ind.")
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
