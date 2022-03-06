//
//  RecipeDAO.swift
//  Test_Cours_listUI
//
//  Created by m1 on 22/02/2022.
//

import Foundation

class RecipeCategoryDAO {
    static func get(id: Int, callback: @escaping (Result<RecipeCategory, ApiServiceError>) -> Void){
        ApiService.get(RecipeCategoryDTO.self, route: "/recipe_categories/\(id)", onsuccess: { ic in
            callback(.success(ic.toRecipeCategory()))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func post(rc: RecipeCategory, callback: @escaping (Result<RecipeCategory, ApiServiceError>) -> Void){
        ApiService.post(RecipeCategoryDTO.self, route: "/recipe_categories", parameters: [
            "name": rc.name
        ], onsuccess: { ic in
            callback(.success(ic.toRecipeCategory()))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func delete(id: Int, callback: @escaping (Result<String, ApiServiceError>) -> Void){
        ApiService.delete(String.self, route: "/recipe_categories/\(id)", parameters: [:], onsuccess: { response in
            callback(.success(response))
        }, onsuccessText: { response in
            callback(.success(response))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func getAll(callback: @escaping (Result<[RecipeCategory], ApiServiceError>) -> Void){
        ApiService.get([RecipeCategoryDTO].self, route: "/recipe_categories", onsuccess: { ics in
            callback(.success(RecipeCategoryDTO.toRecipeCategory(dtos: ics)))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func put(rc: RecipeCategory, callback: @escaping (Result<RecipeCategory, ApiServiceError>) -> Void){
        ApiService.put(RecipeCategoryDTO.self, route: "/recipe_categories/\(rc.id)", parameters: [
            "name": rc.name
        ], onsuccess: { ic in
            callback(.success(ic.toRecipeCategory()))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
}
