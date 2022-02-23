//
//  IngredientListView.swift
//  Test_Cours_listUI
//
//  Created by m1 on 17/02/2022.
//

import SwiftUI

struct IngredientListView: View {
    @StateObject var data: Ingredients = Ingredients(retrieveFromApi: true)
    @State var searchTerms: String = ""
    var cols: [GridItem] = Array(repeating: .init(.flexible()), count: 1)
    
    var body: some View {
        NavigationView {
            VStack{
                TextField("", text: $searchTerms, prompt: Text("Recherche"))
                    .padding()
                
                List {
                    ForEach(data.vms, id: \.ingredient.id) {
                        vm in
                        if(
                            vm.ingredient.name.lowercased().contains(searchTerms.lowercased()) ||
                            vm.ingredient.unit.name.lowercased().contains(searchTerms.lowercased()) ||
                            vm.ingredient.category.name.lowercased().contains(searchTerms.lowercased()) ||
                            searchTerms.count == 0
                        ){
                            NavigationLink(destination: IngredientView(vm: vm)){
                                VStack(alignment: .leading) {
                                    Text(vm.ingredient.name)
                                }
                            }
                        }
                    }
                    .onDelete{ indexSet in
                        data.remove(atOffsets: indexSet)
                    }
                }
                EditButton()
            }
            .navigationTitle("Liste d'ingrédients")
            .toolbar(){
                Button("Créer"){
                    
                }
            }
        }
    }
}
