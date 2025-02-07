//
//  Login.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 07/02/25.
//

import SwiftUI

struct LoginMenu: View {
    
    @State private var welcomePopover = false
    
    @State private var selectedUniversity: String = "USP"
    
    var body: some View {
        
        NavigationStack {
            
            ZStack{
                
                Color.gray2
                    .ignoresSafeArea()
                
                VStack{
                    
                    Text("Qual sua Universidade?")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    
                    Picker("Select University",
                        selection: $selectedUniversity)
                    {
                        Text("USP").tag("USP")
                        Text("UFSCAR").tag("UFSCAR")
                    }
                    .pickerStyle(.segmented)
                    .safeAreaPadding(.horizontal,30)
                    
                    NavigationLink(destination: Login(university: selectedUniversity)) {
                        Text("Entrar")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.primaryPurple)
                    .controlSize(.regular)
                    .padding(.top,20)
                    .safeAreaPadding(.horizontal,30)
                    
                    .sheet(isPresented: $welcomePopover){
                        TabView{
                            
                            WelcomeView(title: "Bem-vindo ao Folki!", icon: "👋", description: "O Folki é um aplicativo que te ajuda a organizar sua vida acadêmica. Ele é uma iniciativa Livre do Codelab Sanca. Com ele você pode ver suas atividades, feriados, notas e muito mais!")

                            WelcomeView(title: "Atividades", icon: "📚", description: "Aqui você pode ver as atividades que você tem para fazer, e também as que você já fez. Quando qualquer estudante da sua turma adiciona uma atividade, ela aparece aqui!")

                            WelcomeView(title: "Notas", icon: "📊", description: "Nessa seção você pode ver as notas das atividades que você já fez. Assim você pode saber como está indo na disciplina!")

                            WelcomeView(title: "Aulas", icon: "📅", description: "Aqui você pode ver as aulas que você tem hoje, e também as aulas que você tem durante a semana. Assim você pode se organizar melhor!")

                            WelcomeView(title: "Faltas", icon: "🚫", description: "Nessa seção você pode ver quantas faltas você tem em cada disciplina. Assim você pode se programar para não faltar nas aulas!")

                            WelcomeView(title: "Calendário", icon: "🗓️", description: "No calendário você pode ver as datas importantes da sua turma, como provas, trabalhos e feriados. Assim você pode se programar melhor!")

                            WelcomeView(title: "Compartilhe!", icon: "📲", description: "Compartilhe o Folki com seus amigos e ajude eles a se organizarem melhor também!")
                            
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .presentationDetents([.large])
                        .background(Color.clear)
                        .ignoresSafeArea()
                        .onDisappear(){
                            UserDefaults.standard.set(true, forKey: "isWelcomed")
                        }
                    }
                    
                    .onAppear {
                        if UserDefaults.standard.bool(forKey: "isWelcomed") == false {
                            welcomePopover = true
                        }
                    }
                    
                }
                .frame(maxWidth:500)
                
            }
            .navigationBarBackButtonHidden(true)
            
        }
        
    }
    
}

#Preview {
    LoginMenu()
}

struct WelcomeView: View {
    
    var title:String
    var icon:String
    var description:String
    
    var body: some View {
        
        ZStack{
            
            Color.gray2
                .ignoresSafeArea()
            
            VStack{
                
                Text(title)
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom)
                
                Text(icon)
                    .padding(.bottom)
                    .font(.system(size: 80))
                
                Text(description)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                
            }
            .safeAreaPadding(.horizontal,30)
            .foregroundColor(Color.white)
            
        }
    }
    
}
