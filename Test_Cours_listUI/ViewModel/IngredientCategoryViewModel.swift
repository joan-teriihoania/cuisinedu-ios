//
//  TrackViewModel.swift
//  Test_Cours_listUI
//
//  Created by m1 on 16/02/2022.
//

import Foundation
import Combine
import CoreText

enum IngredientCategoryError: Error, Equatable, CustomStringConvertible {
    case NONE
    case NAME(String)
    case DELETE(String)
    
    var description: String {
        switch self {
            case .NONE:
                    return "No error"
            case .NAME:
                    return "Ingredient category name isn't  valid"
            case .DELETE(let reason):
                return "Erreur : \(reason)"
        }
    }
}

class IngredientCategoryViewModel: ObservableObject, IngredientCategoryObserver, Subscriber {
    typealias Input = IngredientCategoryIntentState
    typealias Failure = Never
    
    private(set) var ic: IngredientCategory
    @Published var name: String
    @Published var deleted: Bool = false
    
    @Published var error: IngredientCategoryError = .NONE
    var delegate: IngredientCategoryViewModelDelegate?
    
    init(ic: IngredientCategory){
        self.ic = ic
        self.name = ic.name
    }
    
    func ingredientCategoryChanged(name: String) {
        self.name = name
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: IngredientCategoryIntentState) -> Subscribers.Demand {
        self.error = .NONE
        switch input {
            case .READY:
                break
            case .CHANGING_NAME(let name):
                self.ic.name = name
                if(self.ic.name != name){
                    self.error = .NAME("Invalid input")
                }
            case .DELETING:
                IngredientCategoryDAO.delete(id: self.ic.id, callback: {result in
                    DispatchQueue.main.async {
                        switch result {
                            case .success(_):
                            self.delegate?.ingredientCategoryDeleted(ic: self.ic)
                                self.deleted = true
                                break
                            case .failure(let error):
                                self.error = .DELETE(error.description)
                        }
                    }
                })
                break
            case .LIST_UPDATED:
                self.delegate?.ingredientCategoryViewModelChanged()
                break
        }
        
        return .none
    }
}
