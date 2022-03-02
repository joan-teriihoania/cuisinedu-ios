//
//  IngredientDAO.swift
//  Test_Cours_listUI
//
//  Created by m1 on 22/02/2022.
//

import Foundation

class IngredientCategoryDAO {
    static func get(id: Int, callback: @escaping (Result<IngredientCategory, ApiServiceError>) -> Void){
        ApiService.get(IngredientCategoryDTO.self, route: "/ingredient_categories/\(id)", onsuccess: { ic in
            callback(.success(ic.toIngredientCategory()))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func post(ic: IngredientCategory, callback: @escaping (Result<IngredientCategory, ApiServiceError>) -> Void){
        ApiService.post(IngredientCategoryDTO.self, route: "/ingredient_categories", parameters: [
            "name": ic.name
        ], onsuccess: { ic in
            callback(.success(ic.toIngredientCategory()))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func delete(id: Int, callback: @escaping (Result<String, ApiServiceError>) -> Void){
        ApiService.delete(String.self, route: "/ingredient_categories/\(id)", parameters: [:], onsuccess: { response in
            callback(.success(response))
        }, onsuccessText: { response in
            callback(.success(response))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func getAll(callback: @escaping (Result<[IngredientCategory], ApiServiceError>) -> Void){
        ApiService.get([IngredientCategoryDTO].self, route: "/ingredient_categories", onsuccess: { ics in
            callback(.success(IngredientCategoryDTO.toIngredientCategory(ingredientCategoryDTOs: ics)))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func put(ic: IngredientCategory, callback: @escaping (Result<IngredientCategory, ApiServiceError>) -> Void){
        ApiService.put(IngredientCategoryDTO.self, route: "/ingredient_categories/\(ic.id)", parameters: [
            "name": ic.name
        ], onsuccess: { ic in
            callback(.success(ic.toIngredientCategory()))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
}
