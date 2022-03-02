//
//  Unit.swift
//  Test_Cours_listUI
//
//  Created by m1 on 17/02/2022.
//

import Foundation

enum UnitPropertyChange {
    case NAME(String)
}

protocol UnitObserver {
    func unitChanged(name: String)
}

class Unit {
    var id: Int
    var name: String {
        didSet {
            notifyObservers(p: .NAME(name))
        }
    }
    var observers: [UnitObserver] = []
    
    init(id: Int, name: String){
        self.id = id
        self.name = name
    }
    
    func addObserver(obs: UnitObserver){
        observers.append(obs)
    }
    
    func notifyObservers(p: UnitPropertyChange){
        for observer in observers {
            switch p {
                case .NAME(let name):
                    observer.unitChanged(name: name)
            }
        }
    }
    
    func clone() -> Unit{
        return Unit(id: self.id, name: self.name)
    }
    
    func equal(unit: Unit) -> Bool{
        return unit.id == self.id && unit.name == self.name
    }
    
    func set(unit: Unit){
        self.id = unit.id
        self.name = unit.name
    }
    
}
