//
//  Ingredient.swift
//  Test_Cours_listUI
//
//  Created by m1 on 17/02/2022.
//

import Foundation

enum StepSubComponentDTOError: Error {
    case UnknownType(String)
}

class StepSubComponentDTO: Decodable {
    var type: String
    var component: StepComponentAble
    
    private enum CodingKeys: String, CodingKey {
        case type = "type"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decode(String.self, forKey: .type)
        
        if(type == "recipe"){
            component = try RecipeDTO(from: decoder).toRecipe()
        } else if(type == "step"){
            component = try StepDTO(from: decoder).toStep()
        } else if(type == "ingredient"){
            component = try IngredientDTO(from: decoder).toIngredient()
        } else {
            throw StepSubComponentDTOError.UnknownType(type)
        }
    }
}

class StepComponentDTO: Decodable {
    var id: Int
    var quantity: Int
    var component: StepComponentAble
    static var cache: [Int: StepComponent] = [:]
    
    private enum CodingKeys: String, CodingKey {
        case id = "step_component_id"
        case quantity = "quantity"
        case component = "component"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        quantity = try values.decode(Int.self, forKey: .quantity)
        component = try values.decode(StepSubComponentDTO.self, forKey: .component).component
    }
    
    func toStepComponent() -> StepComponent{
        let component = StepComponent(id: id, quantity: quantity, component: component)
        
        if StepComponentDTO.cache[id] == nil {
            StepComponentDTO.cache[id] = component
        } else {
            StepComponentDTO.cache[self.id]?.set(component: component)
        }
        
        return StepComponentDTO.cache[id]!
    }
    
    static func toStepComponent(dtos: [StepComponentDTO]) -> [StepComponent] {
        var components: [StepComponent] = []
        
        for dto in dtos{
            components.append(dto.toStepComponent())
        }
        
        return components
    }
}
