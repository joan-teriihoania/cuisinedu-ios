//
//  TrackViewModel.swift
//  Test_Cours_listUI
//
//  Created by m1 on 16/02/2022.
//

import Foundation
import Combine
import CoreText

enum TrackError: Error, Equatable, CustomStringConvertible {
    case NONE
    case TRACKNAME(String)
    case ARTISTNAME(String)
    case COLLECTIONNAME(String)
    
    var description: String {
        switch self {
            case .NONE:
                    return "No error"
            case .TRACKNAME:
                    return "Trackname isn't  valid"
            case .ARTISTNAME:
                    return "Artist name isn't valid"
            case .COLLECTIONNAME:
                return "Collection name isn't valid"
        }
    }
}

class TrackViewModel: ObservableObject, TrackObserver, Subscriber {
    typealias Input = TrackIntentState
    typealias Failure = Never
    
    private(set) var track: Track
    @Published var trackName: String
    @Published var artistName: String
    @Published var collectionName: String
    @Published var error: TrackError = .NONE
    var delegate: TrackViewModelDelegate?
    
    init(track: Track){
        self.track = track
        self.trackName = track.trackName
        self.artistName = track.artistName
        self.collectionName = track.collectionName
        self.track.addObserver(obs: self)
    }
    
    func changed(trackName: String) {
        self.trackName = trackName
    }
    
    func changed(collectionName: String) {
        self.collectionName = collectionName
    }
    
    func changed(artistName: String) {
        self.artistName = artistName
    }
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func receive(_ input: TrackIntentState) -> Subscribers.Demand {
        switch input {
            case .READY:
                break
            case .CHANGING_ARTISTNAME(let artistName):
                self.track.artistName = artistName
                if(self.track.artistName != artistName){
                    self.error = .ARTISTNAME("Invalid input")
                }
            case .CHANGING_TRACKNAME(let trackName):
                self.track.trackName = trackName
                if(self.track.trackName != trackName){
                    self.error = .TRACKNAME("Invalid input")
                }
            case .CHANGING_COLLECTIONNAME(let collectionName):
                self.track.collectionName = collectionName
                if(self.track.collectionName != collectionName){
                    self.error = .COLLECTIONNAME("Invalid input")
                }
            case .LIST_UPDATED:
                self.delegate?.trackViewModelChanged()
                break
        }
        
        return .none
    }
}
