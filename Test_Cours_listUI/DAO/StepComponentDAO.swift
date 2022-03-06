//
//  IngredientDAO.swift
//  Test_Cours_listUI
//
//  Created by m1 on 22/02/2022.
//

import Foundation

class StepComponentDAO {
    static func get(id: Int, callback: @escaping (Result<StepComponent, ApiServiceError>) -> Void){
        ApiService.get(StepComponentDTO.self, route: "/step_components/\(id)", onsuccess: { step in
            callback(.success(step.toStepComponent()))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func post(step: StepComponent, step_id: Int, callback: @escaping (Result<StepComponent, ApiServiceError>) -> Void){
        let sub_fieldname: String
        let sub_value: Int
        
        switch(step.component.getObject()){
            case .RECIPE(let recipe):
                sub_fieldname = "sub_recipe_id"
                sub_value = recipe.id
            case .INGREDIENT(let ingredient):
                sub_fieldname = "sub_ingredient_id"
                sub_value = ingredient.id
            case .STEP(let step):
                sub_fieldname = "sub_step_id"
                sub_value = step.id
        }
        
        ApiService.post(StepComponentDTO.self, route: "/steps/\(step_id)/components", parameters: [
            sub_fieldname: sub_value,
            "quantity": step.quantity
        ], onsuccess: { step in
            callback(.success(step.toStepComponent()))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func delete(id: Int, callback: @escaping (Result<String, ApiServiceError>) -> Void){
        ApiService.delete(String.self, route: "/step_components/\(id)", parameters: [:], onsuccess: { response in
            callback(.success(response))
        }, onsuccessText: { response in
            callback(.success(response))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func getAll(callback: @escaping (Result<[StepComponent], ApiServiceError>) -> Void){
        ApiService.get([StepComponentDTO].self, route: "/step_components", onsuccess: { steps in
            callback(.success(StepComponentDTO.toStepComponent(dtos: steps)))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func put(step: StepComponent, callback: @escaping (Result<StepComponent, ApiServiceError>) -> Void){
        let sub_fieldname: String
        let sub_value: Int
        
        switch(step.component.getObject()){
            case .RECIPE(let recipe):
                sub_fieldname = "sub_recipe_id"
                sub_value = recipe.id
            case .INGREDIENT(let ingredient):
                sub_fieldname = "sub_ingredient_id"
                sub_value = ingredient.id
            case .STEP(let step):
                sub_fieldname = "sub_step_id"
                sub_value = step.id
        }
        
        ApiService.put(StepComponentDTO.self, route: "/step_components/\(step.id)", parameters: [
            sub_fieldname: sub_value,
            "quantity": step.quantity
        ], onsuccess: { step in
            callback(.success(step.toStepComponent()))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
}
