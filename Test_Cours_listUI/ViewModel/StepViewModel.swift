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

enum StepError: Error, Equatable, CustomStringConvertible {
    case NONE
    case NAME(String)
    case DESCRIPTION(String)
    case DURATION(String)
    case COMPONENT(String)
    case DELETE(String)
    
    var description: String {
        switch self {
            case .NONE:
                return "No error"
            case .NAME:
                return "Step name isn't  valid"
            case .DESCRIPTION:
                return "Description invalid"
            case .DURATION:
                return "Duration invalid"
            case .COMPONENT:
                return "Component invalid"
            case .DELETE:
                return "Delete error"
        }
    }
}

class StepViewModel: ObservableObject, StepObserver, Subscriber  {
    func stepChanged(name: String) {
        self.name = name
    }
    
    func stepChanged(description: String) {
        self.description = description
    }
    
    func stepChanged(duration: Double) {
        self.duration = duration
    }
    
    func stepChanged(components: [StepComponent]) {
        self.components.set(components: components)
    }
    
    typealias Input = StepIntentState
    typealias Failure = Never
    
    private(set) var step: Step
    @Published var name: String
    @Published var description: String
    @Published var duration: Double
    @Published var deleted: Bool = false
    @ObservedObject var components: StepStepComponents
    
    @Published var error: StepError = .NONE {
        didSet {
            self.delegate?.stepViewModelChanged()
        }
    }
    var delegate: StepViewModelDelegate?
    
    init(step: Step){
        self.step = step
        self.name = step.name
        self.description = step.description
        self.duration = step.duration
        self.components = StepStepComponents(components: step.components)
        
        self.components.vm = self
        self.step.addObserver(obs: self)
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: StepIntentState) -> Subscribers.Demand {
        self.error = .NONE
        switch input {
            case .READY:
                break
        case .CHANGING_NAME(let name):
            self.step.name = name
            if(self.step.name != name){
                self.error = .NAME("Invalid input")
            }
        case .CHANGING_DESCRIPTION(let desc):
            self.step.description = desc
            if(self.step.description != desc){
                self.error = .DESCRIPTION("Invalid input")
            }
        case .CHANGING_DURATION(let duration):
            self.step.duration = duration
            if(self.step.duration != duration){
                self.error = .DURATION("Invalid input")
            }
            case .DELETING:
                StepDAO.delete(id: self.step.id, callback: {result in
                    DispatchQueue.main.async {
                        switch result {
                            case .success(_):
                                self.delegate?.stepDeleted(step: self.step)
                                self.deleted = true
                                break
                            case .failure(let error):
                                self.error = .DELETE(error.description)
                                break
                        }
                    }
                })
            case .LIST_UPDATED:
                self.delegate?.stepViewModelChanged()
                break
            case .ADDING_COMPONENT(let component):
                StepDAO.addComponent(step: self.step, component: component, callback: { result in
                    DispatchQueue.main.async {
                        switch result {
                            case .success(_):
                                self.delegate?.stepViewModelChanged()
                            case .failure(let error):
                            self.error = .COMPONENT(error.description)
                        }
                    }
                })
            case .REMOVING_COMPONENT(let component):
                StepDAO.removeComponent(step: self.step, component: component, callback: { result in
                    DispatchQueue.main.async {
                        switch result {
                            case .success(_):
                                self.delegate?.stepViewModelChanged()
                            case .failure(let error):
                            self.error = .COMPONENT(error.description)
                        }
                    }
                })
        }
        
        return .none
    }
}
