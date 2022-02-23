//
//  ErrorVM.swift
//  Test_Cours_listUI
//
//  Created by m1 on 16/02/2022.
//

import Foundation

class ErrorVM {
    var reason: String
    
    init(_ reason: String){
        self.reason = reason
    }

    var description: String {
        return reason
    }
}
