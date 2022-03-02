//
//  IngredientCategory.swift
//  Test_Cours_listUI
//
//  Created by m1 on 17/02/2022.
//

import Foundation

protocol IngredientCategoryObserver {
    func ingredientCategoryChanged(name: String)
}

enum IngredientCategoryPropertyChange {
    case NAME(String)
}

class IngredientCategory {
    var id: Int
    var name: String {
        didSet {
            notifyObservers(t: .NAME(name))
        }
    }
    var observers: [IngredientCategoryObserver] = []
    
    init(id: Int, name: String){
        self.id = id
        self.name = name
    }

    
    func addObserver(obs: IngredientCategoryObserver){
        observers.append(obs)
    }
    
    func notifyObservers(t: IngredientCategoryPropertyChange){
        for observer in observers {
            switch t {
                case .NAME(let name):
                    observer.ingredientCategoryChanged(name: name)
            }
        }
    }
    
    func clone() -> IngredientCategory{
        return IngredientCategory(id: self.id, name: self.name)
    }
    
    func equal(ic: IngredientCategory) -> Bool{
        return ic.id == self.id && ic.name == self.name
    }
    
    func set(ic: IngredientCategory){
        self.id = ic.id
        self.name = ic.name
    }
}
