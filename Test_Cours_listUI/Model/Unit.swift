//
//  Unit.swift
//  Test_Cours_listUI
//
//  Created by m1 on 17/02/2022.
//

import Foundation

enum UnitPropertyChange {
    case NAME(String)
}

protocol UnitObserver {
    func unitChanged(name: String)
}

class Unit: Decodable {
    var id: Int
    var name: String {
        didSet {
            notifyObservers(p: .NAME(name))
        }
    }
    var observers: [UnitObserver] = []
    
    init(id: Int, name: String){
        self.id = id
        self.name = name
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "unit_id"
        case name = "name"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
    }
    
    func addObserver(obs: UnitObserver){
        observers.append(obs)
    }
    
    func notifyObservers(p: UnitPropertyChange){
        for observer in observers {
            switch p {
                case .NAME(let name):
                    observer.unitChanged(name: name)
            }
        }
    }
    
}
