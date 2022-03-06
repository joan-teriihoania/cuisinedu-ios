//
//  IngredientCategory.swift
//  Test_Cours_listUI
//
//  Created by m1 on 17/02/2022.
//

import Foundation

protocol RecipeCategoryObserver {
    func recipeCategoryChanged(name: String)
}

enum RecipeCategoryPropertyChange {
    case NAME(String)
}

class RecipeCategory: Equatable {
    static func == (lhs: RecipeCategory, rhs: RecipeCategory) -> Bool {
        return lhs.equal(rc: rhs)
    }
    
    var id: Int
    var name: String {
        didSet {
            notifyObservers(t: .NAME(name))
        }
    }
    var observers: [RecipeCategoryObserver] = []
    
    init(id: Int, name: String){
        self.id = id
        self.name = name
    }

    
    func addObserver(obs: RecipeCategoryObserver){
        observers.append(obs)
    }
    
    func notifyObservers(t: RecipeCategoryPropertyChange){
        for observer in observers {
            switch t {
                case .NAME(let name):
                    observer.recipeCategoryChanged(name: name)
            }
        }
    }
    
    func clone() -> RecipeCategory{
        return RecipeCategory(id: self.id, name: self.name)
    }
    
    func equal(rc: RecipeCategory) -> Bool{
        return rc.id == self.id && rc.name == self.name
    }
    
    func set(rc: RecipeCategory){
        self.id = rc.id
        self.name = rc.name
    }
}
