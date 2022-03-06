//
//  TrackIntent.swift
//  Test_Cours_listUI
//
//  Created by m1 on 16/02/2022.
//

import Foundation
import Combine

enum RecipeIntentState: Equatable, CustomStringConvertible {
    static func == (lhs: RecipeIntentState, rhs: RecipeIntentState) -> Bool {
        return lhs.description == rhs.description
    }
    
    case READY
    case CHANGING_NAME(String)
    case CHANGING_NB_COUVERT(Int)
    case CHANGING_USER(User)
    case CHANGING_CATEGORY(RecipeCategory)
    case ADDING_STEP(Step, Int, Int)
    case REMOVING_STEP(Step)
    case DELETING
    case LIST_UPDATED
    
    var description: String {
        switch self {
            case .READY:
                return "Ready"
            case .CHANGING_NAME(let name):
                return "Changing name to \(name)"
            case .CHANGING_CATEGORY:
                return "Changing category"
            case .CHANGING_NB_COUVERT:
                return "Changing nb couvert"
            case .CHANGING_USER:
                return "Changing author user"
            case .ADDING_STEP(let step, let position, let quantity):
                return "Adding \(quantity) \(step.name) at position \(position)"
            case .REMOVING_STEP(let step):
                return "Removing \(step.name)"
            case .DELETING:
                return "Deleting"
            case .LIST_UPDATED:
                    return "List updated"
        }
    }
}

class RecipeIntent: ObservableObject {
    private var state = PassthroughSubject<RecipeIntentState, Never>()
    
    func intentToAddStep(step: Step, position: Int, quantity: Int){
        self.state.send(.ADDING_STEP(step, position, quantity))
        self.state.send(.LIST_UPDATED)
    }
    
    func intentToRemoveStep(step: Step){
        self.state.send(.REMOVING_STEP(step))
        self.state.send(.LIST_UPDATED)
    }
    
    func intentToChange(name: String){
        self.state.send(.CHANGING_NAME(name))
        self.state.send(.LIST_UPDATED)
    }
    
    func intentToChange(nb_couvert: Int){
        self.state.send(.CHANGING_NB_COUVERT(nb_couvert))
        self.state.send(.LIST_UPDATED)
    }
    
    func intentToChange(category: RecipeCategory){
        self.state.send(.CHANGING_CATEGORY(category))
        self.state.send(.LIST_UPDATED)
    }
    
    func intentToChange(user: User){
        self.state.send(.CHANGING_USER(user))
        self.state.send(.LIST_UPDATED)
    }
    
    func intentToDelete(){
        self.state.send(.DELETING)
        self.state.send(.LIST_UPDATED)
    }
    
    func addObserver(vm: RecipeViewModel){
        self.state.subscribe(vm)
    }
}
