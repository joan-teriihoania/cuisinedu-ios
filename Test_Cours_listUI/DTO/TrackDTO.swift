//
//  TrackDTO.swift
//  Test_Cours_listUI
//
//  Created by m1 on 17/02/2022.
//

import Foundation

class TrackDTO: Decodable {
    var id: Int
    var trackName: String?
    var artworkUrl: String?
    var collectionName: String
    var artistName: String
    var releaseDate: String
    
    private enum CodingKeys: String, CodingKey {
        case trackId = "trackId"
        case collectionId = "collectionId"
        case trackName = "trackName"
        case artistName = "artistName"
        case collectionName = "collectionName"
        case releaseDate = "releaseDate"
        case url = "artWorkUrl100"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.id = try values.decode(Int.self, forKey: .trackId)
        } catch {
            self.id = try values.decode(Int.self, forKey: .collectionId)
        }
        
        do {
            self.trackName = try values.decode(String.self, forKey: .trackName)
        } catch {
            self.trackName = nil
        }
        
        self.artistName = try values.decode(String.self, forKey: .artistName)
        self.collectionName = try values.decode(String.self, forKey: .collectionName)
        self.releaseDate = try values.decode(String.self, forKey: .releaseDate)
        do {
            self.artworkUrl = try values.decode(String.self, forKey: .url)
        } catch {
            self.artworkUrl = nil
        }
    }
    
    static func convert(trackDTOs: [TrackDTO]) -> [Track]{
        var tracks: [Track] = []
        for trackDTO in trackDTOs {
            tracks.append(trackDTO.toTrack())
        }
        return tracks
    }
    
    func toTrack() -> Track{
        return Track(trackId: self.id, trackName: self.trackName ?? "", artistName: self.artistName, collectionName: self.collectionName, releaseDate: self.releaseDate)
    }
}
