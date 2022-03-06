//
//  StepComponents.swift
//  Test_Cours_listUI
//
//  Created by m1 on 04/03/2022.
//

import Foundation

class Recipes: ObservableObject, RecipeViewModelDelegate {
    @Published var data: [Recipe]
    @Published var vms: [RecipeViewModel]
    
    func recipeViewModelChanged() {
        self.objectWillChange.send()
    }
    
    func recipeDeleted(recipe: Recipe) {
        if let index = self.data.firstIndex(of: recipe){
            self.data.remove(at: index)
            self.vms.remove(at: index)
        }
    }
    
    func remove(atOffsets: IndexSet){
        atOffsets.forEach{ (i) in
            let intent = RecipeIntent()
            intent.addObserver(vm: self.vms[i])
            intent.intentToDelete()
        }
    }
    
    func remove(atIndex: Int){
        self.data.remove(at: atIndex)
        self.vms.remove(at: atIndex)
    }
    
    func set(recipes: [Recipe]){
        self.vms = []
        self.data = []
        
        for recipe in recipes {
            self.data.append(recipe)
        }
        
        reloadVms()
    }
    
    func reloadVms(){
        self.vms = []
        for recipe in self.data {
            let vm = RecipeViewModel(recipe: recipe)
            vm.delegate = self
            self.vms.append(vm)
        }
        
        self.recipeViewModelChanged()
    }
    
    init(recipes: [Recipe]?){
        self.vms = []
        self.data = []
        
        if(recipes != nil){
            set(recipes: recipes!)
        } else {
            RecipeDAO.getAll(callback: { result in
                DispatchQueue.main.async {
                    switch result {
                        case .success(let recipes):
                            self.set(recipes: recipes)
                        case .failure(_):
                            break
                    }
                }
            })
        }
    }
}
