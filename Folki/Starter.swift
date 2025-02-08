//
//  Starter.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 06/02/25.
//

import SwiftUI

struct Starter: View {
    
    @Environment(\.horizontalSizeClass) var sizeClass
    
    @State private var isShowingPopover = false
    
    var body: some View {
        
        NavigationStack {
            
            ZStack{
                
                GeometryReader { geometry in
                    Image("background")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .frame(
                            maxWidth: geometry.size.width,
                            maxHeight: geometry.size.height
                        )
                }
                
                VStack{
                    
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 60)
                    
                    Spacer()
                    
                    NavigationLink(destination: LoginMenu()) {
                        Text("Entrar")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.primaryPurple)
                    .controlSize(.regular)
                    
                }
                .frame(maxWidth:CSS.maxWidth)
                
                VStack{
                    
                    Text("Bora se formar?")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    
                }
                
            }
            .safeAreaPadding(sizeClass == .regular ? 60 : 30)
            
        }
        .tint(Color("Primary_Purple"))
        
        .onAppear(){
            UserDefaults.standard.set(false, forKey: "isWelcomed")
        }
        
    }
    
}

#Preview {
    Starter()
}
