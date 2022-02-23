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
        DispatchQueue.main.async { self.objectWillChange.send() }
    }
    
    func ingredientDeleted(ingredient: Ingredient) {
        DispatchQueue.main.async {
            if let index = self.data.firstIndex(of: ingredient){
                self.data.remove(at: index)
                self.vms.remove(at: index)
            }
        }
    }
    
    func remove(atOffsets: IndexSet){
        DispatchQueue.main.async {
            atOffsets.forEach{ (i) in
                let intent: IngredientIntent = IngredientIntent()
                intent.addObserver(vm: self.vms[i])
                intent.intentToDelete()
            }
        }
    }
    
    func remove(atIndex: Int){
        DispatchQueue.main.async {
            self.data.remove(at: atIndex)
            self.vms.remove(at: atIndex)
        }
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
                            for d in self.data {
                                let vm = IngredientViewModel(ingredient: d)
                                vm.delegate = self
                                self.vms.append(vm)
                            }
                            self.ingredientViewModelChanged()
                        }
                    case .failure(let error):
                        break
                }
            })
        }
    }
}
