//
//  Ingredient.swift
//  Test_Cours_listUI
//
//  Created by m1 on 17/02/2022.
//

import Foundation

class IngredientDTO: Decodable {
    var id: Int
    var unit: UnitDTO
    var category: IngredientCategoryDTO
    var price: Double
    var name: String
    static var cache: [Int: Ingredient] = [:]
    
    private enum CodingKeys: String, CodingKey {
        case id = "ingredient_id"
        case unit = "unit"
        case category = "category"
        case price = "price"
        case name = "name"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        unit = try values.decode(UnitDTO.self, forKey: .unit)
        category = try values.decode(IngredientCategoryDTO.self, forKey: .category)
        price = try values.decode(Double.self, forKey: .price)
        name = try values.decode(String.self, forKey: .name)
    }
    
    func toIngredient() -> Ingredient {
        if IngredientDTO.cache[id] == nil { IngredientDTO.cache[id] = Ingredient(id: id, unit: unit.toUnit(), category: category.toIngredientCategory(), price: price, name: name) }
        
        return IngredientDTO.cache[id]!
    }
    
    static func toIngredient(ingredientDTOs: [IngredientDTO]) -> [Ingredient] {
        var ingredients: [Ingredient] = []
        
        for ingredientDTO in ingredientDTOs{
            ingredients.append(ingredientDTO.toIngredient())
        }
        
        return ingredients
    }
}
