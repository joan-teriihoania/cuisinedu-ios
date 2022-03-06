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
    func changed(allergenes: [Allergene])
}

enum IngredientPropertyChange {
    case UNIT
    case CATEGORY
    case PRICE
    case NAME
    case ALLERGENES
}

class Ingredient: ObservableObject, UnitObserver, IngredientCategoryObserver, Equatable, AllergeneObserver, StepComponentAble {
    var stepComponentAbleObservers: [StepComponentAbleObserver] = []
    
    func addObserver(obs: StepComponentAbleObserver) {
        stepComponentAbleObservers.append(obs)
    }
    
    func setComponent(_ c: StepComponentAble) {
        switch c.getObject() {
            case .INGREDIENT(let ingredient):
                self.set(ingredient: ingredient)
            default:
                break
        }
    }
    
    func equalComponent(_ c: StepComponentAble) -> Bool {
        switch c.getObject() {
            case .INGREDIENT(let ingredient):
                return self.equal(ingredient: ingredient)
            default:
                return false
        }
    }
    
    func cloneComponent() -> StepComponentAble {
        return clone()
    }
    
    func getIngredients() -> [Ingredient] {
        return [self]
    }
    
    func getName() -> String {
        return name
    }
    
    func getDescription() -> String {
        return description
    }
    
    func getDuration() -> Double {
        return 0
    }
    
    func getObject() -> StepComponentEnum {
        return .INGREDIENT(self)
    }
    
    func allergeneChanged(name: String) {
        notifyObservers(t: .ALLERGENES)
    }
    
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
    @Published var allergenes: [Allergene] {
        didSet {
            notifyObservers(t: .ALLERGENES)
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
        name: String,
        allergenes: [Allergene]
    ){
        self.id = id
        self.unit = unit
        self.category = category
        self.price = price
        self.name = name
        self.allergenes = allergenes
        self.observers = []

        self.unit.addObserver(obs: self)
        self.category.addObserver(obs: self)
    }
    
    var description: String {
        return "Ingrédient \(name) au prix de \(price) \(unit.name) dans la catégorie \(category.name)"
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
        for observer in stepComponentAbleObservers {
            observer.stepComponentAbleChanged(component: self)
        }
        
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
                case .ALLERGENES:
                    observer.changed(allergenes: allergenes)
            }
        }
    }
    
    func set(ingredient: Ingredient){
        self.id = ingredient.id
        self.price = ingredient.price
        self.name = ingredient.name
        // self.unit = ingredient.unit
        // self.category = ingredient.category
        //self.allergenes = ingredient.allergenes
        self.unit.set(unit: ingredient.unit)
        self.category.set(ic: ingredient.category)
        self.allergenes = ingredient.allergenes
    }
    
    func equal(ingredient: Ingredient, ignoreAllergenes: Bool) -> Bool {
        var isAllergeneEqual: Bool = true
        if(!ignoreAllergenes){
            if(self.allergenes.count == ingredient.allergenes.count){
                for i in 0..<self.allergenes.count {
                    if(!self.allergenes[i].equal(allergene: ingredient.allergenes[i])){
                        isAllergeneEqual = false
                        break
                    }
                }
            } else {
                isAllergeneEqual = false
            }
        }
        
        return
            self.id == ingredient.id &&
            self.unit.equal(unit: ingredient.unit) &&
            self.category.equal(ic: ingredient.category) &&
            self.price == ingredient.price &&
            self.name == ingredient.name &&
            isAllergeneEqual
    }
    
    func equal(ingredient: Ingredient) -> Bool {
        return equal(ingredient: ingredient, ignoreAllergenes: false)
    }
    
    private func cloneAllergenes(allergenes: [Allergene]) -> [Allergene] {
        var cloneAllergenes: [Allergene] = []
        for allergene in allergenes {
            cloneAllergenes.append(allergene.clone())
        }
        
        return cloneAllergenes
    }
    
    func clone() -> Ingredient {
        return Ingredient(id: self.id, unit: self.unit.clone(), category: self.category.clone(), price: self.price, name: self.name, allergenes: cloneAllergenes(allergenes: self.allergenes))
    }
}
