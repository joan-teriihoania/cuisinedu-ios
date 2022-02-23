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

class IngredientCategory: Decodable {
    var id: Int
    var name: String {
        didSet {
            notifyObservers(t: .NAME(name))
        }
    }
    var observers: [IngredientCategoryObserver] = []
    
    private enum CodingKeys: String, CodingKey {
        case id = "ingredient_category_id"
        case name = "name"
    }
    
    init(id: Int, name: String){
        self.id = id
        self.name = name
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
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
}
