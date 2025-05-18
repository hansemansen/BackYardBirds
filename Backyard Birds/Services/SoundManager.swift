import AVFoundation

final class SoundManager {
    static let shared = SoundManager()
    private var player: AVAudioPlayer?

    func play(_ name: String, withExtension ext: String = "wav") {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
            print("Kunne ikke finde lydfilen '\(name).\(ext)'")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("❗️Fejl ved afspilning af '\(name).\(ext)': \(error.localizedDescription)")
        }
    }
}
