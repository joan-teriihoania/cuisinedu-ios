//
//  Ingredient.swift
//  Test_Cours_listUI
//
//  Created by m1 on 17/02/2022.
//

import Foundation

class AllergeneDTO: Decodable {
    var id: Int
    var name: String
    static var cache: [Int: Allergene] = [:]
    
    private enum CodingKeys: String, CodingKey {
        case id = "allergene_id"
        case name = "name"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
    }
    
    func toAllergene() -> Allergene {
        let allergene = Allergene(id: id, name: name)
        if AllergeneDTO.cache[id] == nil {
            AllergeneDTO.cache[id] = allergene
        } else {
            AllergeneDTO.cache[self.id]?.set(allergene: allergene)
        }
        return AllergeneDTO.cache[id]!
    }
    
    static func toAllergene(dtos: [AllergeneDTO]) -> [Allergene] {
        var arr: [Allergene] = []
        
        for dto in dtos{
            arr.append(dto.toAllergene())
        }
        
        return arr
    }
}
