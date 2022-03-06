//
//  StepComponent.swift
//  Test_Cours_listUI
//
//  Created by m1 on 05/03/2022.
//

import Foundation

enum StepComponentEnum {
    case INGREDIENT(Ingredient)
    case STEP(Step)
    case RECIPE(Recipe)
}

protocol StepComponentAble {
    var id: Int { get }
    func setComponent(_: StepComponentAble)
    func equalComponent(_: StepComponentAble) -> Bool
    func cloneComponent() -> StepComponentAble
    
    func getIngredients() -> [Ingredient]
    func getName() -> String
    func getDescription() -> String
    func getDuration() -> Double
    func getObject() -> StepComponentEnum
    func addObserver(obs: StepComponentAbleObserver)
}

protocol StepComponentAbleObserver {
    func stepComponentAbleChanged(component: StepComponentAble)
}

enum StepComponentPropertyChange {
    case QUANTITY(Int)
    case COMPONENT(StepComponentAble)
}

protocol StepComponentObserver {
    func stepComponentChanged(quantity: Int)
    func stepComponentChanged(component: StepComponentAble)
}

class StepComponent: Equatable, StepComponentAbleObserver {
    func stepComponentAbleChanged(component: StepComponentAble) {
        notifyObservers(p: .COMPONENT(component))
    }
    
    static func == (lhs: StepComponent, rhs: StepComponent) -> Bool {
        return lhs.equal(component: rhs)
    }
    
    var id: Int
    var quantity: Int {
        didSet {
            notifyObservers(p: .QUANTITY(quantity))
        }
    }
    var component: StepComponentAble {
        didSet {
            notifyObservers(p: .COMPONENT(component))
        }
    }
    var observers: [StepComponentObserver] = []
    
    
    func addObserver(obs: StepComponentObserver){
        observers.append(obs)
    }
    
    func notifyObservers(p: StepComponentPropertyChange){
        for observer in observers {
            switch p {
                case .COMPONENT(let component):
                    observer.stepComponentChanged(component: component)
                case .QUANTITY(let quantity):
                    observer.stepComponentChanged(quantity: quantity)
            }
        }
    }
    
    init(id: Int, quantity: Int, component: StepComponentAble){
        self.id = id
        self.quantity = quantity
        self.component = component
        
        component.addObserver(obs: self)
    }
    
    func set(component: StepComponent){
        self.id = component.id
        self.quantity = component.quantity
        self.component = component.component
        
        self.component.addObserver(obs: self)
    }
    
    func clone() -> StepComponent {
        return StepComponent(id: self.id, quantity: self.quantity, component: self.component.cloneComponent())
    }
    
    func equal(component: StepComponent) -> Bool {
        return self.id == component.id && self.quantity == component.quantity && self.component.equalComponent(component.component)
    }
}
