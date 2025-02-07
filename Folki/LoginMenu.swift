//
//  Login.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 07/02/25.
//

import SwiftUI

struct LoginMenu: View {
    
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
                    .padding(.horizontal, 50)
                    .frame(maxWidth: 400)
                    
                }
                
                VStack{
                    
                    Spacer()
                    
                    NavigationLink(destination: Login(university: selectedUniversity)) {
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
    
}

#Preview {
    LoginMenu()
}
