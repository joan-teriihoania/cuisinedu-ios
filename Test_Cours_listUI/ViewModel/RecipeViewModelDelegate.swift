//
//  StepViewModelDelegate.swift
//  Test_Cours_listUI
//
//  Created by m1 on 05/03/2022.
//

import Foundation

protocol RecipeViewModelDelegate {
    func recipeViewModelChanged()
    func recipeDeleted(recipe: Recipe)
}
