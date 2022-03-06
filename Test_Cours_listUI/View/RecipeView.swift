//
//  trackView.swift
//  Test_Cours_listUI
//
//  Created by m1 on 08/02/2022.
//

import AlertToast
import SwiftUI

struct RecipeView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var intent: RecipeIntent
    var intentOrigin: RecipeIntent
    @ObservedObject var viewModel: RecipeViewModel
    @ObservedObject var viewModelOrigin: RecipeViewModel
    @State var message: String = ""
    @State var showMessage: Bool = false
    @State var showLoadingEdit: Bool = false
    @State var showLoadingDelete: Bool = false
    @State var showUnsavedChangesWarning: Bool = false
    
    @State var showToast: Bool = false
    @State var toast: AlertToast = AlertToast(displayMode: .hud, type: .regular, title: "")
    
    init(vm: RecipeViewModel){
        self.intent = RecipeIntent()
        self.intentOrigin = RecipeIntent()
        
        self.viewModelOrigin = vm
        self.viewModel = RecipeViewModel(recipe: vm.recipe.clone())
        
        self.intent.addObserver(vm: self.viewModel)
        self.intentOrigin.addObserver(vm: self.viewModelOrigin)
        self.intentOrigin.addObserver(vm: self.viewModel)
    }

    var body: some View {
        Form {
            TextField("", text: $viewModel.name, prompt: Text("Nom de la recette"))
                .onSubmit {
                    intent.intentToChange(name: viewModel.name)
                }
            TextField("", value: $viewModel.nb_couvert, format: .number, prompt: Text("Nombre de couvert"))
                .onSubmit {
                    intent.intentToChange(nb_couvert: viewModel.nb_couvert)
                }
            
            HStack {
                Text("Catégorie : ")
                Spacer()
                NavigationLink("\(viewModel.category.name)", destination: RecipeCategoryView(vm: RecipeCategoryViewModel(rc: viewModel.category)))
            }

            VStack {
                Text("Etapes : ")
                    .padding()
                if viewModel.steps.data.count == 0 {
                    Text("Cette recette ne contient pas d'étapes")
                }
                List {
                    ForEach(viewModel.steps.vms, id: \.step.id) {
                        vm in
                        NavigationLink(destination: StepView(vm: vm)){
                            VStack(alignment: .leading) {
                                Text(vm.step.name)
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
                        viewModel.steps.remove(atOffsets: indexSet)
                    }
                }
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
                        RecipeDAO.put(recipe: viewModel.recipe, callback: { result in
                            showLoadingEdit = false
                            DispatchQueue.main.async {
                                switch result {
                                case .success(_):
                                    self.toast = AlertToast(displayMode: .hud, type: .complete(.green), title: "Modifications enregistrées")
                                    self.showToast.toggle()
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
        .navigationTitle("Etape")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action : {
            if(!viewModelOrigin.recipe.equal(recipe: viewModel.recipe)){
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
                    self.showLoadingDelete = false
                case .CATEGORY(let reason):
                    self.message = reason
                    self.showMessage = true
                case .NB_COUVERT(let reason):
                    self.message = reason
                    self.showMessage = true
                case .STEP(let reason):
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
