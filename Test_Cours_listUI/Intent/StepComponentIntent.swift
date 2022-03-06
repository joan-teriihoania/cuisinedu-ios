//
//  TrackIntent.swift
//  Test_Cours_listUI
//
//  Created by m1 on 16/02/2022.
//

import Foundation
import Combine

enum StepComponentIntentState: Equatable, CustomStringConvertible {
    static func == (lhs: StepComponentIntentState, rhs: StepComponentIntentState) -> Bool {
        return lhs.description == rhs.description
    }
    
    case READY
    case CHANGING_QUANTITY(Int)
    case DELETING
    case LIST_UPDATED
    
    var description: String {
        switch self {
            case .READY:
                return "Ready"
            case .CHANGING_QUANTITY(let qty):
                return "Changing quantity to \(qty)"
            case .DELETING:
                return "Deleting"
            case .LIST_UPDATED:
                    return "List updated"
        }
    }
}

class StepComponentIntent: ObservableObject {
    private var state = PassthroughSubject<StepComponentIntentState, Never>()
    
    func intentToChange(quantity: Int){
        self.state.send(.CHANGING_QUANTITY(quantity))
        self.state.send(.LIST_UPDATED)
    }
    
    func intentToDelete(){
        self.state.send(.DELETING)
        self.state.send(.LIST_UPDATED)
    }
    
    func addObserver(vm: StepComponentViewModel){
        self.state.subscribe(vm)
    }
}
