//
//  IngredientDAO.swift
//  Test_Cours_listUI
//
//  Created by m1 on 22/02/2022.
//

import Foundation

class AllergeneDAO {
    static func get(id: Int, callback: @escaping (Result<Allergene, ApiServiceError>) -> Void){
        ApiService.get(AllergeneDTO.self, route: "/allergenes/\(id)", onsuccess: { allergene in
            callback(.success(allergene.toAllergene()))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func post(allergene: Allergene, callback: @escaping (Result<Allergene, ApiServiceError>) -> Void){
        ApiService.post(AllergeneDTO.self, route: "/allergenes", parameters: [
            "name": allergene.name
        ], onsuccess: { allergene in
            callback(.success(allergene.toAllergene()))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func delete(id: Int, callback: @escaping (Result<String, ApiServiceError>) -> Void){
        ApiService.delete(String.self, route: "/allergenes/\(id)", parameters: [:], onsuccess: { response in
            callback(.success(response))
        }, onsuccessText: { response in
            callback(.success(response))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func getAll(callback: @escaping (Result<[Allergene], ApiServiceError>) -> Void){
        ApiService.get([AllergeneDTO].self, route: "/allergenes", onsuccess: { allergenes in
            callback(.success(AllergeneDTO.toAllergene(dtos: allergenes)))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func put(allergene: Allergene, callback: @escaping (Result<Allergene, ApiServiceError>) -> Void){
        ApiService.put(AllergeneDTO.self, route: "/allergenes/\(allergene.id)", parameters: [
            "name": allergene.name
        ], onsuccess: { allergene in
            callback(.success(allergene.toAllergene()))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
}
