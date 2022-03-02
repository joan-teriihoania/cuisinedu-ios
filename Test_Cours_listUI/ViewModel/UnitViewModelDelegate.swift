//
//  UnitViewModelDelegate.swift
//  Test_Cours_listUI
//
//  Created by m1 on 22/02/2022.
//

import Foundation

protocol UnitViewModelDelegate {
    func unitViewModelChanged()
    func unitDeleted(unit: Unit)
}
