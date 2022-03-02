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
                    Text("Home")
                        .tabItem{
                            Image(systemName: "homekit")
                            Text("Home page")
                        }
                    NavigationView {
                        IngredientListView()
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .tabItem{
                        Image(systemName: "leaf")
                        Text("Ingrédients")
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
