//
//  Activities.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 10/02/25.
//

import SwiftUI

struct Activities: View {
    
    let activities : [Activity]
    
    @State var expanded1 : Bool = true
    @State var expanded2 : Bool = true
    
    var body: some View {
        
        NavigationStack {
            
            ZStack{
                
                DefaultBackground()
                
                VStack{
                    
                    HStack{
                        Text("Atividades")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.bottom,CSS.paddingBottomText)
                    
                    HStack{
                        Text("Atividades Restantes!")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.bottom,CSS.paddingBottomText)
                    
                    List{
                        
                        Section(
                            isExpanded: $expanded1,
                            content:{
                            
                                ForEach(activities.filter { activity in
                                    activity.isLate() == true
                                }){ activity in
                                    
                                    ActivityCard(activity:activity)
                                    
                                }
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .padding(.vertical, CSS.paddingVerticalList)
                                
                                .swipeActions(edge: .leading,allowsFullSwipe: true){
                                    Button("Editar",systemImage: "plus.square"){
                                        print("WIP - Editar Atividade")
                                    }
                                    .tint(Color("Gray_2"))
                                }
                            
                            },
                            header: {
                                Text("Atrasadas")
                                    .foregroundStyle(.white)
                            }
                        )
                        
                        Section(
                            isExpanded: $expanded2,
                            content:{
                            
                                ForEach(activities.filter { activity in
                                    activity.isLate() == false
                                }) { activity in
                                    
                                    ActivityCard(activity:activity)
                                    
                                }
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .padding(.vertical, CSS.paddingVerticalList)
                                
                                .swipeActions(edge: .leading,allowsFullSwipe: true){
                                    Button("Concluir",systemImage: "checkmark.square.fill"){
                                        print("WIP - Concluir Atividade")
                                    }
                                    .tint(Color("Primary_Green"))
                                }
                                
                                .swipeActions(edge: .trailing,allowsFullSwipe: false){
                                    Button("Excluir",systemImage: "minus.square.fill"){
                                        print("WIP - Excluir Atividade")
                                    }
                                    .tint(Color("Primary_Red"))
                                    
                                    Button("Editar",systemImage: "square.and.pencil"){
                                        print("WIP - Editar Atividade")
                                    }
                                    .tint(Color("Primary_Orange"))
                                }
                                
                            },
                            header: {
                                Text("Ainda no prazo")
                                    .foregroundStyle(.white)
                            }
                        )
                                                
                    }
                    .tint(Color.white)
                    .padding(.horizontal,-15)
                    .headerProminence(.increased)
                    .listStyle(.sidebar)
                    .scrollContentBackground(.hidden)
                    .contentMargins(.vertical, 0)
                    
                    .onDisappear(){
                        print("Delete Activity Now")
                    }
                    
                }
                .safeAreaPadding()
                
            }
            
        }
        
    }
    
}

#Preview {
    Activities(activities: [
        Activity(id: 7757, name: "Lição de Multimídia", activityDescription: "", value: 3, subjectClassId: 21074, finishDate: "2025-02-11T15:00:00.000Z", type: "ACTIVITY", subjectClass: SubjectClass(
            id: 21074,
            availableDays: [
                AvailableDay(day: "qua", start: "14:00", end: "17:00")
            ],
            subject: Subject(
                id: 15461,
                name: "Teste e Inspeção de Software",
                code: "SCC0261",
                driveItemsNumber: 0
            )
        ))
    ])
}

fileprivate struct ActivityCard: View {
    
    let activity : Activity

    var body: some View {
        
        ZStack {
            
            Color.primaryPurple
                .cornerRadius(CSS.cornerRadius)

            NavigationLink(destination:
                EmptyView()
            ){
                VStack {
                    HStack {
                        Text("\(activity.name)")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                    }
                    if(activity.subjectClass != nil){
                        HStack {
                            Text("\(activity.subjectClass?.subject.name ?? "")")
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                    HStack {
                        Text(String("\(Int(activity.value) * 10)% da Nota - \(DateFormatter.localizedString(from: activity.getDeadlineDate()!, dateStyle: .short, timeStyle: .none))"))
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
                
            }
            .padding()
            .foregroundStyle(.white)
            
        }
        
    }
}
