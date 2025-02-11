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
                            
                                ForEach(activities) { activity in
                                    
                                    ActivityCard(activity:activity)
                                    
                                }
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .padding(.vertical, CSS.paddingVerticalList)
                                
                                .swipeActions(edge: .leading,allowsFullSwipe: true){
                                    Button("Adicionar",systemImage: "plus.square"){
                                        print("WIP - Adicionar Nota")
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
                            
                                ForEach(activities) { activity in
                                    
                                    ActivityCard(activity:activity)
                                    
                                }
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .padding(.vertical, CSS.paddingVerticalList)
                                
                                .swipeActions(edge: .leading,allowsFullSwipe: true){
                                    Button("Adicionar",systemImage: "plus.square"){
                                        print("WIP - Adicionar Nota")
                                    }
                                    .tint(Color("Gray_2"))
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
    
    @State var finishDate : String = "segunda-feira"

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
                        Text(String("\(Int(activity.value) * 10)% da Nota - \(finishDate)"))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .onAppear(){
                        let date = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "pt_BR")
                        dateFormatter.dateFormat = "EEEE"
                        finishDate = dateFormatter.string(from: date)
                    }
                }
                
            }
            .padding()
            .foregroundStyle(.white)
            
        }
        
    }
}
