//
//  TrackIntent.swift
//  Test_Cours_listUI
//
//  Created by m1 on 16/02/2022.
//

import Foundation
import Combine

enum StepIntentState: Equatable, CustomStringConvertible {
    static func == (lhs: StepIntentState, rhs: StepIntentState) -> Bool {
        return lhs.description == rhs.description
    }
    
    case READY
    case CHANGING_NAME(String)
    case CHANGING_DESCRIPTION(String)
    case CHANGING_DURATION(Double)
    case ADDING_COMPONENT(StepComponent)
    case REMOVING_COMPONENT(StepComponent)
    case DELETING
    case LIST_UPDATED
    
    var description: String {
        switch self {
            case .READY:
                return "Ready"
            case .CHANGING_NAME(let name):
                return "Changing name to \(name)"
            case .CHANGING_DURATION(let duration):
                return "Changing duration to \(duration)"
            case .CHANGING_DESCRIPTION(let desc):
                return "Changing description to \(desc)"
            case .ADDING_COMPONENT(let component):
                return "Adding component \(component.component.getName())"
            case .REMOVING_COMPONENT(let component):
                return "Removing component \(component.component.getName())"
            case .DELETING:
                return "Deleting"
            case .LIST_UPDATED:
                    return "List updated"
        }
    }
}

class StepIntent: ObservableObject {
    private var state = PassthroughSubject<StepIntentState, Never>()
    
    func intentToAddComponent(component: StepComponent){
        self.state.send(.ADDING_COMPONENT(component))
        self.state.send(.LIST_UPDATED)
    }
    
    func intentToRemoveComponent(component: StepComponent){
        self.state.send(.REMOVING_COMPONENT(component))
        self.state.send(.LIST_UPDATED)
    }
    
    func intentToChange(name: String){
        self.state.send(.CHANGING_NAME(name))
        self.state.send(.LIST_UPDATED)
    }
    
    func intentToChange(description: String){
        self.state.send(.CHANGING_DESCRIPTION(description))
        self.state.send(.LIST_UPDATED)
    }
    
    func intentToChange(duration: Double){
        self.state.send(.CHANGING_DURATION(duration))
        self.state.send(.LIST_UPDATED)
    }
    
    func intentToDelete(){
        self.state.send(.DELETING)
        self.state.send(.LIST_UPDATED)
    }
    
    func addObserver(vm: StepViewModel){
        self.state.subscribe(vm)
    }
}
