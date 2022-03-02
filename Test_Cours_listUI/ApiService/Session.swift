//
//  Session.swift
//  Test_Cours_listUI
//
//  Created by m1 on 23/02/2022.
//

import SwiftUI

class Session: ObservableObject {
    static var session: Session = Session()
    @Published var user: User? {
        didSet {
            objectWillChange.send()
        }
    }
    
    static func getSession() -> Session {
        return session
    }
    
    private init(){
        updateStatus()
    }
    
    func isLogged() -> Bool{
        return user != nil
    }
    
    func updateStatus(){
        UserDAO.get(callback: {result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let user):
                        self.user = user
                    case .failure(_):
                        self.user = nil
                }
            }
        })
    }
}
