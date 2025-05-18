import MapKit
import SwiftUI

struct ObservationDetailView: View {
    let observation: BirdObservation

    @State private var region = MKCoordinateRegion()

    var body: some View {
        ZStack {
            Color(red: 0.1, green: 0.3, blue: 0.1)
                .ignoresSafeArea()

            VStack {
                Map(
                    position: .constant(MapCameraPosition.region(region))
                ) {
                    Marker(
                        observation.species.capitalized,
                        coordinate: CLLocationCoordinate2D(
                            latitude: observation.location.latitude,
                            longitude: observation.location.longitude
                        )
                    )
                }
                .mapStyle(.standard)
                .frame(maxHeight: .infinity)
                .cornerRadius(16)
                .padding(.horizontal)

                VStack(spacing: 10) {
                    Text("Art: \(observation.species.capitalized)")
                    Text("Note: \(observation.note)")
                    Text("Dato: \(observation.date.formatted(date: .abbreviated, time: .shortened))")
                }
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            }
        }
        .onAppear {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: observation.location.latitude,
                    longitude: observation.location.longitude
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.01,
                    longitudeDelta: 0.01
                )
            )
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(
            Color(red: 0.1, green: 0.3, blue: 0.1),
            for: .navigationBar
        )
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
