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
    
    @State var progress = 0.2
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
                    
                    NavigationLink(destination: Login(university:"A")) {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.primaryPurple)
                    .controlSize(.regular)
                    .padding(.top,20)
                    
                    
                }
                .padding(.horizontal)
                .frame(maxWidth:500)
                
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

/*
 ProgressView(value: progress)
     .progressViewStyle(CircularProgressViewStyle())
     .scaleEffect(3, anchor: .center)
 */
