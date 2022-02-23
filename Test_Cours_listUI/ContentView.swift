//
//  ContentView.swift
//  Test_Cours_listUI
//
//  Created by Vincent Baret on 08/02/2022.
//

import SwiftUI

struct ContentView: View {
    init(){
        let api_config_loadFromFile_result = JSONHelper.loadFomFile(name: "api_config", ext: "json")
        switch api_config_loadFromFile_result {
            case let .success(data):
                let api_config_decode_result: Result<ApiConfig, JSONError> = JSONHelper.decode(data: data)
                switch api_config_decode_result {
                    case let .success(apiConfig):
                        ApiService.config = apiConfig
                        print("[APICONFIG] Configured")
                    case let .failure(error): print("[APICONFIG] Error: \(error)")
                }
            case let .failure(error): print("[APICONFIG] Error: \(error)")
        }
    }
    
    var body: some View {
        TabView{
            IngredientListView()
                .tabItem{
                    Image(systemName: "leaf")	
                    Text("Ingrédients")
                }
            TrackListView()
                .tabItem{
                    Image(systemName: "music.note")
                    Text("Musiques")
                }
        }
    }
}
