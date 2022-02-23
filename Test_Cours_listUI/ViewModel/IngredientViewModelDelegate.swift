//
//  IngredientViewModelDelegate.swift
//  Test_Cours_listUI
//
//  Created by m1 on 22/02/2022.
//

import Foundation

protocol IngredientViewModelDelegate {
    func ingredientViewModelChanged()
    func ingredientDeleted(ingredient: Ingredient)
}
