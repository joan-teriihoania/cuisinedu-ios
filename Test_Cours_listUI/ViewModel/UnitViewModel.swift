//
//  TrackViewModel.swift
//  Test_Cours_listUI
//
//  Created by m1 on 16/02/2022.
//

import Foundation
import Combine
import CoreText

enum UnitError: Error, Equatable, CustomStringConvertible {
    case NONE
    case NAME(String)
    case DELETE(String)
    
    var description: String {
        switch self {
            case .NONE:
                    return "No error"
            case .NAME:
                    return "Unit name isn't  valid"
            case .DELETE:
                return "Unable to delete unit"
        }
    }
}

class UnitViewModel: ObservableObject, UnitObserver, Subscriber {
    typealias Input = UnitIntentState
    typealias Failure = Never
    
    private(set) var unit: Unit
    @Published var name: String {
        didSet {
            if(name.count == 0){
                name = oldValue
            }
        }
    }
    
    @Published var error: UnitError = .NONE
    @Published var deleted: Bool = false
    var delegate: UnitViewModelDelegate?
    
    init(unit: Unit){
        self.unit = unit
        self.name = unit.name
    }
    
    func unitChanged(name: String) {
        self.name = name
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: UnitIntentState) -> Subscribers.Demand {
        switch input {
            case .READY:
                break
            case .CHANGING_NAME(let name):
                self.unit.name = name
                if(self.unit.name != name){
                    self.error = .NAME("Invalid input")
                }
            case .DELETING:
                UnitDAO.delete(id: self.unit.id, callback: {result in
                    switch result {
                        case .success(_):
                            self.delegate?.unitDeleted()
                            self.deleted = true
                            break
                        case .failure(let error):
                            self.error = .DELETE(error.description)
                    }
                })
                break
            case .LIST_UPDATED:
                self.delegate?.unitViewModelChanged()
                break
        }
        
        return .none
    }
}
