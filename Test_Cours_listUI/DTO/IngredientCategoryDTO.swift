//
//  Ingredient.swift
//  Test_Cours_listUI
//
//  Created by m1 on 17/02/2022.
//

import Foundation

class IngredientCategoryDTO: Decodable {
    var id: Int
    var name: String
    static var cache: [Int: IngredientCategory] = [:]
    
    private enum CodingKeys: String, CodingKey {
        case id = "ingredient_category_id"
        case name = "name"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
    }
    
    func toIngredientCategory() -> IngredientCategory {
        let ic = IngredientCategory(id: id, name: name)
        if IngredientCategoryDTO.cache[id] == nil {
            IngredientCategoryDTO.cache[id] = ic
        } else {
            IngredientCategoryDTO.cache[self.id]?.set(ic: ic)
        }
        return IngredientCategoryDTO.cache[id]!
    }
    
    static func toIngredientCategory(ingredientCategoryDTOs: [IngredientCategoryDTO]) -> [IngredientCategory] {
        var ics: [IngredientCategory] = []
        
        for icDTO in ingredientCategoryDTOs{
            ics.append(icDTO.toIngredientCategory())
        }
        
        return ics
    }
}
