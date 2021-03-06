//
//  ContentView.swift
//  Test_Cours_listUI
//
//  Created by Vincent Baret on 08/02/2022.
//

import SwiftUI	

struct ContentView: View {
    @StateObject var session: Session = Session.getSession()
    @State var email: String = ""
    @State var password: String = ""
    
    init(){
        if let apiConfig = ApiConfig.getApiConfig(){
            ApiService.config = apiConfig
        } else {
            exit(-1)
        }
        
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    var body: some View {
        if session.isLogged(){
            return AnyView(
                TabView{
                    NavigationView {
                        DashboardView()
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .tabItem{
                        VStack{
                            Image(systemName: "homekit")
                            Text("Tableau de bord")
                        }
                    }
                    NavigationView {
                        RecipeListView()
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .tabItem{
                        Image(systemName: "tortoise")
                        Text("Recettes")
                    }
                    NavigationView {
                        RecipeCategoryListView()
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .tabItem{
                        Image(systemName: "tortoise.fill")
                        Text("Catégories de recette")
                    }
                    NavigationView {
                        IngredientListView()
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .tabItem{
                        Image(systemName: "pills")
                        Text("Ingrédients")
                    }
                    NavigationView {
                        IngredientCategoryListView()
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .tabItem{
                        Image(systemName: "pills.fill")
                        Text("Catégories d'ingrédient")
                    }
                    NavigationView {
                        UnitListView()
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .tabItem{
                        Image(systemName: "lineweight")
                        Text("Unités")
                    }
                    NavigationView{
                        AllergeneListView()
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .tabItem{
                        Image(systemName: "allergens")
                        Text("Allergènes")
                    }
                }
            )
        } else {
            return AnyView(
                VStack {
                    TextField("", text: $email, prompt: Text("Adresse électronique"))
                    SecureField("", text: $password, prompt: Text("Mot de passe"))
                    Button("Se connecter"){
                        
                    }.padding()
                }.padding()
            )
        }
    }
}
