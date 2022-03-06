//
//  Recipe.swift
//  Test_Cours_listUI
//
//  Created by m1 on 04/03/2022.
//

import Foundation

protocol RecipeObserver {
    func recipeChanged(name: String)
    func recipeChanged(nb_couvert: Int)
    func recipeChanged(user: User)
    func recipeChanged(category: RecipeCategory)
    func recipeChanged(steps: [RecipeStepQuantity])
}

enum RecipePropertyChange {
    case NAME(String)
    case NB_COUVERT(Int)
    case USER(User)
    case CATEGORY(RecipeCategory)
    case STEPS([RecipeStepQuantity])
}

class RecipeStepQuantity {
    var quantity: Int
    var step: Step
    
    init(quantity: Int, step: Step){
        self.quantity = quantity
        self.step = step
    }
    
    func addObserver(obs: StepObserver){
        self.step.addObserver(obs: obs)
    }
    
    func set(step: RecipeStepQuantity){
        self.quantity = step.quantity
        self.step = step.step
    }
    
    func equal(step: RecipeStepQuantity) -> Bool {
        return self.quantity == step.quantity && step.step.equal(step: step.step)
    }
    
    func clone() -> RecipeStepQuantity {
        return RecipeStepQuantity(quantity: quantity, step: step.clone())
    }
}

class Recipe: RecipeCategoryObserver, StepObserver, Equatable, StepComponentAble {
    var stepComponentAbleObservers: [StepComponentAbleObserver] = []

    func addObserver(obs: StepComponentAbleObserver) {
        stepComponentAbleObservers.append(obs)
    }
    
    func setComponent(_ c: StepComponentAble) {
        switch c.getObject() {
            case .RECIPE(let recipe):
                set(recipe: recipe)
            default:
                break
        }
    }
    
    func equalComponent(_ c: StepComponentAble) -> Bool {
        switch c.getObject() {
            case .RECIPE(let recipe):
                return equal(recipe: recipe)
            default:
                return false
        }
    }
    
    func cloneComponent() -> StepComponentAble {
        return clone()
    }
    
    func getIngredients() -> [Ingredient] {
        var ingredients: [Ingredient] = []
        
        for step in steps {
            for _ in 0..<step.quantity {
                ingredients.append(contentsOf: step.step.getIngredients())
            }
        }
        
        return ingredients
    }
    
    func getName() -> String {
        return name
    }
    
    func getDescription() -> String {
        return ""
    }
    
    func getDuration() -> Double {
        var duration = 0.0
        
        for step in steps {
            duration += step.step.getDuration() * Double(step.quantity)
        }
        
        return duration
    }
    
    func getObject() -> StepComponentEnum {
        return .RECIPE(self)
    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.equal(recipe: rhs)
    }
    
    func set(recipe: Recipe){
        self.steps = recipe.steps
        self.user = recipe.user
        self.nb_couvert = recipe.nb_couvert
        self.id = recipe.id
        self.category = recipe.category
        self.name = recipe.name
    }
    
    private func cloneSteps() -> [RecipeStepQuantity] {
        var cloned: [RecipeStepQuantity] = []
        
        for step in steps {
            cloned.append(step.clone())
        }
        
        return cloned
    }
    
    private func isStepsEqual(steps: [RecipeStepQuantity]) -> Bool {
        if self.steps.count != steps.count { return false }
        
        for i in 0..<steps.count {
            if !self.steps[i].equal(step: steps[i]) { return false }
        }

        return true
    }
    
    func equal(recipe: Recipe) -> Bool {
        return
            isStepsEqual(steps: recipe.steps) &&
            self.nb_couvert == recipe.nb_couvert &&
            self.id == recipe.id &&
            self.category.equal(rc: recipe.category) &&
            self.name == recipe.name
    }
    
    func clone() -> Recipe {
        return Recipe(id: id, name: name, nb_couvert: nb_couvert, user: user, category: category.clone(), steps: cloneSteps())
    }
    
    func stepChanged(name: String) {
        notifyObservers(t: .STEPS(steps))
    }
    
    func stepChanged(description: String) {
        notifyObservers(t: .STEPS(steps))
    }
    
    func stepChanged(duration: Double) {
        notifyObservers(t: .STEPS(steps))
    }
    
    func stepChanged(components: [StepComponent]) {
        notifyObservers(t: .STEPS(steps))
    }
    
    func recipeCategoryChanged(name: String) {
        notifyObservers(t: .CATEGORY(category))
    }
    
    var id: Int
    @Published var name: String {
        didSet {
            notifyObservers(t: .NAME(name))
        }
    }
    @Published var nb_couvert: Int {
        didSet {
            notifyObservers(t: .NB_COUVERT(nb_couvert))
        }
    }
    @Published var user: User {
        didSet {
            notifyObservers(t: .USER(user))
        }
    }
    @Published var category: RecipeCategory {
        didSet {
            notifyObservers(t: .CATEGORY(category))
        }
    }
    @Published var steps: [RecipeStepQuantity] {
        didSet {
            notifyObservers(t: .STEPS(steps))
        }
    }
    var observers: [RecipeObserver] = []
    
    init(id: Int, name: String, nb_couvert: Int, user: User, category: RecipeCategory, steps: [RecipeStepQuantity]){
        self.id = id
        self.name = name
        self.nb_couvert = nb_couvert
        self.user = user
        self.category = category
        self.steps = steps
        
        self.category.addObserver(obs: self)
        for step in steps {
            step.addObserver(obs: self)
        }
    }
    
    func addObserver(obs: RecipeObserver){
        observers.append(obs)
    }
    
    func notifyObservers(t: RecipePropertyChange){
        for observer in stepComponentAbleObservers {
            observer.stepComponentAbleChanged(component: self)
        }
        
        for observer in observers {
            switch t {
                case .CATEGORY:
                    observer.recipeChanged(category: category)
                case .NAME:
                    observer.recipeChanged(name: name)
                case .STEPS:
                    observer.recipeChanged(steps: steps)
                case .NB_COUVERT:
                    observer.recipeChanged(nb_couvert: nb_couvert)
                case .USER:
                    observer.recipeChanged(user: user)
            }
        }
    }
}
