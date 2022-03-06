//
//  Step.swift
//  Test_Cours_listUI
//
//  Created by m1 on 04/03/2022.
//

import Foundation

protocol StepObserver {
    func stepChanged(name: String)
    func stepChanged(description: String)
    func stepChanged(duration: Double)
    func stepChanged(components: [StepComponent])
}

enum StepPropertyChange {
    case NAME(String)
    case DESCRIPTION(String)
    case DURATION(Double)
    case COMPONENTS([StepComponent])
}

class Step: Equatable, StepComponentAble, ObservableObject {
    var stepComponentAbleObservers: [StepComponentAbleObserver] = []
    
    func addObserver(obs: StepComponentAbleObserver) {
        stepComponentAbleObservers.append(obs)
    }
    
    func setComponent(_ c: StepComponentAble) {
        switch c.getObject() {
            case .STEP(let step):
                set(step: step)
            default:
                break
        }
    }
    
    func equalComponent(_ c: StepComponentAble) -> Bool {
        switch c.getObject() {
            case .STEP(let step):
                return equal(step: step)
            default:
                return false
        }
    }
    
    func cloneComponent() -> StepComponentAble {
        return clone()
    }
    
    func getIngredients() -> [Ingredient] {
        var ingredients: [Ingredient] = []
        
        for component in components {
            ingredients.append(contentsOf: component.component.getIngredients())
        }
        
        return ingredients
    }
    
    func getName() -> String {
        return name
    }
    
    func getDescription() -> String {
        return description
    }
    
    func getDuration() -> Double {
        return duration
    }
    
    func getObject() -> StepComponentEnum {
        return .STEP(self)
    }
    
    static func == (lhs: Step, rhs: Step) -> Bool {
        return lhs.equal(step: rhs)
    }
    
    var id: Int
    @Published var name: String {
        didSet {
            notifyObservers(p: .NAME(name))
        }
    }
    @Published var description: String {
        didSet {
            notifyObservers(p: .DESCRIPTION(description))
        }
    }
    @Published var duration: Double {
        didSet {
            notifyObservers(p: .DURATION(duration))
        }
    }
    @Published var components: [StepComponent] {
        didSet {
            notifyObservers(p: .COMPONENTS(components))
        }
    }
    var observers: [StepObserver] = []
    
    init(id: Int, name: String, description: String, duration: Double, components: [StepComponent]){
        self.id = id
        self.name = name
        self.description = description
        self.duration = duration
        self.components = components
    }
    
    func addObserver(obs: StepObserver){
        observers.append(obs)
    }
    
    func notifyObservers(p: StepPropertyChange){
        for observer in stepComponentAbleObservers {
            observer.stepComponentAbleChanged(component: self)
        }
        
        for observer in observers {
            switch p {
                case .NAME(let name):
                    observer.stepChanged(name: name)
                case .DESCRIPTION(let desc):
                    observer.stepChanged(description: desc)
                case .DURATION(let duration):
                    observer.stepChanged(duration: duration)
                case .COMPONENTS(let components):
                    observer.stepChanged(components: components)
            }
        }
    }
    
    func clone() -> Step{
        return Step(id: self.id, name: self.name, description: self.description, duration: self.duration, components: cloneComponents())
    }
    
    private func cloneComponents() -> [StepComponent]{
        var cloned: [StepComponent] = []
        
        for component in components {
            cloned.append(component.clone())
        }
        
        return cloned
    }
    
    private func isComponentEqual(_ c: [StepComponent]) -> Bool {
        if c.count != self.components.count { return false }
        for i in 0..<c.count {
            if !c[i].equal(component: components[i]) { return false }
        }
        
        return true
    }
    
    func equal(step: Step) -> Bool{
        return (
            self.id == step.id &&
            self.name == step.name &&
            self.description == step.description &&
            self.duration == step.duration &&
            isComponentEqual(step.components)
        )
    }
    
    func set(step: Step){
        self.id = step.id
        self.name = step.name
        self.description = step.description
        self.duration = step.duration
        self.components = step.components
    }
}
