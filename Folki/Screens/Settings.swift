//
//  Settings.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 10/02/25.
//

import SwiftUI
import SafariServices
import SwiftData

struct Settings: View {
    
    @Environment(\.modelContext) var context
    
    var body: some View {
        
        NavigationStack {
            
            ZStack{
                
                DefaultBackground()
                
                VStack{
                    
                    HStack{
                        Text("Configurações")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.bottom,CSS.paddingBottomText)
                    
                    HStack{
                        Text("Configurações do Folki")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.bottom,CSS.paddingBottomText)
                    
                    VStack {
                        
                        SettingButton(buttonText: "Contato", action: {
                            print("Contato")
                        })
                        
                        SettingButton(buttonText: "Atualizar Disciplinas", action: {
                            print("Atualizar Disciplinas")
                        })
                        
                        SettingButton(buttonText: "Open Source", action: {
                            if let url = URL(string: "https://github.com/Dauboau/folki-ios.git") {
                                let safariVC = SFSafariViewController(url: url)
                                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                   let rootViewController = windowScene.windows.first?.rootViewController {
                                    rootViewController.present(safariVC, animated: true, completion: nil)
                                }
                            }
                        })
                        
                        SettingButton(buttonText: "Compartilhar App ;)", action: {
                            if let url = URL(string: "https://folki.com.br") {
                                let safariVC = SFSafariViewController(url: url)
                                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                   let rootViewController = windowScene.windows.first?.rootViewController {
                                    rootViewController.present(safariVC, animated: true, completion: nil)
                                }
                            }
                        })
                        
                        /**
                         Deletes all stored user data resetting the app to its initial state
                         */
                        SettingButton(buttonText: "Sair", action: {
                            try! context.delete(model: UserSubject.self)
                            try! context.delete(model: Activity.self)
                            // Deleting the user should be the last action
                            try! context.delete(model: User.self)
                        })
                        
                    }
                    
                    Spacer()
     
                }
                .safeAreaPadding()
                
            }
            
        }
        
    }
}

#Preview {
    Settings()
        .modelContainer(for:User.self, inMemory: true)
}

struct SettingButton: View {
    
    let buttonText: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text("\(buttonText)")
                .bold()
                .frame(maxWidth: .infinity)
                .padding(6)
        }
        .padding(.vertical,3)
        .buttonStyle(.borderedProminent)
        .tint(Color("Gray_2"))
        .controlSize(.regular)
    }
}
