//
//  trackView.swift
//  Test_Cours_listUI
//
//  Created by Vincent Baret on 08/02/2022.
//

import SwiftUI

struct IngredientCategoryView: View {
    var intent: IngredientCategoryIntent
    @ObservedObject var viewModel: IngredientCategoryViewModel
    @State var errorMessage: String = ""
    @State var showErrorMessage: Bool = false
    
    init(vm: IngredientCategoryViewModel){
        self.intent = IngredientCategoryIntent()
        self.viewModel = vm
        self.intent.addObserver(vm: self.viewModel)
    }

    var body: some View {
        Form {
            TextField("", text: $viewModel.name, prompt: Text("Nom de la catégorie d'ingrédient"))
                .onSubmit {
                    intent.intentToChange(name: viewModel.name)
                }
        }
        .navigationTitle("Catégorie d'ingrédient")
        .onChange(of: viewModel.error){ error in
            switch error {
                case .NONE:
                    return
                case .NAME(let reason):
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
