//
//  Tracks.swift
//  Test_Cours_listUI
//
//  Created by m1 on 16/02/2022.
//

import SwiftUI

class Tracks: ObservableObject, TrackViewModelDelegate {
    @Published var data: [Track]
    @Published var vms: [TrackViewModel]
    
    func trackViewModelChanged() {
        objectWillChange.send()
    }
    
    func move(atOffsets: IndexSet, toOffset: Int){
        data.move(fromOffsets: atOffsets, toOffset: toOffset)
        vms.move(fromOffsets: atOffsets, toOffset: toOffset)
    }
    
    func remove(atOffsets: IndexSet){
        data.remove(atOffsets: atOffsets)
        vms.remove(atOffsets: atOffsets)
    }
    
    init(fromFile: String, ext: String){
        self.vms = []
        self.data = []
        
        let result = JSONHelper.loadFomFile(name: fromFile, ext: ext)
        switch result {
            case let .success(content):
                let results: Result<[TrackDTO], JSONError> = JSONHelper.decode(data: content)
                switch results {
                    case let .success(tracks):
                        for track in tracks {
                            let vm = TrackViewModel(track: track.toTrack())
                            vm.delegate = self
                            self.vms.append(vm)
                        }
                        self.data = TrackDTO.convert(trackDTOs: tracks)
                        return
                    case let .failure(error): print("Error: \(error)")
                }
            case let .failure(error): print("Error: \(error)")
        }
    }
}
