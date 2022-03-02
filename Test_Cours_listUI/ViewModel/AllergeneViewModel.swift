//
//  TrackViewModel.swift
//  Test_Cours_listUI
//
//  Created by m1 on 16/02/2022.
//

import Foundation
import Combine
import CoreText

enum AllergeneError: Error, Equatable, CustomStringConvertible {
    case NONE
    case NAME(String)
    case DELETE(String)
    
    var description: String {
        switch self {
            case .NONE:
                    return "No error"
            case .NAME:
                    return "Allergene name isn't  valid"
            case .DELETE:
                return "Unable to delete allergene"
        }
    }
}

class AllergeneViewModel: ObservableObject, AllergeneObserver, Subscriber {
    typealias Input = AllergeneIntentState
    typealias Failure = Never
    
    private(set) var allergene: Allergene
    @Published var name: String {
        didSet {
            if(name.count == 0){
                name = oldValue
            }
        }
    }
    
    @Published var error: AllergeneError = .NONE {
        didSet {
            self.delegate?.allergeneViewModelChanged()
        }
    }
    @Published var deleted: Bool = false
    var delegate: AllergeneViewModelDelegate?
    
    init(allergene: Allergene){
        self.allergene = allergene
        self.name = allergene.name
    }
    
    func allergeneChanged(name: String) {
        self.name = name
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: AllergeneIntentState) -> Subscribers.Demand {
        self.error = .NONE
        switch input {
            case .READY:
                break
            case .CHANGING_NAME(let name):
                self.allergene.name = name
                if(self.allergene.name != name){
                    self.error = .NAME("Invalid input")
                }
            case .DELETING:
                AllergeneDAO.delete(id: self.allergene.id, callback: {result in
                    DispatchQueue.main.async {
                        switch result {
                            case .success(_):
                                self.delegate?.allergeneDeleted(allergene: self.allergene)
                                self.deleted = true
                                break
                            case .failure(let error):
                                self.error = .DELETE(error.description)
                        }
                    }
                })
                break
            case .LIST_UPDATED:
                self.delegate?.allergeneViewModelChanged()
                break
        }
        
        return .none
    }
}
