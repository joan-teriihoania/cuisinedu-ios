//
//  IngredientDAO.swift
//  Test_Cours_listUI
//
//  Created by m1 on 22/02/2022.
//

import Foundation

// TODO: Ingredients section by categories

class UnitDAO {
    static func get(id: Int, callback: @escaping (Result<Unit, ApiServiceError>) -> Void){
        ApiService.get(UnitDTO.self, route: "/units/\(id)", onsuccess: { unit in
            callback(.success(unit.toUnit()))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func post(unit: Unit, callback: @escaping (Result<Unit, ApiServiceError>) -> Void){
        ApiService.post(UnitDTO.self, route: "/units", parameters: [
            "name": unit.name
        ], onsuccess: { unit in
            callback(.success(unit.toUnit()))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func delete(id: Int, callback: @escaping (Result<String, ApiServiceError>) -> Void){
        ApiService.delete(String.self, route: "/units/\(id)", parameters: [:], onsuccess: { response in
            callback(.success(response))
        }, onsuccessText: { response in
            callback(.success(response))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func getAll(callback: @escaping (Result<[Unit], ApiServiceError>) -> Void){
        ApiService.get([UnitDTO].self, route: "/units", onsuccess: { units in
            callback(.success(UnitDTO.toUnit(unitDTOs: units)))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func put(unit: Unit, callback: @escaping (Result<Unit, ApiServiceError>) -> Void){
        ApiService.put(UnitDTO.self, route: "/units/\(unit.id)", parameters: [
            "name": unit.name
        ], onsuccess: { unit in
            callback(.success(unit.toUnit()))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
}
