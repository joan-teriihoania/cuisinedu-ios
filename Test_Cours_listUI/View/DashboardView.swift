//
//  DashboardView.swift
//  Test_Cours_listUI
//
//  Created by m1 on 03/03/2022.
//

import SwiftUI

class Widget: Identifiable {
    static func == (lhs: Widget, rhs: Widget) -> Bool {
        return false
    }
    
    var title: String
    var value: String?
    
    init(title: String, value: String?){
        self.title = title
        self.value = value
    }
}

class Widgets: ObservableObject {
    var data: [Widget] = []
    
    func set(i: Int, value: String?){
        data[i].value = value
        self.objectWillChange.send()
    }
}

struct DashboardView: View {
    var columns = Array(repeating: GridItem(.flexible()), count: 2)
    @ObservedObject var widgets: Widgets
    
    init(){
        self.widgets = Widgets()
        self.widgets.data = [
            Widget(title: "Ingrédients", value: nil),
            Widget(title: "Catégorie d'ingrédients", value: nil),
            Widget(title: "Recettes", value: nil),
            Widget(title: "Catégories de recettes", value: nil),
            Widget(title: "Allergènes", value: nil),
            Widget(title: "Unités", value: nil)
        ]
        reloadWidgets()
    }
    
    func reloadWidgets(){
        for i in 0..<widgets.data.count {
            widgets.set(i: i, value: nil)
        }
        
        IngredientDAO.getAll(callback: { result in
            DispatchQueue.main.async {
                var count = ""
                switch result {
                    case .success(let o):
                        count = String(o.count)
                    case .failure(let error):
                        count = error.description
                }
                self.widgets.set(i: 0, value: count)
            }
        })
        
        IngredientCategoryDAO.getAll(callback: { result in
            DispatchQueue.main.async {
                var count = ""
                switch result {
                    case .success(let o):
                        count = String(o.count)
                    case .failure(let error):
                        count = error.description
                }
                self.widgets.set(i: 1, value: count)
            }
        })
        
        RecipeDAO.getAll(callback: { result in
            DispatchQueue.main.async {
                var count = ""
                switch result {
                    case .success(let o):
                        count = String(o.count)
                    case .failure(let error):
                        count = error.description
                }
                self.widgets.set(i: 2, value: count)
            }
        })
        
        RecipeCategoryDAO.getAll(callback: { result in
            DispatchQueue.main.async {
                var count = ""
                switch result {
                    case .success(let o):
                        count = String(o.count)
                    case .failure(let error):
                        count = error.description
                }
                self.widgets.set(i: 3, value: count)
            }
        })
        
        AllergeneDAO.getAll(callback: { result in
            DispatchQueue.main.async {
                var count = ""
                switch result {
                    case .success(let o):
                        count = String(o.count)
                    case .failure(let error):
                        count = error.description
                }
                self.widgets.set(i: 4, value: count)
            }
        })
        
        UnitDAO.getAll(callback: { result in
            DispatchQueue.main.async {
                var count = ""
                switch result {
                    case .success(let o):
                        count = String(o.count)
                    case .failure(let error):
                        count = error.description
                }
                self.widgets.set(i: 5, value: count)
            }
        })
    }
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns) {
                ForEach(widgets.data, id: \.title){ widget in
                    VStack{
                        Text(widget.title)
                            .font(.title3)
                            .bold()
                        if let value = widget.value {
                            Text(value)
                        } else {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                        }
                    }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(30)
                }
            }
            .padding()
        }.navigationTitle("Tableau de bord")
    }
}
