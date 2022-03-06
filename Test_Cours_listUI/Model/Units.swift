//
//  Ingredients.swift
//  Test_Cours_listUI
//
//  Created by m1 on 22/02/2022.
//

import Foundation

class Units: ObservableObject, UnitViewModelDelegate {
    @Published var data: [Unit]
    @Published var vms: [UnitViewModel]
    
    func unitViewModelChanged() {
        self.objectWillChange.send()
    }
    
    func unitDeleted(unit: Unit) {
        if let index = self.data.firstIndex(of: unit){
            self.data.remove(at: index)
            self.vms.remove(at: index)
        }
    }
    
    func remove(atOffsets: IndexSet){
        atOffsets.forEach{ (i) in
            let intent = UnitIntent()
            intent.addObserver(vm: self.vms[i])
            intent.intentToDelete()
        }
    }
    
    func remove(atIndex: Int){
        self.data.remove(at: atIndex)
        self.vms.remove(at: atIndex)
    }
    
    func set(units: [Unit]){
        self.vms = []
        self.data = []
        
        let sorted = units.sorted(by: {$0.name.lowercased() < $1.name.lowercased()})
        
        for unit in sorted {
            self.data.append(unit)
        }
        
        reloadVms()
    }
    
    func reloadVms(){
        self.vms = []
        for unit in self.data {
            let vm = UnitViewModel(unit: unit)
            vm.delegate = self
            self.vms.append(vm)
        }
        
        self.unitViewModelChanged()
    }
    
    init(units: [Unit]?){
        self.vms = []
        self.data = []
        
        if(units != nil){
            set(units: units!)
        } else {
            UnitDAO.getAll(callback: { result in
                DispatchQueue.main.async {
                    switch result {
                        case .success(let units):
                            self.set(units: units)
                        case .failure(_):
                            break
                    }
                }
            })
        }
    }
}
