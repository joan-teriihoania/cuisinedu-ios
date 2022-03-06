//
//  RecipeDAO.swift
//  Test_Cours_listUI
//
//  Created by m1 on 22/02/2022.
//

import Foundation

class RecipeDAO {
    static func get(id: Int, callback: @escaping (Result<Recipe, ApiServiceError>) -> Void){
        ApiService.get(RecipeDTO.self, route: "/recipes/\(id)", onsuccess: { recipe in
            callback(.success(recipe.toRecipe()))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func post(recipe: Recipe, callback: @escaping (Result<Recipe, ApiServiceError>) -> Void){
        ApiService.post(RecipeDTO.self, route: "/recipes", parameters: [
            "user_id": recipe.user.id,
            "recipe_category_id": recipe.category.id,
            "name": recipe.name,
            "nb_couvert": recipe.nb_couvert
        ], onsuccess: { recipe in
            callback(.success(recipe.toRecipe()))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func delete(id: Int, callback: @escaping (Result<String, ApiServiceError>) -> Void){
        ApiService.delete(String.self, route: "/recipes/\(id)", parameters: [:], onsuccess: { response in
            callback(.success(response))
        }, onsuccessText: { response in
            callback(.success(response))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func getAll(callback: @escaping (Result<[Recipe], ApiServiceError>) -> Void){
        ApiService.get([RecipeDTO].self, route: "/recipes", onsuccess: { recipes in
            callback(.success(RecipeDTO.toRecipe(dtos: recipes)))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func addStep(recipe_id: Int, step_id: Int, position: Int, quantity: Int, callback: @escaping (Result<Recipe, ApiServiceError>) -> Void){
        ApiService.post(RecipeDTO.self, route: "/recipes/\(recipe_id)/steps/\(step_id)", parameters: [
            "position": position,
            "quantity": quantity
        ], onsuccess: { recipe in
            callback(.success(recipe.toRecipe()))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func editStep(recipe_id: Int, step_id: Int, position: Int, quantity: Int, callback: @escaping (Result<Recipe, ApiServiceError>) -> Void){
        ApiService.put(RecipeDTO.self, route: "/recipes/\(recipe_id)/steps/\(step_id)", parameters: [
            "position": position,
            "quantity": quantity
        ], onsuccess: { recipe in
            callback(.success(recipe.toRecipe()))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func removeStep(recipe_id: Int, step_id: Int, callback: @escaping (Result<Recipe, ApiServiceError>) -> Void){
        ApiService.delete(RecipeDTO.self, route: "/recipes/\(recipe_id)/steps/\(step_id)", parameters: [:], onsuccess: { recipe in
            callback(.success(recipe.toRecipe()))
        }, onsuccessText: { text in
            callback(.failure(ApiServiceError.UNKNOWN(text)))
        },onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func put(recipe: Recipe, callback: @escaping (Result<Recipe, ApiServiceError>) -> Void){
        ApiService.put(RecipeDTO.self, route: "/recipes/\(recipe.id)", parameters: [
            "user_id": recipe.user.id,
            "recipe_category_id": recipe.category.id,
            "name": recipe.name,
            "nb_couvert": recipe.nb_couvert
        ], onsuccess: { recipe in
            callback(.success(recipe.toRecipe()))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
}
