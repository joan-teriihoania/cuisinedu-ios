//
//  trackView.swift
//  Test_Cours_listUI
//
//  Created by m1 on 08/02/2022.
//

import AlertToast
import SwiftUI

struct StepComponentView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var intent: StepComponentIntent
    var intentOrigin: StepComponentIntent
    @ObservedObject var viewModel: StepComponentViewModel
    @ObservedObject var viewModelOrigin: StepComponentViewModel
    @State var message: String = ""
    @State var showMessage: Bool = false
    @State var showLoadingEdit: Bool = false
    @State var showLoadingDelete: Bool = false
    @State var showUnsavedChangesWarning: Bool = false
    
    @State var showToast: Bool = false
    @State var toast: AlertToast = AlertToast(displayMode: .hud, type: .regular, title: "")
    
    init(vm: StepComponentViewModel){
        self.intent = StepComponentIntent()
        self.intentOrigin = StepComponentIntent()
        
        self.viewModelOrigin = vm
        self.viewModel = StepComponentViewModel(component: vm.stepComponent.clone())
        
        self.intent.addObserver(vm: self.viewModel)
        self.intentOrigin.addObserver(vm: self.viewModelOrigin)
        self.intentOrigin.addObserver(vm: self.viewModel)
    }

    var body: some View {
        Form {
            TextField("", value: $viewModel.quantity, format: .number, prompt: Text("Quantité"))
                .onSubmit {
                    intent.intentToChange(quantity: viewModel.quantity)
                }
            
            HStack {
                Text("Composant : ")
                Spacer()
                switch viewModel.component.getObject() {
                    case .STEP(let step):
                        NavigationLink("Etape - \(step.name)", destination: StepView(vm: StepViewModel(step: step)))
                    case .RECIPE(let recipe):
                        NavigationLink("Recette - \(recipe.name)", destination: RecipeView(vm: RecipeViewModel(recipe: recipe)))
                    case .INGREDIENT(let ingredient):
                        NavigationLink("Ingrédient - \(ingredient.name)", destination: IngredientView(vm: IngredientViewModel(ingredient: ingredient)))
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
                        StepComponentDAO.put(step: viewModel.stepComponent, callback: { result in
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
                        intentOrigin.intentToDelete()
                    }
                }
            }
        }
        .navigationTitle("Composant d'étape")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action : {
            if(!viewModelOrigin.stepComponent.equal(component: viewModel.stepComponent)){
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
                case .QUANTITY(let reason):
                    self.message = reason
                    self.showMessage = true
                case .COMPONENT(let reason):
                    self.message = reason
                    self.showMessage = true
                case .DELETE(let reason):
                    self.message = reason
                    self.showMessage = true
                    self.showLoadingDelete = false
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
