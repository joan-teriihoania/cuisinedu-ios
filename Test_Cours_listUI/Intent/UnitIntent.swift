//
//  TrackIntent.swift
//  Test_Cours_listUI
//
//  Created by m1 on 16/02/2022.
//

import Foundation
import Combine

enum UnitIntentState: Equatable, CustomStringConvertible {
    case READY
    case CHANGING_NAME(String)
    case DELETING
    case LIST_UPDATED
    
    var description: String {
        switch self {
            case .READY:
                return "Ready"
            case .CHANGING_NAME(let name):
                return "Changing name to \(name)"
            case .DELETING:
                return "Deleting"
            case .LIST_UPDATED:
                    return "List updated"
        }
    }
}

class UnitIntent: ObservableObject {
    private var state = PassthroughSubject<UnitIntentState, Never>()
    
    func intentToChange(name: String){
        self.state.send(.CHANGING_NAME(name))
        self.state.send(.LIST_UPDATED)
    }
    
    func intentToDelete(){
        self.state.send(.DELETING)
        self.state.send(.LIST_UPDATED)
    }
    
    func addObserver(vm: UnitViewModel){
        self.state.subscribe(vm)
    }
}
