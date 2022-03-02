//
//  Ingredients.swift
//  Test_Cours_listUI
//
//  Created by m1 on 22/02/2022.
//

import Foundation

class Ingredients: ObservableObject, IngredientViewModelDelegate {
    @Published var data: [Ingredient]
    @Published var vms: [IngredientViewModel]
    
    func ingredientViewModelChanged() {
        self.objectWillChange.send()
    }
    
    func ingredientDeleted(ingredient: Ingredient) {
        if let index = self.data.firstIndex(of: ingredient){
            self.data.remove(at: index)
            self.vms.remove(at: index)
        }
    }
    
    func remove(atOffsets: IndexSet){
        atOffsets.forEach{ (i) in
            let intent: IngredientIntent = IngredientIntent()
            intent.addObserver(vm: self.vms[i])
            intent.intentToDelete()
        }
    }
    
    func remove(atIndex: Int){
        self.data.remove(at: atIndex)
        self.vms.remove(at: atIndex)
    }
    
    func reloadVms(){
        self.vms = []
        for ingredient in self.data {
            let vm = IngredientViewModel(ingredient: ingredient)
            vm.delegate = self
            self.vms.append(vm)
        }
        self.ingredientViewModelChanged()
    }
    
    init(retrieveFromApi: Bool){
        self.vms = []
        self.data = []
        
        if(retrieveFromApi){
            IngredientDAO.getAll(callback: { result in
                switch result {
                    case .success(let ingredients):
                        DispatchQueue.main.async {
                            self.data = ingredients.sorted(by: {$0.name.lowercased() < $1.name.lowercased()})
                            self.reloadVms()
                            self.ingredientViewModelChanged()
                        }
                    case .failure(_):
                        break
                }
            })
        }
    }
}
