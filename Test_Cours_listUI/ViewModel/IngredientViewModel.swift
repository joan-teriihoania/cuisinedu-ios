//
//  TrackViewModel.swift
//  Test_Cours_listUI
//
//  Created by m1 on 16/02/2022.
//

import Foundation
import Combine
import CoreText

enum IngredientError: Error, Equatable, CustomStringConvertible {
    case NONE
    case NAME(String)
    case UNIT(String)
    case CATEGORY(String)
    case PRICE(String)
    case DELETE(String)
    
    var description: String {
        switch self {
            case .NONE:
                    return "No error"
            case .NAME:
                    return "Ingredient name isn't  valid"
            case .UNIT:
                    return "Unit isn't valid"
            case .CATEGORY:
                return "Category isn't valid"
            case .PRICE:
                    return "Price value isn't valid"
            case .DELETE:
                return "Delete error"
        }
    }
}

class IngredientViewModel: ObservableObject, IngredientObserver, Subscriber {
    typealias Input = IngredientIntentState
    typealias Failure = Never
    
    private(set) var ingredient: Ingredient
    @Published var unit: Unit
    @Published var category: IngredientCategory
    @Published var price: Double
    @Published var name: String
    @Published var deleted: Bool = false
    
    @Published var error: IngredientError = .NONE
    var delegate: IngredientViewModelDelegate?
    
    init(ingredient: Ingredient){
        self.ingredient = ingredient
        self.unit = ingredient.unit
        self.category = ingredient.category
        self.price = ingredient.price
        self.name = ingredient.name
        self.ingredient.addObserver(obs: self)
    }
    
    func changed(unit: Unit) {
        self.unit = unit
    }
    
    func changed(category: IngredientCategory) {
        self.category = category
    }
    
    func changed(price: Double) {
        self.price = price
    }
    
    func changed(name: String) {
        self.name = name
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: IngredientIntentState) -> Subscribers.Demand {
        switch input {
            case .READY:
                break
            case .CHANGING_PRICE(let price):
                self.ingredient.price = price
                if(self.ingredient.price != price){
                    self.error = .PRICE("Invalid input")
                }
            case .CHANGING_NAME(let name):
                self.ingredient.name = name
                if(self.ingredient.name != name){
                    self.error = .NAME("Invalid input")
                }
            case .CHANGING_UNIT(let unit):
                self.ingredient.unit = unit
            case .CHANGING_CATEGORY(let cat):
                self.ingredient.category = cat
            case .DELETING:
                IngredientDAO.delete(id: self.ingredient.id, callback: {result in
                    DispatchQueue.main.async {
                        switch result {
                            case .success(_):
                                self.delegate?.ingredientDeleted(ingredient: self.ingredient)
                                self.deleted = true
                                break
                            case .failure(let error):
                                self.error = .DELETE(error.description)
                                break
                        }
                    }
                })
            case .LIST_UPDATED:
                self.delegate?.ingredientViewModelChanged()
                break
        }
        
        return .none
    }
}
