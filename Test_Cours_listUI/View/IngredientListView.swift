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
    @State var showMessage: Bool = false
    @State var message: String = ""
    var cols: [GridItem] = Array(repeating: .init(.flexible()), count: 1)
    
    var body: some View {
        VStack{
            TextField("", text: $searchTerms, prompt: Text("Recherche"))
                .padding()
            Divider()
            List {
                ForEach(data.vms, id: \.ingredient.id) {
                    vm in
                    if(
                        vm.ingredient.name.lowercased().contains(searchTerms.lowercased()) ||
                        vm.ingredient.unit.name.lowercased().contains(searchTerms.lowercased()) ||
                        vm.ingredient.category.name.lowercased().contains(searchTerms.lowercased()) ||
                        vm.ingredient.allergenes.filter({ allergene in
                            return allergene.name.lowercased().contains(searchTerms.lowercased())
                        }).count > 0 ||
                        searchTerms.count == 0
                    ){
                        NavigationLink(destination: IngredientView(vm: vm)){
                            VStack(alignment: .leading) {
                                Text(vm.ingredient.name)
                            }
                        }.onChange(of: vm.error, perform: { error in
                            switch error {
                                case .DELETE(let reason):
                                    message = reason
                                    showMessage = true
                                default:
                                    break
                            }
                        })
                    }
                }.onDelete{ indexSet in
                    data.remove(atOffsets: indexSet)
                }.onAppear{
                    data.reloadVms()
                }
            }
        }
        .navigationTitle("Liste d'ingr??dients")
        .toolbar(){
            HStack {
                EditButton()
                Button("Cr??er"){
                    
                }
            }
        }.alert("\(message)", isPresented: $showMessage){
            Button("Ok", role: .cancel){
                showMessage = false
            }
        }
    }
}
