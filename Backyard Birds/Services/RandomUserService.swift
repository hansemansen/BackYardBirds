//
//  RandomUserService.swift
//  Backyard Birds
//
//  Created by dmu mac 26 on 12/05/2025.
//

import Foundation

class RandomUserService {
    func fetchUsers(count: Int) async throws -> [RandomUser] {
        guard
            let url = URL(string: "https://randomuser.me/api/?results=\(count)")
        else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(
            RandomUserResponse.self,
            from: data
        )
        return decoded.results
    }
}
