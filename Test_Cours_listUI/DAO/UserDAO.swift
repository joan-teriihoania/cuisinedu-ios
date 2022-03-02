//
//  UserDAO.swift
//  Test_Cours_listUI
//
//  Created by m1 on 23/02/2022.
//

import Foundation

class UserDAO {
    static func get(callback: @escaping (Result<User, ApiServiceError>) -> Void){
        ApiService.get(UserDTO.self, route: "/account", onsuccess: { user in
            callback(.success(user.toUser()))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
}
