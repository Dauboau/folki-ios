//
//  Login.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 07/02/25.
//

import SwiftUI
import TipKit

struct LoginTip: Tip {
    
    var title: Text {
        Text("Insira seu RA e sua senha única para a integração com o Folki")
    }

    var message: Text? {
        Text("Não salvamos suas credenciais")
    }

    var image: Image? {
        Image(systemName: "info.square")
    }
    
}

struct Login: View {
    
    @State var university : String
    
    @State private var showInfo = false
    
    @State private var user = ""
    @State private var password = ""
    
    var loginTip = LoginTip()
    
    var body: some View {
        
        NavigationStack {
            
            ZStack{
                
                Color.gray2
                    .ignoresSafeArea()
                
                VStack{
                    
                    TipView(loginTip, arrowEdge: .bottom)
                        .tint(Color(.primaryPurple))
                    
                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    
                    TextField(getLoginString(university: university), text: $user)
                        .textFieldStyle(.roundedBorder)
                        .padding(.bottom,5)
                    
                    SecureField("Senha", text: $password)
                        .textFieldStyle(.roundedBorder)
                    
                }
                .padding(.horizontal)
                
                VStack{
                    
                    Spacer()
                    
                    NavigationLink(destination: Login(university:"A")) {
                        Text("Login")
                            .padding(.horizontal, 100)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.primaryPurple)
                    .controlSize(.regular)
                    
                }
                
            }
            
        }
        
    }
    
    private func getLoginString(university: String) -> String {
        
        switch university {
            case "USP":
                return "Número USP"
            case "UFSCAR":
                return "RA"
            default:
                return "NULL"
        }
        
    }
    
}

#Preview {
    Login(university:"USP")
}
