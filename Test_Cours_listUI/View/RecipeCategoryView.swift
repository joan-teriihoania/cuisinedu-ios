//
//  trackView.swift
//  Test_Cours_listUI
//
//  Created by Vincent Baret on 08/02/2022.
//

import AlertToast
import SwiftUI

struct RecipeCategoryView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var intent: RecipeCategoryIntent
    @ObservedObject var viewModel: RecipeCategoryViewModel
    @ObservedObject var viewModelOrigin: RecipeCategoryViewModel
    @State var hasUnsavedChanges: Bool = true
    @State var message: String = ""
    @State var showMessage: Bool = false
    @State var showLoadingEdit: Bool = false
    @State var showLoadingDelete: Bool = false
    @State var showUnsavedChangesWarning: Bool = false
    
    @State var showToast: Bool = false
    @State var toast: AlertToast = AlertToast(displayMode: .hud, type: .regular, title: "")
    
    init(vm: RecipeCategoryViewModel){
        self.intent = RecipeCategoryIntent()
        self.viewModelOrigin = vm
        self.viewModel = RecipeCategoryViewModel(rc: vm.rc.clone())
        self.intent.addObserver(vm: self.viewModel)
    }

    var body: some View {
        Form {
            TextField("", text: $viewModel.name, prompt: Text("Nom de la catégorie d'ingrédient"))
                .onSubmit {
                    intent.intentToChange(name: viewModel.name)
                }
        
            Section{
                HStack{
                    Button(action: {}){
                        if(self.showLoadingEdit){
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            Image(systemName: "paperplane")
                        }
                        Text("Enregistrer")
                    }
                    .foregroundColor(Color.blue)
                    .onTapGesture {
                        showLoadingEdit = true
                        RecipeCategoryDAO.put(rc: viewModel.rc, callback: {result in
                            showLoadingEdit = false
                            DispatchQueue.main.async {
                                switch result {
                                    case .success(_):
                                        self.toast = AlertToast(displayMode: .hud, type: .complete(.green), title: "Modifications enregistrées")
                                        self.showToast.toggle()
                                        self.viewModelOrigin.rc.set(rc: self.viewModel.rc)
                                        break
                                    case .failure(let error):
                                        self.message = error.description
                                        self.showMessage = true
                                }
                            }
                        })
                    }
                    
                    Spacer()
                    
                    Button(action: {}){
                        if(self.showLoadingDelete){
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            Image(systemName: "trash")
                        }
                        Text("Supprimer")
                    }
                    .foregroundColor(Color.red)
                    .onTapGesture {
                        showLoadingDelete = true
                        intent.intentToDelete()
                    }
                }
            }
        }
        .navigationTitle("Catégorie d'ingrédient")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action : {
            if(!viewModelOrigin.rc.equal(rc: viewModel.rc)){
                self.showUnsavedChangesWarning = true
            } else {
                self.mode.wrappedValue.dismiss()
            }
        }){
            Image(systemName: "arrow.left")
        })
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
        }.toast(isPresenting: $showToast){
            toast
        }.alert("\(message)", isPresented: $showMessage){
            Button("Ok", role: .cancel){
                showMessage = false
            }
        }.alert("Vous avez des modifications qui ne sont pas enregistrées.", isPresented: $showUnsavedChangesWarning){
            Button("Quitter sans enregistrer"){
                self.mode.wrappedValue.dismiss()
            }
            Button("Ne pas quitter", role: .cancel){
                showUnsavedChangesWarning = false
            }
        }
    }
}
