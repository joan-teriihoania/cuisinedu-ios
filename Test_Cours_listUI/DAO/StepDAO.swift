//
//  IngredientDAO.swift
//  Test_Cours_listUI
//
//  Created by m1 on 22/02/2022.
//

import Foundation

class StepDAO {
    static func get(id: Int, callback: @escaping (Result<Step, ApiServiceError>) -> Void){
        ApiService.get(StepDTO.self, route: "/steps/\(id)", onsuccess: { step in
            callback(.success(step.toStep()))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func post(step: Step, callback: @escaping (Result<Step, ApiServiceError>) -> Void){
        ApiService.post(StepDTO.self, route: "/steps", parameters: [
            "name": step.name,
            "description": step.description,
            "duration": step.duration
        ], onsuccess: { step in
            callback(.success(step.toStep()))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func delete(id: Int, callback: @escaping (Result<String, ApiServiceError>) -> Void){
        ApiService.delete(String.self, route: "/steps/\(id)", parameters: [:], onsuccess: { response in
            callback(.success(response))
        }, onsuccessText: { response in
            callback(.success(response))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func getAll(callback: @escaping (Result<[Step], ApiServiceError>) -> Void){
        ApiService.get([StepDTO].self, route: "/steps", onsuccess: { steps in
            callback(.success(StepDTO.toStep(dtos: steps)))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func put(step: Step, callback: @escaping (Result<Step, ApiServiceError>) -> Void){
        ApiService.put(StepDTO.self, route: "/steps/\(step.id)", parameters: [
            "name": step.name,
            "description": step.description,
            "duration": step.duration
        ], onsuccess: { step in
            callback(.success(step.toStep()))
        }, onerror: { (reason, response, error) in
            callback(.failure(error == nil ? ApiServiceError.UNKNOWN(reason) : error as! ApiServiceError))
        })
    }
    
    static func addComponent(step: Step, component: StepComponent, callback: @escaping (Result<Step, ApiServiceError>) -> Void){
        StepComponentDAO.post(step: component, step_id: step.id, callback: { result in
            switch result {
                case .success(_):
                    StepDAO.get(id: step.id, callback: callback)
                case .failure(let reason):
                    callback(.failure(reason))
            }
        })
    }
    
    static func removeComponent(step: Step, component: StepComponent, callback: @escaping (Result<Step, ApiServiceError>) -> Void){
        StepComponentDAO.delete(id: component.id, callback: { result in
            switch result {
                case .success(_):
                    StepDAO.get(id: step.id, callback: callback)
                case .failure(let reason):
                    callback(.failure(reason))
            }
        })
    }
}
