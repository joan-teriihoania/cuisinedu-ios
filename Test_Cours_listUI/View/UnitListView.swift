//
//  IngredientListView.swift
//  Test_Cours_listUI
//
//  Created by m1 on 17/02/2022.
//

import SwiftUI

struct UnitListView: View {
    @StateObject var data = Units(units: nil)
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
                ForEach(data.vms, id: \.unit.id) {
                    vm in
                    if(
                        vm.unit.name.lowercased().contains(searchTerms.lowercased()) ||
                        searchTerms.count == 0
                    ){
                        NavigationLink(destination: UnitView(vm: vm)){
                            VStack(alignment: .leading) {
                                Text(vm.unit.name)
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
        .navigationTitle("Liste d'unités")
        .toolbar(){
            HStack {
                EditButton()
                Button("Créer"){
                    
                }
            }
        }.alert("\(message)", isPresented: $showMessage){
            Button("Ok", role: .cancel){
                showMessage = false
            }
        }
    }
}
