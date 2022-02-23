//
//  trackView.swift
//  Test_Cours_listUI
//
//  Created by Vincent Baret on 08/02/2022.
//

import SwiftUI

struct IngredientView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var intent: IngredientIntent
    @ObservedObject var viewModel: IngredientViewModel
    @State var message: String = ""
    @State var showMessage: Bool = false
    
    init(vm: IngredientViewModel){
        self.intent = IngredientIntent()
        self.viewModel = vm
        self.intent.addObserver(vm: self.viewModel)
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
                            Image(systemName: "paperplane")
                            Text("Enregistrer")
                        }
                        .foregroundColor(Color.blue)
                        .onTapGesture {
                            IngredientDAO.put(ingredient: viewModel.ingredient, callback: {result in
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
            .navigationTitle("Ingrédient")
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
                }
            }.onChange(of: viewModel.deleted){ deleted in
                if(deleted){
                    self.mode.wrappedValue.dismiss()
                }
            }
            .alert("\(message)", isPresented: $showMessage){
                Button("Fermer", role: .cancel){
                    showMessage = false
                }
            }
        }
    }
}
