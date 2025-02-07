//
//  Starter.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 06/02/25.
//

import SwiftUI

struct Starter: View {
    
    @Environment(\.horizontalSizeClass) var sizeClass
    
    var body: some View {
        
        NavigationStack {
            
            ZStack{
                
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack{
                    
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 60)
                        .padding(.top, 10)
                    
                    Spacer()
                    
                    NavigationLink(destination: LoginMenu()) {
                        Text("Entrar")
                            .padding(.horizontal,100)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.primaryPurple)
                    .controlSize(.regular)
                    
                }
                
                VStack{
                    
                    Text("Bora se formar?")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    
                }
                
            }
            .safeAreaPadding(sizeClass == .regular ? 60 : 0)
            
        }
        .tint(Color("Primary_Purple"))
        
    }
    
}

#Preview {
    Starter()
}
