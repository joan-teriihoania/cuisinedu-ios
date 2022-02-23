//
//  TrackIntent.swift
//  Test_Cours_listUI
//
//  Created by m1 on 16/02/2022.
//

import Foundation
import Combine

enum IngredientIntentState: Equatable, CustomStringConvertible {
    static func == (lhs: IngredientIntentState, rhs: IngredientIntentState) -> Bool {
        return lhs.description == rhs.description
    }
    
    case READY
    case CHANGING_UNIT(Unit)
    case CHANGING_CATEGORY(IngredientCategory)
    case CHANGING_NAME(String)
    case CHANGING_PRICE(Double)
    case DELETING
    case LIST_UPDATED
    
    var description: String {
        switch self {
            case .READY:
                return "Ready"
            case .CHANGING_NAME(let name):
                return "Changing name to \(name)"
            case .CHANGING_UNIT(let unit):
                return "Changing unit to \(unit.name)"
            case .CHANGING_CATEGORY(let cat):
                return "Changing category to \(cat.name)"
            case .CHANGING_PRICE(let price):
                return "Changing price to \(price)"
            case .DELETING:
                return "Deleting"
            case .LIST_UPDATED:
                    return "List updated"
        }
    }
}

class IngredientIntent: ObservableObject {
    private var state = PassthroughSubject<IngredientIntentState, Never>()
    
    func intentToChange(name: String){
        self.state.send(.CHANGING_NAME(name))
        self.state.send(.LIST_UPDATED)
    }
    
    func intentToChange(unit: Unit){
        self.state.send(.CHANGING_UNIT(unit))
        self.state.send(.LIST_UPDATED)
    }
    
    func intentToChange(category: IngredientCategory){
        self.state.send(.CHANGING_CATEGORY(category))
        self.state.send(.LIST_UPDATED)
    }
    
    func intentToChange(price: Double){
        self.state.send(.CHANGING_PRICE(price))
        self.state.send(.LIST_UPDATED)
    }
    
    func intentToDelete(){
        self.state.send(.DELETING)
        self.state.send(.LIST_UPDATED)
    }
    
    func addObserver(vm: IngredientViewModel){
        self.state.subscribe(vm)
    }
}
