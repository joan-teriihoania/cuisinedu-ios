//
//  Ingredient.swift
//  Test_Cours_listUI
//
//  Created by m1 on 17/02/2022.
//

import Foundation

class RecipeStepQuantityDTO: Decodable {
    var quantity: Int
    var step: StepDTO
    static var cache: [Int: RecipeStepQuantity] = [:]
    
    private enum CodingKeys: String, CodingKey {
        case quantity = "quantity"
        case step = "step"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        quantity = try values.decode(Int.self, forKey: .quantity)
        step = try values.decode(StepDTO.self, forKey: .step)
    }
    
    func toRecipeStepQuantity() -> RecipeStepQuantity {
        return RecipeStepQuantity(quantity: quantity, step: step.toStep())
    }
    
    static func toRecipeStepQuantity(dtos: [RecipeStepQuantityDTO]) -> [RecipeStepQuantity] {
        var steps: [RecipeStepQuantity] = []
        
        for dto in dtos{
            steps.append(dto.toRecipeStepQuantity())
        }
        
        return steps
    }
}

class RecipeDTO: Decodable {
    var id: Int
    var name: String
    var nb_couvert: Int
    var user: UserDTO
    var category: RecipeCategoryDTO
    var steps: [RecipeStepQuantityDTO]
    static var cache: [Int: Recipe] = [:]
    
    private enum CodingKeys: String, CodingKey {
        case id = "recipe_id"
        case name = "name"
        case nb_couvert = "nb_couvert"
        case user = "author"
        case category = "category"
        case steps = "steps"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        nb_couvert = try values.decode(Int.self, forKey: .nb_couvert)
        user = try values.decode(UserDTO.self, forKey: .user)
        category = try values.decode(RecipeCategoryDTO.self, forKey: .category)
        steps = try values.decode([RecipeStepQuantityDTO].self, forKey: .steps)
    }
    
    func toRecipe() -> Recipe {
        let recipe = Recipe(id: id, name: name, nb_couvert: nb_couvert, user: user.toUser(), category: category.toRecipeCategory(), steps: RecipeStepQuantityDTO.toRecipeStepQuantity(dtos: steps))

        if RecipeDTO.cache[id] == nil {
            RecipeDTO.cache[id] = recipe
        } else {
            RecipeDTO.cache[self.id]?.set(recipe: recipe)
        }
        
        return RecipeDTO.cache[id]!
    }
    
    static func toRecipe(dtos: [RecipeDTO]) -> [Recipe] {
        var recipes: [Recipe] = []
        
        for dto in dtos{
            recipes.append(dto.toRecipe())
        }
        
        return recipes
    }
}
