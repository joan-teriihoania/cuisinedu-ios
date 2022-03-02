//
//  Unit.swift
//  Test_Cours_listUI
//
//  Created by m1 on 17/02/2022.
//

import Foundation

enum AllergenePropertyChange {
    case NAME(String)
}

protocol AllergeneObserver {
    func allergeneChanged(name: String)
}

class Allergene: Equatable {
    static func == (lhs: Allergene, rhs: Allergene) -> Bool {
        return lhs.equal(allergene: rhs)
    }
    
    var id: Int
    var name: String {
        didSet {
            notifyObservers(p: .NAME(name))
        }
    }
    var observers: [AllergeneObserver] = []
    
    init(id: Int, name: String){
        self.id = id
        self.name = name
    }
    
    func addObserver(obs: AllergeneObserver){
        observers.append(obs)
    }
    
    func notifyObservers(p: AllergenePropertyChange){
        for observer in observers {
            switch p {
                case .NAME(let name):
                    observer.allergeneChanged(name: name)
            }
        }
    }
    
    func clone() -> Allergene{
        return Allergene(id: self.id, name: self.name)
    }
    
    func equal(allergene: Allergene) -> Bool{
        return allergene.id == self.id && allergene.name == self.name
    }
    
    func set(allergene: Allergene){
        self.id = allergene.id
        self.name = allergene.name
    }
    
}
