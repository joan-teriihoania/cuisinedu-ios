//
//  Ingredient.swift
//  Test_Cours_listUI
//
//  Created by m1 on 17/02/2022.
//

import Foundation

class UnitDTO: Decodable {
    var id: Int
    var name: String
    static var cache: [Int: Unit] = [:]
    
    private enum CodingKeys: String, CodingKey {
        case id = "unit_id"
        case name = "name"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
    }
    
    func toUnit() -> Unit {
        if UnitDTO.cache[id] == nil { UnitDTO.cache[id] = Unit(id: id, name: name) }
        return UnitDTO.cache[id]!
    }
    
    static func toUnit(unitDTOs: [UnitDTO]) -> [Unit] {
        var units: [Unit] = []
        
        for unitDTO in unitDTOs{
            units.append(unitDTO.toUnit())
        }
        
        return units
    }
}
