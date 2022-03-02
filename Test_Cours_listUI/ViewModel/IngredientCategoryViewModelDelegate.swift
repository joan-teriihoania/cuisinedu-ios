//
//  IngredientCategoryViewModelDelegate.swift
//  Test_Cours_listUI
//
//  Created by m1 on 22/02/2022.
//

import Foundation

protocol IngredientCategoryViewModelDelegate {
    func ingredientCategoryViewModelChanged()
    func ingredientCategoryDeleted(ic: IngredientCategory)
}
