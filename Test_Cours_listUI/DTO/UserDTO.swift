//
//  User.swift
//  Test_Cours_listUI
//
//  Created by m1 on 23/02/2022.
//

import Foundation

class UserDTO: ObservableObject, Decodable {
    @Published var username: String
    @Published var email: String
    @Published var avatarURL: String
    
    private enum CodingKeys: String, CodingKey {
        case username = "username"
        case email = "email"
        case avatarURL = "img_profile"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        username = try values.decode(String.self, forKey: .username)
        email = try values.decode(String.self, forKey: .email)
        avatarURL = try values.decode(String.self, forKey: .avatarURL)
    }
    
    func toUser() -> User {
        return User(username: username, email: email, avatarURL: avatarURL)
    }
    
    static func toUser(userDTOs: [UserDTO]) -> [User]{
        var users: [User] = []
        
        for userDTO in userDTOs {
            users.append(userDTO.toUser())
        }
        
        return users
    }
}
