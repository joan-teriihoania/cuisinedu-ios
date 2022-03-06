//
//  TrackViewModel.swift
//  Test_Cours_listUI
//
//  Created by m1 on 16/02/2022.
//

import Foundation
import Combine
import CoreText
import SwiftUI

enum RecipeError: Error, Equatable, CustomStringConvertible {
    case NONE
    case NAME(String)
    case NB_COUVERT(String)
    case CATEGORY(String)
    case STEP(String)
    case DELETE(String)
    
    var description: String {
        switch self {
            case .NONE:
                return "No error"
            case .NAME:
                return "Invalid name"
            case .NB_COUVERT:
                return "Invalid number"
            case .CATEGORY:
                return "Invalid category"
            case .DELETE:
                return "Delete error"
            case .STEP:
                return "Step error"
        }
    }
}

class RecipeViewModel: ObservableObject, RecipeObserver, Subscriber  {
    func recipeChanged(name: String) {
        DispatchQueue.main.async {
            self.name = name
        }
    }
    
    func recipeChanged(nb_couvert: Int) {
        DispatchQueue.main.async {
            self.nb_couvert = nb_couvert
        }
    }
    
    func recipeChanged(user: User) {
        DispatchQueue.main.async {
            self.user = user
        }
    }
    
    func recipeChanged(category: RecipeCategory) {
        DispatchQueue.main.async {
            self.category = category
        }
    }
    
    func recipeChanged(steps: [RecipeStepQuantity]) {
        self.steps = RecipeSteps(steps: steps)
    }
    
    typealias Input = RecipeIntentState
    typealias Failure = Never
    
    private(set) var recipe: Recipe
    @Published var name: String
    @Published var user: User
    @Published var nb_couvert: Int
    @Published var category: RecipeCategory
    @ObservedObject var steps: RecipeSteps
    @Published var deleted: Bool = false
    
    @Published var error: RecipeError = .NONE {
        didSet {
            self.delegate?.recipeViewModelChanged()
        }
    }
    var delegate: RecipeViewModelDelegate?
    
    init(recipe: Recipe){
        self.recipe = recipe
        self.name = recipe.name
        self.user = recipe.user
        self.nb_couvert = recipe.nb_couvert
        self.category = recipe.category
        self.steps = RecipeSteps(steps: recipe.steps)
        
        self.steps.vm = self
        self.recipe.addObserver(obs: self)
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: RecipeIntentState) -> Subscribers.Demand {
        self.error = .NONE
        switch input {
            case .READY:
                break
            case .CHANGING_NAME(let name):
                self.recipe.name = name
                if(self.recipe.name != name){
                    self.error = .NAME("Invalid input")
                }
            case .CHANGING_USER:
                break
            case .CHANGING_CATEGORY(let category):
                self.recipe.category = category
                if(self.recipe.category != category){
                    self.error = .CATEGORY("Invalid category")
                }
            case .CHANGING_NB_COUVERT(let nb_couvert):
                self.recipe.nb_couvert = nb_couvert
                if(self.recipe.nb_couvert != nb_couvert){
                    self.error = .NB_COUVERT("Invalid input")
                }
            case .DELETING:
                RecipeDAO.delete(id: self.recipe.id, callback: {result in
                    DispatchQueue.main.async {
                        switch result {
                            case .success(_):
                                self.delegate?.recipeDeleted(recipe: self.recipe)
                                self.deleted = true
                                break
                            case .failure(let error):
                                self.error = .DELETE(error.description)
                                break
                        }
                    }
                })
            case .LIST_UPDATED:
                self.delegate?.recipeViewModelChanged()
                break
        case .ADDING_STEP(let step, let position, let quantity):
            RecipeDAO.addStep(recipe_id: self.recipe.id, step_id: step.id, position: position, quantity: quantity, callback: { result in
                    DispatchQueue.main.async {
                        switch result {
                            case .success(_):
                                self.delegate?.recipeViewModelChanged()
                            case .failure(let error):
                            self.error = .STEP(error.description)
                        }
                    }
                })
            case .REMOVING_STEP(let step):
                RecipeDAO.removeStep(recipe_id: self.recipe.id, step_id: step.id, callback: { result in
                    DispatchQueue.main.async {
                        switch result {
                            case .success(_):
                                self.steps.stepDeleted(step: step)
                                self.delegate?.recipeViewModelChanged()
                            case .failure(let error):
                            self.error = .STEP(error.description)
                        }
                    }
                })
        }
        
        return .none
    }
}
