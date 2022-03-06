//
//  TrackListView.swift
//  Test_Cours_listUI
//
//  Created by m1 on 22/02/2022.
//

import SwiftUI

struct TrackListView: View {
    @StateObject var dataTrack: Tracks = Tracks(fromFile: "playlist", ext: "json")
    
    var body: some View {
        NavigationView{
            VStack{
                List {
                    ForEach(dataTrack.vms, id: \.track.trackId) {
                        vm in
                        NavigationLink(destination: trackView(vm: vm)){
                            VStack(alignment: .leading) {
                                Text(vm.track.trackName)
                                Text("Artist : \(vm.track.artistName)")
                                Text("Album : \(vm.track.collectionName) ")
                            }
                        }
                    }
                    .onDelete{ indexSet in dataTrack.remove(atOffsets: indexSet)
                    }
                    .onMove {
                        indexSet, index in
                        dataTrack.move(atOffsets: indexSet , toOffset: index)
                    }
                }
                EditButton()
            }.navigationTitle("Liste de musiques")
        }
    }
}

struct TrackListView_Previews: PreviewProvider {
    static var previews: some View {
        TrackListView()
    }
}
