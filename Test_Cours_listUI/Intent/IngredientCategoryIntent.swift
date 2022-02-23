//
//  TrackIntent.swift
//  Test_Cours_listUI
//
//  Created by m1 on 16/02/2022.
//

import Foundation
import Combine

enum IngredientCategoryIntentState: Equatable, CustomStringConvertible {
    case READY
    case CHANGING_NAME(String)
    case LIST_UPDATED
    
    var description: String {
        switch self {
            case .READY:
                return "Ready"
            case .CHANGING_NAME(let name):
                return "Changing name to \(name)"
            case .LIST_UPDATED:
                    return "List updated"
        }
    }
}

class IngredientCategoryIntent: ObservableObject {
    private var state = PassthroughSubject<IngredientCategoryIntentState, Never>()
    
    func intentToChange(name: String){
        self.state.send(.CHANGING_NAME(name))
        self.state.send(.LIST_UPDATED)
    }
    
    func addObserver(vm: IngredientCategoryViewModel){
        self.state.subscribe(vm)
    }
}
