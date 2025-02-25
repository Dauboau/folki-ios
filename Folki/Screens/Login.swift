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
    
    @State private var studentRA = ""
    @State private var studentPassword = ""
    
    @State var progress = 0.2
    var loginTip = LoginTip()
    
    var updateSubjects: Binding<Bool> = .constant(false)
    
    var body: some View {
        
        NavigationStack {
            
            ZStack{
                
                DefaultBackground()
                
                VStack{
                    
                    TipView(loginTip, arrowEdge: .bottom)
                        .tint(Color(.primaryPurple))
                    
                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    
                    TextField(getLoginString(university: university)!, text: $studentRA)
                        .textFieldStyle(.roundedBorder)
                        .padding(.bottom,5)
                    
                    SecureField("Senha", text: $studentPassword)
                        .textFieldStyle(.roundedBorder)
                    
                    NavigationLink(destination: LoginHub(studentRA: studentRA, studentPassword: studentPassword, universityId: getUniversityId(university: university)!, updateSubjectsFlag: updateSubjects)) {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.primaryPurple)
                    .controlSize(.regular)
                    .padding(.top,20)
                    
                }
                .padding(.horizontal)
                .frame(maxWidth:CSS.maxWidth)
                
            }
            
        }
        
    }
    
    private func getLoginString(university: String) -> String? {
        
        switch university.uppercased() {
            case "USP":
                return "Número USP"
            case "UFSCAR":
                return "RA"
            default:
                return nil
        }
        
    }
    
    private func getUniversityId(university: String) -> Int? {
        
        switch university.uppercased() {
            case "USP":
                return 1
            case "UFSCAR":
                return 2
            default:
                return nil
        }
        
    }
    
}

#Preview {
    Login(university:"USP")
}
