//
//  Recipes.swift
//  Test_Cours_listUI
//
//  Created by m1 on 22/02/2022.
//

import Foundation

class RecipeCategories: ObservableObject, RecipeCategoryViewModelDelegate {
    @Published var data: [RecipeCategory]
    @Published var vms: [RecipeCategoryViewModel]
    
    func recipeCategoryViewModelChanged() {
        self.objectWillChange.send()
    }
    
    func recipeCategoryDeleted(rc: RecipeCategory) {
        if let index = self.data.firstIndex(of: rc){
            self.data.remove(at: index)
            self.vms.remove(at: index)
        }
    }
    
    func remove(atOffsets: IndexSet){
        atOffsets.forEach{ (i) in
            let intent = RecipeCategoryIntent()
            intent.addObserver(vm: self.vms[i])
            intent.intentToDelete()
        }
    }
    
    func remove(atIndex: Int){
        self.data.remove(at: atIndex)
        self.vms.remove(at: atIndex)
    }
    
    func set(rcs: [RecipeCategory]){
        self.vms = []
        self.data = []
        
        let sortedIcs = rcs.sorted(by: {$0.name.lowercased() < $1.name.lowercased()})
        
        for ic in sortedIcs {
            self.data.append(ic)
        }
        
        reloadVms()
    }
    
    func reloadVms(){
        self.vms = []
        for rc in self.data {
            let vm = RecipeCategoryViewModel(rc: rc)
            vm.delegate = self
            self.vms.append(vm)
        }
        
        self.recipeCategoryViewModelChanged()
    }
    
    init(rcs: [RecipeCategory]?){
        self.vms = []
        self.data = []
        
        if(rcs != nil){
            set(rcs: rcs!)
        } else {
            RecipeCategoryDAO.getAll(callback: { result in
                DispatchQueue.main.async {
                    switch result {
                        case .success(let rcs):
                            self.set(rcs: rcs)
                        case .failure(_):
                            break
                    }
                }
            })
        }
    }
}
