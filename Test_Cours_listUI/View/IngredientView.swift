//
//  trackView.swift
//  Test_Cours_listUI
//
//  Created by Vincent Baret on 08/02/2022.
//

import AlertToast
import PopupView
import SwiftUI

struct IngredientView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var intent: IngredientIntent
    var intentOrigin: IngredientIntent
    @ObservedObject var viewModel: IngredientViewModel
    @ObservedObject var viewModelOrigin: IngredientViewModel
    @State var message: String = ""
    @State var showMessage: Bool = false
    @State var showLoadingEdit: Bool = false
    @State var showLoadingDelete: Bool = false
    @State var showUnsavedChangesWarning: Bool = false
    
    @State var showInsertAllergeneList: Bool = false
    @State var allergenesList: Allergenes = Allergenes(allergenes: [])

    @State var showToastUndismissable: Bool = false
    @State var showToast: Bool = false
    @State var toast: AlertToast = AlertToast(displayMode: .hud, type: .regular, title: "")
    
    init(vm: IngredientViewModel){
        self.intent = IngredientIntent()
        self.intentOrigin = IngredientIntent()
        
        self.viewModelOrigin = vm
        self.viewModel = IngredientViewModel(ingredient: vm.ingredient.clone())
        
        self.intent.addObserver(vm: self.viewModel)
        self.intentOrigin.addObserver(vm: self.viewModelOrigin)
        self.intentOrigin.addObserver(vm: self.viewModel)
    }

    var body: some View {
        VStack {
            Form {
                TextField("", text: $viewModel.name, prompt: Text("Nom de l'ingrédient"))
                    .onSubmit {
                        intent.intentToChange(name: viewModel.name)
                    }
                TextField("", value: $viewModel.price, format: .number, prompt: Text("Prix"))
                    .onSubmit {
                        intent.intentToChange(price: viewModel.price)
                    }
                    
                HStack {
                    Text("Catégorie : ")
                    Spacer()
                    NavigationLink("\(viewModel.category.name)", destination: IngredientCategoryView(vm: IngredientCategoryViewModel(ic: viewModel.category)))
                }
                
                HStack {
                    Text("Unité : ")
                    Spacer()
                    NavigationLink("\(viewModel.unit.name)", destination: UnitView(vm: UnitViewModel(unit: viewModel.unit)))
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
                            IngredientDAO.put(ingredient: viewModel.ingredient, callback: {result in
                                showLoadingEdit = false
                                DispatchQueue.main.async {
                                    switch result {
                                        case .success(_):
                                            self.toast = AlertToast(displayMode: .hud, type: .complete(.green), title: "Modifications enregistrées")
                                            self.showToast.toggle()
                                            self.viewModelOrigin.ingredient.set(ingredient: self.viewModel.ingredient)
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
                            intentOrigin.intentToDelete()
                        }
                    }
                }
            }
            
            Divider()
            
            HStack {
                Text("Allergènes").font(.largeTitle).bold()
                Spacer()
                Button(action: {
                    self.toast = AlertToast(displayMode: .alert, type: .loading, title: "Chargement des allergènes...", subTitle: "Veuillez patienter quelques instants")
                    self.showToastUndismissable = true
                    AllergeneDAO.getAll(callback: { result in
                        self.showToastUndismissable = false
                        switch result {
                            case .success(let allergenes):
                                self.allergenesList.set(allergenes: allergenes)
                                self.showInsertAllergeneList = true
                            case .failure(let error):
                                self.toast = AlertToast(displayMode: .alert, type: .error(.red), title: "Erreur : Nous n'avons pas pu charger la liste d'allergène", subTitle: error.description)
                                self.showToast = true
                        }
                    })
                }, label: {
                    Image(systemName: "plus")
                })
                EditButton()
            }
            VStack {
                if viewModel.allergenes.data.count == 0 {
                    Text("Cet ingrédient ne contient pas d'allergène")
                }
                List {
                    ForEach(viewModel.allergenes.vms, id: \.allergene.id) {
                        vm in
                        NavigationLink(destination: AllergeneView(vm: vm)){
                            VStack(alignment: .leading) {
                                Text(vm.allergene.name)
                            }
                        }.onChange(of: vm.error, perform: { error in
                            switch error {
                                case .DELETE(let reason):
                                    message = reason
                                    showMessage = true
                                default:
                                    break
                            }
                        })
                    }
                    .onDelete{ indexSet in
                        viewModel.allergenes.remove(atOffsets: indexSet)
                    }
                }
            }.popup(isPresented: $showInsertAllergeneList, type: .default, position: .bottom, closeOnTap: false, view: {
                VStack {
                    Text("Sélectionnez un allergène à ajouter :")
                    
                    List{
                        ForEach(allergenesList.vms, id: \.allergene.id){
                            vm in
                            Button(vm.allergene.name, action: {
                                self.intentOrigin.intentToAddAllergene(allergene: vm.allergene)
                                self.showInsertAllergeneList = false
                            })
                        }
                    }
                }
                .padding()
                .background(.white)
                .cornerRadius(30)
            }).padding()
        }
        .padding()
        .navigationTitle("Ingrédient")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action : {
            if(!viewModelOrigin.ingredient.equal(ingredient: viewModel.ingredient, ignoreAllergenes: true)){
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
                case .CATEGORY(let reason):
                    self.message = reason
                    self.showMessage = true
                case .PRICE(let reason):
                    self.message = reason
                    self.showMessage = true
                case .UNIT(let reason):
                    self.message = reason
                    self.showMessage = true
                case .DELETE(let reason):
                    self.message = reason
                    self.showMessage = true
                    self.showLoadingDelete = false
                case .ALLERGENE(let reason):
                    self.message = reason
                    self.showMessage = true
            }
        }.onChange(of: viewModelOrigin.deleted){ deleted in
            if(deleted){
                self.mode.wrappedValue.dismiss()
            }
        }.toast(isPresenting: $showToast){
            toast
        }.toast(isPresenting: $showToastUndismissable, duration: 0, tapToDismiss: false){
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
