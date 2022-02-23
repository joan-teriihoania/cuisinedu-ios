//
//  IngredientDAO.swift
//  Test_Cours_listUI
//
//  Created by m1 on 22/02/2022.
//

import Foundation

// TODO: Ingredients section by categories

class IngredientDAO {
    static func get(id: Int, callback: @escaping (Result<Ingredient, ApiServiceError>) -> Void){
        ApiService.get(IngredientDTO.self, route: "/ingredients/\(id)", onsuccess: { ingredient in
            callback(.success(ingredient.toIngredient()))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func post(ingredient: Ingredient, callback: @escaping (Result<Ingredient, ApiServiceError>) -> Void){
        ApiService.post(IngredientDTO.self, route: "/ingredients", parameters: [
            "unit_id": ingredient.unit.id,
            "ingredient_category_id": ingredient.category.id,
            "name": ingredient.name,
            "price": ingredient.price
        ], onsuccess: { ingredient in
            callback(.success(ingredient.toIngredient()))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func delete(id: Int, callback: @escaping (Result<String, ApiServiceError>) -> Void){
        ApiService.delete(String.self, route: "/ingredients/\(id)", parameters: [:], onsuccess: { response in
            callback(.success(response))
        }, onsuccessText: { response in
            callback(.success(response))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func getAll(callback: @escaping (Result<[Ingredient], ApiServiceError>) -> Void){
        ApiService.get([IngredientDTO].self, route: "/ingredients", onsuccess: { ingredients in
            callback(.success(IngredientDTO.toIngredient(ingredientDTOs: ingredients)))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func put(ingredient: Ingredient, callback: @escaping (Result<Ingredient, ApiServiceError>) -> Void){
        ApiService.put(IngredientDTO.self, route: "/ingredients/\(ingredient.id)", parameters: [
            "unit_id": ingredient.unit.id,
            "ingredient_category_id": ingredient.category.id,
            "name": ingredient.name,
            "price": ingredient.price
        ], onsuccess: { ingredient in
            callback(.success(ingredient.toIngredient()))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
}
