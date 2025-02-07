//
//  ContentView.swift
//  PetHouse
//
//  Created by Student07 on 21/03/23.
//

import SwiftUI

struct NavigationView: View {
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color("PrimayWhite"))
    }
        
    var body: some View {
             
        TabView{
            
            ContentView()
                .tabItem {
                    Label("Início",systemImage: "house.fill")
                }
            
            ContentView()
                .tabItem {
                    Label("Semana",systemImage: "list.bullet")
                }
            
            ContentView()
                .tabItem {
                    Label("Calendário",systemImage: "calendar")
                        
                }
            
            ContentView()
                .tabItem {
                    Label("Atividades",systemImage: "bookmark.fill")
                }
            
            ContentView()
                .tabItem {
                    Label("Faltas",systemImage: "bag.fill")
                }
            
            ContentView()
                .tabItem {
                    Label("Notas",systemImage: "tray.full.fill")
                }
            
            ContentView()
                .tabItem {
                    Label("Configurações",systemImage: "gearshape")
                }
        
        }
        .tabViewStyle(.automatic)
        .tint(Color("Primary_Purple"))
        
        /*
        .onAppear{
            dados.getUserApi(userId: id)
        }
        */
        
    }

}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView()
    }
}
