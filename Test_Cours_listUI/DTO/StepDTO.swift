//
//  Ingredient.swift
//  Test_Cours_listUI
//
//  Created by m1 on 17/02/2022.
//

import Foundation

class StepDTO: Decodable {
    var id: Int
    var name: String
    var description: String
    var duration: Double
    var components: [StepComponentDTO]
    static var cache: [Int: Step] = [:]
    
    private enum CodingKeys: String, CodingKey {
        case id = "step_id"
        case name = "name"
        case description = "description"
        case duration = "duration"
        case components = "components"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        description = try values.decode(String.self, forKey: .description)
        duration = try values.decode(Double.self, forKey: .duration)
        components = try values.decode([StepComponentDTO].self, forKey: .components)
    }
    
    func toStep() -> Step {
        let step = Step(id: id, name: name, description: description, duration: duration, components: StepComponentDTO.toStepComponent(dtos: components))

        if StepDTO.cache[id] == nil {
            StepDTO.cache[id] = step
        } else {
            StepDTO.cache[self.id]?.set(step: step)
        }
        
        return StepDTO.cache[id]!
    }
    
    static func toStep(dtos: [StepDTO]) -> [Step] {
        var steps: [Step] = []
        
        for dto in dtos{
            steps.append(dto.toStep())
        }
        
        return steps
    }
}
