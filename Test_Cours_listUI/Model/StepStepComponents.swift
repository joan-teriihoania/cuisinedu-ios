//
//  Ingredients.swift
//  Test_Cours_listUI
//
//  Created by m1 on 22/02/2022.
//

import Foundation

class StepStepComponents: ObservableObject, StepComponentViewModelDelegate {
    @Published var data: [StepComponent]
    @Published var vms: [StepComponentViewModel]
    var vm: StepViewModel!
    
    func stepComponentViewModelChanged() {
        self.objectWillChange.send()
    }
    
    func stepComponentDeleted(component: StepComponent) {
        if let index = self.data.firstIndex(of: component){
            self.data.remove(at: index)
            self.vms.remove(at: index)
        }
    }
    
    func remove(atOffsets: IndexSet){
        atOffsets.forEach{ (i) in
            /* let intent: AllergeneIntent = AllergeneIntent()
            intent.addObserver(vm: self.vms[i])
            intent.intentToDelete() */
            
            let intent = StepIntent()
            intent.addObserver(vm: self.vm)
            intent.intentToRemoveComponent(component: self.data[i])
        }
    }
    
    func remove(atIndex: Int){
        self.data.remove(at: atIndex)
        self.vms.remove(at: atIndex)
        stepComponentViewModelChanged()
    }
    
    func set(components: [StepComponent]){
        self.vms = []
        self.data = []
                
        for component in components {
            self.data.append(component)
        }
        
        reloadVms()
        stepComponentViewModelChanged()
    }
    
    func reloadVms(){
        self.vms = []
        for component in self.data {
            let vm = StepComponentViewModel(component: component)
            vm.delegate = self
            self.vms.append(vm)
        }
        
        self.stepComponentViewModelChanged()
    }
    
    init(components: [StepComponent]?){
        self.vms = []
        self.data = []
        
        if(components != nil){
            set(components: components!)
        } else {
            StepComponentDAO.getAll(callback: { result in
                DispatchQueue.main.async {
                    switch result {
                        case .success(let all):
                            self.set(components: all)
                        case .failure(_):
                            break
                    }
                }
            })
        }
    }
}
