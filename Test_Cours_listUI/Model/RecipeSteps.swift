//
//  Ingredients.swift
//  Test_Cours_listUI
//
//  Created by m1 on 22/02/2022.
//

import Foundation

class RecipeSteps: ObservableObject, StepViewModelDelegate {
    func stepViewModelChanged() {
        self.objectWillChange.send()
    }
    
    func getIndexOf(step: Step) -> Int?{
        var index: Int?
        
        for i in 0..<self.data.count {
            let d = self.data[i]
            if d.step.equal(step: step){
                index = i
                break
            }
        }
        
        return index
    }
    
    func stepDeleted(step: Step) {
        if let index = getIndexOf(step: step) {
            self.data.remove(at: index)
            self.vms.remove(at: index)
        }
    }
    
    @Published var data: [RecipeStepQuantity]
    @Published var vms: [StepViewModel]
    var vm: RecipeViewModel!
    
    func remove(atOffsets: IndexSet){
        atOffsets.forEach{ (i) in
            /* let intent: AllergeneIntent = AllergeneIntent()
            intent.addObserver(vm: self.vms[i])
            intent.intentToDelete() */
            
            let intent = RecipeIntent()
            intent.addObserver(vm: self.vm)
            intent.intentToRemoveStep(step: self.data[i].step)
        }
    }
    
    func remove(atIndex: Int){
        self.data.remove(at: atIndex)
        self.vms.remove(at: atIndex)
        stepViewModelChanged()
    }
    
    func set(steps: [RecipeStepQuantity]){
        self.vms = []
        self.data = []
                
        for component in steps {
            self.data.append(component)
        }
        
        reloadVms()
        stepViewModelChanged()
    }
    
    func reloadVms(){
        self.vms = []
        for component in self.data {
            let vm = StepViewModel(step: component.step)
            vm.delegate = self
            self.vms.append(vm)
        }
        
        self.stepViewModelChanged()
    }
    
    init(steps: [RecipeStepQuantity]){
        self.vms = []
        self.data = []
        set(steps: steps)
    }
}
