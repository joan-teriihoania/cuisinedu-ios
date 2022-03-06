//
//  StepComponents.swift
//  Test_Cours_listUI
//
//  Created by m1 on 04/03/2022.
//

import Foundation

class StepComponents: ObservableObject, StepComponentViewModelDelegate {
    @Published var data: [StepComponent]
    @Published var vms: [StepComponentViewModel]
    
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
            let intent = StepComponentIntent()
            intent.addObserver(vm: self.vms[i])
            intent.intentToDelete()
        }
    }
    
    func remove(atIndex: Int){
        self.data.remove(at: atIndex)
        self.vms.remove(at: atIndex)
    }
    
    func set(components: [StepComponent]){
        self.vms = []
        self.data = []
        
        for component in components {
            self.data.append(component)
        }
        
        reloadVms()
    }
    
    func reloadVms(){
        self.vms = []
        for step in self.data {
            let vm = StepComponentViewModel(component: step)
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
                        case .success(let components):
                            self.set(components: components)
                        case .failure(_):
                            break
                    }
                }
            })
        }
    }
}
