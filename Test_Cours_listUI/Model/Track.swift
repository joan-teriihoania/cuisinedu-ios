//
//  Track.swift
//  Test_Cours_listUI
//
//  Created by Vincent Baret on 08/02/2022.
//

import Foundation

protocol TrackObserver {
    func changed(trackName: String)
    func changed(collectionName: String)
    func changed(artistName: String)
}

enum TrackPropertyChange {
    case TRACKNAME
    case ARTISTNAME
    case COLLECTIONNAME
}

class Track: ObservableObject, Decodable {
    private var observers: [TrackObserver] = []
    var trackId: Int
    @Published var trackName: String {
        didSet {
            if(trackName.count < 3){
                trackName = oldValue
            }
            notifyObservers(t: .TRACKNAME)
        }
    }
    @Published var artistName: String {
        didSet {
            if(artistName.count < 3){
                artistName = oldValue
            }
            notifyObservers(t: .ARTISTNAME)
        }
    }
    @Published var collectionName: String {
        didSet {
            if(collectionName.count < 3){
                collectionName = oldValue
            }
            notifyObservers(t: .COLLECTIONNAME)
        }
    }
    @Published var releaseDate: String
    private enum CodingKeys: String, CodingKey {
        case trackId = "trackId"
        case trackName = "trackName"
        case artistName = "artistName"
        case collectionName = "collectionName"
        case releaseDate = "releaseDate"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        trackId = try values.decode(Int.self, forKey: .trackId)
        trackName = try values.decode(String.self, forKey: .trackName)
        artistName = try values.decode(String.self, forKey: .artistName)
        collectionName = try values.decode(String.self, forKey: .collectionName)
        releaseDate = try values.decode(String.self, forKey: .releaseDate)
    }
    
    init(trackId: Int, trackName: String, artistName: String, collectionName: String, releaseDate: String){
        self.trackId = trackId
        self.trackName = trackName
        self.artistName = artistName
        self.collectionName = collectionName
        self.releaseDate = releaseDate
    }
    
    func addObserver(obs: TrackObserver){
        observers.append(obs)
    }
    
    func notifyObservers(t: TrackPropertyChange){
        for observer in observers {
            switch t {
                case .ARTISTNAME:
                    observer.changed(artistName: artistName)
                case .COLLECTIONNAME:
                    observer.changed(collectionName: collectionName)
                case .TRACKNAME:
                    observer.changed(trackName: trackName)
            }
        }
    }
}
