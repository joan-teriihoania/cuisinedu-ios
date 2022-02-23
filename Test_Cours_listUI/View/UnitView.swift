//
//  trackView.swift
//  Test_Cours_listUI
//
//  Created by Vincent Baret on 08/02/2022.
//

import SwiftUI

struct UnitView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var intent: UnitIntent
    @ObservedObject var viewModel: UnitViewModel
    @State var message: String = ""
    @State var showMessage: Bool = false
    
    init(vm: UnitViewModel){
        self.intent = UnitIntent()
        self.viewModel = vm
        self.intent.addObserver(vm: self.viewModel)
    }

    var body: some View {
        Form {
            TextField("", text: $viewModel.name, prompt: Text("Nom de l'unité"))
                .onSubmit {
                    intent.intentToChange(name: viewModel.name)
                }
            
            Section{
                HStack{
                    Button(action: {}){
                        Image(systemName: "paperplane")
                        Text("Enregistrer")
                    }
                    .foregroundColor(Color.blue)
                    .onTapGesture {
                        UnitDAO.put(unit: viewModel.unit, callback: {result in
                            switch result {
                                case .success(_):
                                    self.message = "Modifications enregistrées"
                                    self.showMessage = true
                                    break
                                case .failure(let error):
                                    self.message = error.description
                                    self.showMessage = true
                            }
                        })
                    }
                    
                    Spacer()
                    
                    Button(action: {}){
                        Image(systemName: "trash")
                        Text("Supprimer")
                    }
                    .foregroundColor(Color.red)
                    .onTapGesture {
                        intent.intentToDelete()
                    }
                }
            }
        }
        .navigationTitle("Unité")
        .onChange(of: viewModel.error){ error in
            switch error {
                case .NONE:
                    return
                case .NAME(let reason):
                    self.message = reason
                    self.showMessage = true
                case .DELETE(let reason):
                    self.message = reason
                    self.showMessage = true
            }
        }.onChange(of: viewModel.deleted){ deleted in
            if deleted {
                self.mode.wrappedValue.dismiss()
            }
        }.alert("\(message)", isPresented: $showMessage){
            Button("Ok", role: .cancel){
                showMessage = false
            }
        }
    }
}
