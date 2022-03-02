//
//  Ingredients.swift
//  Test_Cours_listUI
//
//  Created by m1 on 22/02/2022.
//

import Foundation

class Allergenes: ObservableObject, AllergeneViewModelDelegate {
    @Published var data: [Allergene]
    @Published var vms: [AllergeneViewModel]
    
    func allergeneViewModelChanged() {
        self.objectWillChange.send()
    }
    
    func allergeneDeleted(allergene: Allergene) {
        if let index = self.data.firstIndex(of: allergene){
            self.data.remove(at: index)
            self.vms.remove(at: index)
        }
    }
    
    func remove(atOffsets: IndexSet){
        atOffsets.forEach{ (i) in
            let intent: AllergeneIntent = AllergeneIntent()
            intent.addObserver(vm: self.vms[i])
            intent.intentToDelete()
        }
    }
    
    func remove(atIndex: Int){
        self.data.remove(at: atIndex)
        self.vms.remove(at: atIndex)
    }
    
    func set(allergenes: [Allergene]){
        self.vms = []
        self.data = []
        
        let sortedAllergenes = allergenes.sorted(by: {$0.name.lowercased() < $1.name.lowercased()})
        
        for allergene in sortedAllergenes {
            self.data.append(allergene)
        }
        
        reloadVms()
        allergeneViewModelChanged()
    }
    
    func reloadVms(){
        self.vms = []
        for allergene in self.data {
            let vm = AllergeneViewModel(allergene: allergene)
            vm.delegate = self
            self.vms.append(vm)
        }
        
        self.allergeneViewModelChanged()
    }
    
    init(allergenes: [Allergene]?){
        self.vms = []
        self.data = []
        
        if(allergenes != nil){
            set(allergenes: allergenes!)
        } else {
            AllergeneDAO.getAll(callback: { result in
                DispatchQueue.main.async {
                    switch result {
                        case .success(let all):
                            self.set(allergenes: all)
                        case .failure(_):
                            break
                    }
                }
            })
        }
    }
}
