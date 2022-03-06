//
//  User.swift
//  Test_Cours_listUI
//
//  Created by m1 on 23/02/2022.
//

import Foundation

class User: ObservableObject {
    var id: Int
    @Published var username: String
    @Published var email: String
    @Published var avatarURL: String
    
    init(id: Int, username: String, email: String, avatarURL: String){
        self.id = id
        self.username = username
        self.email = email
        self.avatarURL = avatarURL
    }
}
