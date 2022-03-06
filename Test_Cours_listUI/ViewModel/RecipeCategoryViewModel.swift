//
//  TrackViewModel.swift
//  Test_Cours_listUI
//
//  Created by m1 on 16/02/2022.
//

import Foundation
import Combine
import CoreText

enum RecipeCategoryError: Error, Equatable, CustomStringConvertible {
    case NONE
    case NAME(String)
    case DELETE(String)
    
    var description: String {
        switch self {
            case .NONE:
                    return "No error"
            case .NAME:
                    return "Recipe category name isn't  valid"
            case .DELETE(let reason):
                return "Erreur : \(reason)"
        }
    }
}

class RecipeCategoryViewModel: ObservableObject, RecipeCategoryObserver, Subscriber {
    typealias Input = RecipeCategoryIntentState
    typealias Failure = Never
    
    private(set) var rc: RecipeCategory
    @Published var name: String
    @Published var deleted: Bool = false
    
    @Published var error: RecipeCategoryError = .NONE
    var delegate: RecipeCategoryViewModelDelegate?
    
    init(rc: RecipeCategory){
        self.rc = rc
        self.name = rc.name
    }
    
    func recipeCategoryChanged(name: String) {
        self.name = name
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: RecipeCategoryIntentState) -> Subscribers.Demand {
        self.error = .NONE
        switch input {
            case .READY:
                break
            case .CHANGING_NAME(let name):
                self.rc.name = name
                if(self.rc.name != name){
                    self.error = .NAME("Invalid input")
                }
            case .DELETING:
                RecipeCategoryDAO.delete(id: self.rc.id, callback: {result in
                    DispatchQueue.main.async {
                        switch result {
                            case .success(_):
                                self.delegate?.recipeCategoryDeleted(rc: self.rc)
                                self.deleted = true
                                break
                            case .failure(let error):
                                self.error = .DELETE(error.description)
                                self.delegate?.recipeCategoryViewModelChanged()
                        }
                    }
                })
                break
            case .LIST_UPDATED:
                self.delegate?.recipeCategoryViewModelChanged()
                break
        }
        
        return .none
    }
}
