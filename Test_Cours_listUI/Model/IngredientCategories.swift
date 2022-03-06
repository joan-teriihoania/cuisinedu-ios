//
//  Ingredients.swift
//  Test_Cours_listUI
//
//  Created by m1 on 22/02/2022.
//

import Foundation

class IngredientCategories: ObservableObject, IngredientCategoryViewModelDelegate {
    @Published var data: [IngredientCategory]
    @Published var vms: [IngredientCategoryViewModel]
    
    func ingredientCategoryViewModelChanged() {
        self.objectWillChange.send()
    }
    
    func ingredientCategoryDeleted(ic: IngredientCategory) {
        if let index = self.data.firstIndex(of: ic){
            self.data.remove(at: index)
            self.vms.remove(at: index)
        }
    }
    
    func remove(atOffsets: IndexSet){
        atOffsets.forEach{ (i) in
            let intent = IngredientCategoryIntent()
            intent.addObserver(vm: self.vms[i])
            intent.intentToDelete()
        }
    }
    
    func remove(atIndex: Int){
        self.data.remove(at: atIndex)
        self.vms.remove(at: atIndex)
    }
    
    func set(ics: [IngredientCategory]){
        self.vms = []
        self.data = []
        
        let sortedIcs = ics.sorted(by: {$0.name.lowercased() < $1.name.lowercased()})
        
        for ic in sortedIcs {
            self.data.append(ic)
        }
        
        reloadVms()
    }
    
    func reloadVms(){
        self.vms = []
        for ic in self.data {
            let vm = IngredientCategoryViewModel(ic: ic)
            vm.delegate = self
            self.vms.append(vm)
        }
        
        self.ingredientCategoryViewModelChanged()
    }
    
    init(ics: [IngredientCategory]?){
        self.vms = []
        self.data = []
        
        if(ics != nil){
            set(ics: ics!)
        } else {
            IngredientCategoryDAO.getAll(callback: { result in
                DispatchQueue.main.async {
                    switch result {
                        case .success(let ics):
                            self.set(ics: ics)
                        case .failure(_):
                            break
                    }
                }
            })
        }
    }
}
