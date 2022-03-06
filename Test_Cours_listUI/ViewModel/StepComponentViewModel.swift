//
//  TrackViewModel.swift
//  Test_Cours_listUI
//
//  Created by m1 on 16/02/2022.
//

import Foundation
import Combine
import CoreText
import SwiftUI

enum StepComponentError: Error, Equatable, CustomStringConvertible {
    case NONE
    case QUANTITY(String)
    case COMPONENT(String)
    case DELETE(String)
    
    var description: String {
        switch self {
            case .NONE:
                    return "No error"
            case .QUANTITY:
                return "Quantity error"
            case .COMPONENT:
                return "Component error"
            case .DELETE:
                return "Delete error"
        }
    }
}

class StepComponentViewModel: ObservableObject, StepComponentObserver, Subscriber, StepComponentAbleObserver  {
    func stepComponentAbleChanged(component: StepComponentAble) {
        objectWillChange.send()
    }
    
    func stepComponentChanged(quantity: Int) {
        self.quantity = quantity
    }
    
    func stepComponentChanged(component: StepComponentAble) {
        self.component = component
    }
    
    typealias Input = StepComponentIntentState
    typealias Failure = Never
    
    private(set) var stepComponent: StepComponent
    @Published var quantity: Int
    @Published var component: StepComponentAble
    @Published var deleted: Bool = false
    
    @Published var error: StepComponentError = .NONE {
        didSet {
            self.delegate?.stepComponentViewModelChanged()
        }
    }
    var delegate: StepComponentViewModelDelegate?
    
    init(component: StepComponent){
        self.stepComponent = component
        self.component = component.component
        self.quantity = component.quantity
        
        self.component.addObserver(obs: self)
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: StepComponentIntentState) -> Subscribers.Demand {
        self.error = .NONE
        switch input {
            case .READY:
                break
            case .CHANGING_QUANTITY(let quantity):
                self.stepComponent.quantity = quantity
                if(self.stepComponent.quantity != quantity){
                    self.error = .QUANTITY("Invalid input")
                }
            case .DELETING:
                StepComponentDAO.delete(id: self.stepComponent.id, callback: {result in
                    DispatchQueue.main.async {
                        switch result {
                            case .success(_):
                                self.delegate?.stepComponentDeleted(component: self.stepComponent)
                                self.deleted = true
                                break
                            case .failure(let error):
                                self.error = .DELETE(error.description)
                                break
                        }
                    }
                })
            case .LIST_UPDATED:
                self.delegate?.stepComponentViewModelChanged()
                break
        }
        
        return .none
    }
}
