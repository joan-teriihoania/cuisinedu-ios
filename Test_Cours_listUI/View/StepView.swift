//
//  trackView.swift
//  Test_Cours_listUI
//
//  Created by m1 on 08/02/2022.
//

import AlertToast
import SwiftUI

struct StepView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var intent: StepIntent
    var intentOrigin: StepIntent
    @ObservedObject var viewModel: StepViewModel
    @ObservedObject var viewModelOrigin: StepViewModel
    @State var message: String = ""
    @State var showMessage: Bool = false
    @State var showLoadingEdit: Bool = false
    @State var showLoadingDelete: Bool = false
    @State var showUnsavedChangesWarning: Bool = false
    
    @State var showToast: Bool = false
    @State var toast: AlertToast = AlertToast(displayMode: .hud, type: .regular, title: "")
    
    init(vm: StepViewModel){
        self.intent = StepIntent()
        self.intentOrigin = StepIntent()
        
        self.viewModelOrigin = vm
        self.viewModel = StepViewModel(step: vm.step.clone())
        
        self.intent.addObserver(vm: self.viewModel)
        self.intentOrigin.addObserver(vm: self.viewModelOrigin)
        self.intentOrigin.addObserver(vm: self.viewModel)
    }

    var body: some View {
        Form {
            TextField("", text: $viewModel.name, prompt: Text("Nom de l'étape"))
                .onSubmit {
                    intent.intentToChange(name: viewModel.name)
                }
            TextField("", text: $viewModel.description, prompt: Text("Description de l'étape"))
                .onSubmit {
                    intent.intentToChange(description: viewModel.description)
                }
            TextField("", value: $viewModel.duration, format: .number, prompt: Text("Durée de l'étape"))
                .onSubmit {
                    intent.intentToChange(duration: viewModel.duration)
                }

            VStack {
                Text("Composants : ")
                    .padding()
                if viewModel.components.data.count == 0 {
                    Text("Cette étape ne contient pas de composants")
                }
                List {
                    ForEach(viewModel.components.vms, id: \.stepComponent.id) {
                        vm in
                        switch vm.stepComponent.component.getObject() {
                            case .INGREDIENT(let ingredient):
                                let destView = IngredientView(vm: IngredientViewModel(ingredient: ingredient))
                                NavigationLink(destination: destView){
                                    VStack(alignment: .leading) {
                                        Text(vm.stepComponent.component.getName())
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
                            case .RECIPE(let recipe):
                                let destView = RecipeView(vm: RecipeViewModel(recipe: recipe))
                                NavigationLink(destination: destView){
                                    VStack(alignment: .leading) {
                                        Text(vm.stepComponent.component.getName())
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
                            case .STEP(let step):
                                let destView = StepView(vm: StepViewModel(step: step))
                                NavigationLink(destination: destView){
                                    VStack(alignment: .leading) {
                                        Text(vm.stepComponent.component.getName())
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
                    }
                    .onDelete{ indexSet in
                        viewModel.components.remove(atOffsets: indexSet)
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
                        StepDAO.put(step: viewModel.step, callback: { result in
                            showLoadingEdit = false
                            DispatchQueue.main.async {
                                switch result {
                                case .success(_):
                                    self.toast = AlertToast(displayMode: .hud, type: .complete(.green), title: "Modifications enregistrées")
                                    self.showToast.toggle()
                                    self.viewModelOrigin.step.set(step: self.viewModel.step)
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
            if(!viewModelOrigin.step.equal(step: viewModel.step)){
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
                case .DESCRIPTION(let reason):
                    self.message = reason
                    self.showMessage = true
                case .DURATION(let reason):
                    self.message = reason
                    self.showMessage = true
                case .COMPONENT(let reason):
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
