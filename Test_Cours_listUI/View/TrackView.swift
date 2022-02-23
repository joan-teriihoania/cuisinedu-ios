//
//  trackView.swift
//  Test_Cours_listUI
//
//  Created by Vincent Baret on 08/02/2022.
//

import SwiftUI

struct trackView: View {
    var intent: TrackIntent
    @ObservedObject var viewModel: TrackViewModel
    @State var errorMessage: String = ""
    @State var showErrorMessage: Bool = false
    
    init(vm: TrackViewModel){
        self.intent = TrackIntent()
        self.viewModel = vm
        self.intent.addObserver(vm: self.viewModel)
    }

    var body: some View {
        VStack{
            Text("Numéro ID : \(viewModel.track.trackId)")
            HStack{
                Text("Nom du morceau :")
                    .padding()
                    .frame(maxHeight: .infinity)
                TextField("", text: $viewModel.trackName)
                    .padding()
                    .frame(maxHeight: .infinity)
                    .onSubmit {
                        intent.intentToChange(trackName: viewModel.trackName)
                    }
                
            }.fixedSize(horizontal: false, vertical: true)
            HStack{
                Text("Nom de l'auteur :")
                    .padding()
                    .frame(maxHeight: .infinity)
                TextField("", text: $viewModel.artistName)
                    .padding()
                    .frame(maxHeight: .infinity)
                    .onSubmit {
                        intent.intentToChange(artistName: viewModel.artistName)
                    }
            }.fixedSize(horizontal: false, vertical: true)
            
            HStack{
                Text("Nom de l'album :")
                    .padding()
                    .frame(maxHeight: .infinity)
                TextField("", text: $viewModel.collectionName)
                    .padding()
                    .frame(maxHeight: .infinity)
                    .onSubmit {
                        intent.intentToChange(collectionName: viewModel.collectionName)
                    }
                
            }.fixedSize(horizontal: false, vertical: true)
        }
        .navigationTitle("Track \(viewModel.trackName)")
        .onChange(of: viewModel.error){ error in
            switch error {
                case .NONE:
                    return
                case .ARTISTNAME(let reason):
                    self.errorMessage = reason
                    self.showErrorMessage = true
                case .TRACKNAME(let reason):
                    self.errorMessage = reason
                    self.showErrorMessage = true
                case .COLLECTIONNAME(let reason):
                    self.errorMessage = reason
                    self.showErrorMessage = true
            }
        }.alert("\(errorMessage)", isPresented: $showErrorMessage){
            Button("Ok", role: .cancel){
                showErrorMessage = false
            }
        }
    }
}

struct trackView_Previews: PreviewProvider {
    static var previews: some View {
        trackView(vm: TrackViewModel(track:Track(trackId: 0, trackName: "", artistName: "", collectionName: "", releaseDate: "")))
    }
}
