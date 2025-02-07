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
            
            LoginMenu()
                .tabItem {
                    Label("Início",systemImage: "house.fill")
                }
            
            LoginMenu()
                .tabItem {
                    Label("Semana",systemImage: "list.bullet")
                }
            
            LoginMenu()
                .tabItem {
                    Label("Calendário",systemImage: "calendar")
                        
                }
            
            LoginMenu()
                .tabItem {
                    Label("Atividades",systemImage: "bookmark.fill")
                }
            
            LoginMenu()
                .tabItem {
                    Label("Faltas",systemImage: "bag.fill")
                }
            
            LoginMenu()
                .tabItem {
                    Label("Notas",systemImage: "tray.full.fill")
                }
            
            LoginMenu()
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
