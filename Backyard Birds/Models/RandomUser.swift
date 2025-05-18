//
//  RandomUser.swift
//  Backyard Birds
//
//  Created by dmu mac 26 on 12/05/2025.
//

struct RandomUser: Codable {
    let name: Name
    let email: String
    let login: Login
    
    struct Name: Codable {
        let first: String
        let last: String
    }
    
    struct Login: Codable {
        let username: String
        let password: String
    }
}

struct RandomUserResponse: Codable {
    let results: [RandomUser]
}
