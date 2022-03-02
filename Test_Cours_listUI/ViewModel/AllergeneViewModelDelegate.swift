//
//  AllergeneViewModelDelegate.swift
//  Test_Cours_listUI
//
//  Created by m1 on 28/02/2022.
//

import Foundation

protocol AllergeneViewModelDelegate {
    func allergeneViewModelChanged()
    func allergeneDeleted(allergene: Allergene)
}
