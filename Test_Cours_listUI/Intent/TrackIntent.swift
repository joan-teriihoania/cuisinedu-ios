//
//  TrackIntent.swift
//  Test_Cours_listUI
//
//  Created by m1 on 16/02/2022.
//

import Foundation
import Combine

enum TrackIntentState: Equatable, CustomStringConvertible {
    case READY
    case CHANGING_ARTISTNAME(String)
    case CHANGING_TRACKNAME(String)
    case CHANGING_COLLECTIONNAME(String)
    case LIST_UPDATED
    
    var description: String {
        switch self {
            case .READY:
                return "Ready"
            case .CHANGING_ARTISTNAME(let artistName):
                return "Changing artist name to \(artistName)"
            case .CHANGING_TRACKNAME(let trackName):
                return "Changing track name to \(trackName)"
            case .CHANGING_COLLECTIONNAME(let collectionName):
                return "Changing collection name to \(collectionName)"
            case .LIST_UPDATED:
                    return "List updated"
        }
    }
}

class TrackIntent: ObservableObject {
    private var state = PassthroughSubject<TrackIntentState, Never>()
    
    func intentToChange(artistName: String){
        self.state.send(.CHANGING_ARTISTNAME(artistName))
        self.state.send(.LIST_UPDATED)
    }
    
    func intentToChange(trackName: String){
        self.state.send(.CHANGING_TRACKNAME(trackName))
        self.state.send(.LIST_UPDATED)
    }
    
    func intentToChange(collectionName: String){
        self.state.send(.CHANGING_COLLECTIONNAME(collectionName))
        self.state.send(.LIST_UPDATED)
    }
    
    func addObserver(vm: TrackViewModel){
        self.state.subscribe(vm)
    }
}
