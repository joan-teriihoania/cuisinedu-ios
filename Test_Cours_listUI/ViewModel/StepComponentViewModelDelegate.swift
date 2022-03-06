//
//  StepComponentViewModelDelegate.swift
//  Test_Cours_listUI
//
//  Created by m1 on 05/03/2022.
//

import Foundation

protocol StepComponentViewModelDelegate {
    func stepComponentViewModelChanged()
    func stepComponentDeleted(component: StepComponent)
}
