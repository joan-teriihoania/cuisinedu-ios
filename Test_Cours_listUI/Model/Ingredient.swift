//
//  Ingredient.swift
//  Test_Cours_listUI
//
//  Created by m1 on 17/02/2022.
//

import Foundation

protocol IngredientObserver {
    func changed(unit: Unit)
    func changed(category: IngredientCategory)
    func changed(price: Double)
    func changed(name: String)
}

enum IngredientPropertyChange {
    case UNIT
    case CATEGORY
    case PRICE
    case NAME
}

class Ingredient: ObservableObject, UnitObserver, IngredientCategoryObserver, Equatable {
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: Int
    @Published var unit: Unit {
        didSet {
            notifyObservers(t: .UNIT)
        }
    }
    @Published var category: IngredientCategory {
        didSet {
            notifyObservers(t: .CATEGORY)
        }
    }
    @Published var price: Double {
        didSet {
            notifyObservers(t: .PRICE)
        }
    }
    @Published var name: String {
        didSet {
            if(name.count < 3){
                self.name = oldValue
            }
            notifyObservers(t: .NAME)
        }
    }
    private(set) var observers: [IngredientObserver]
    
    init(
        id: Int,
        unit: Unit,
        category: IngredientCategory,
        price: Double,
        name: String
    ){
        self.id = id
        self.unit = unit
        self.category = category
        self.price = price
        self.name = name
        self.observers = []
        
        self.unit.addObserver(obs: self)
        self.category.addObserver(obs: self)
    }
    
    var description: String {
        return "Ingrédient \(name) au prix de \(price) \(unit.name) dans la catégorie \(category.name) avec les allergènes"
    }
    
    func unitChanged(name: String) {
        notifyObservers(t: .UNIT)
    }
    
    func ingredientCategoryChanged(name: String) {
        notifyObservers(t: .CATEGORY)
    }
    
    func addObserver(obs: IngredientObserver){
        observers.append(obs)
    }
    
    func notifyObservers(t: IngredientPropertyChange){
        for observer in observers {
            switch t {
                case .UNIT:
                    observer.changed(unit: unit)
                case .CATEGORY:
                    observer.changed(category: category)
                case .PRICE:
                    observer.changed(price: price)
                case .NAME:
                    observer.changed(name: name)
            }
        }
    }
    
}
