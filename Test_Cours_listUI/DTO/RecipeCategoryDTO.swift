//
//  Ingredient.swift
//  Test_Cours_listUI
//
//  Created by m1 on 17/02/2022.
//

import Foundation

class RecipeCategoryDTO: Decodable {
    var id: Int
    var name: String
    static var cache: [Int: RecipeCategory] = [:]
    
    private enum CodingKeys: String, CodingKey {
        case id = "recipe_category_id"
        case name = "name"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
    }
    
    func toRecipeCategory() -> RecipeCategory {
        let rc = RecipeCategory(id: id, name: name)
        if RecipeCategoryDTO.cache[id] == nil {
            RecipeCategoryDTO.cache[id] = rc
        } else {
            RecipeCategoryDTO.cache[self.id]?.set(rc: rc)
        }
        return RecipeCategoryDTO.cache[id]!
    }
    
    static func toRecipeCategory(dtos: [RecipeCategoryDTO]) -> [RecipeCategory] {
        var rcs: [RecipeCategory] = []
        
        for dto in dtos{
            rcs.append(dto.toRecipeCategory())
        }
        
        return rcs
    }
}
