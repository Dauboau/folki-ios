//
//  Activities.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 10/02/25.
//

import SwiftUI

struct Activities: View {
    
    let activities : [Activity]
    
    @State var expandedLate : Bool = true
    @State var expandedDue : Bool = true
    @State var expandedChecked : Bool = true
    @State var expandedDeleted : Bool = true
    
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
                        Text("\(activities.count{$0.checked != true && $0.deletedAt == nil && $0.isLate() == false}) Atividade(s) Restante(s)!")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.bottom,CSS.paddingBottomText)
                    
                    List(){
                        
                        Section(
                            isExpanded: $expandedLate,
                            content:{
                            
                                ForEach(activities.filter { activity in
                                    return (activity.isLate() == true && activity.checked == false && activity.deletedAt == nil)
                                },id: \.self){ activity in
                                    
                                    ActivityCard(activity:activity,backgroundDefault:false)
                                        .swipeActions(edge: .leading,allowsFullSwipe: true){
                                            SwipeCheck(activity: activity)
                                        }
                                        .swipeActions(edge: .trailing,allowsFullSwipe: false){
                                            SwipeDelete(activity: activity)
                                            SwipeEdit(activity: activity)
                                        }
                                    
                                }
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .padding(.vertical, CSS.paddingVerticalList)
                            
                            },
                            header: {
                                Text("Atrasadas")
                                    .foregroundStyle(.white)
                            }
                        )
                        
                        Section(
                            isExpanded: $expandedDue,
                            content:{
                            
                                ForEach(activities.filter { activity in
                                    return (activity.isLate() == false && activity.checked == false && activity.deletedAt == nil)
                                }) { activity in
                                    
                                    ActivityCard(activity:activity,backgroundDefault:false)
                                        .swipeActions(edge: .leading,allowsFullSwipe: true){
                                            SwipeCheck(activity: activity)
                                        }
                                        .swipeActions(edge: .trailing,allowsFullSwipe: false){
                                            SwipeDelete(activity: activity)
                                            SwipeEdit(activity: activity)
                                        }
                                    
                                }
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .padding(.vertical, CSS.paddingVerticalList)
                                
                            },
                            header: {
                                Text("Ainda no prazo")
                                    .foregroundStyle(.white)
                            }
                        )
                        
                        Section(
                            isExpanded: $expandedChecked,
                            content:{
                            
                                ForEach(activities.filter { activity in
                                    return (activity.checked == true && activity.deletedAt == nil)
                                }) { activity in
                                    
                                    ActivityCard(activity:activity,backgroundDefault:false)
                                        .swipeActions(edge: .leading,allowsFullSwipe: true){
                                            SwipeUncheck(activity: activity)
                                        }
                                        .swipeActions(edge: .trailing,allowsFullSwipe: false){
                                            SwipeDelete(activity: activity)
                                            SwipeEdit(activity: activity)
                                        }
                                    
                                }
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .padding(.vertical, CSS.paddingVerticalList)
                                
                            },
                            header: {
                                Text("Concluídas")
                                    .foregroundStyle(.white)
                            }
                        )
                        
                        Section(
                            isExpanded: $expandedDeleted,
                            content:{
                            
                                ForEach(activities.filter { activity in
                                    return (activity.deletedAt != nil)
                                }) { activity in
                                    
                                    ActivityCard(activity:activity,backgroundDefault:false)
                                        .swipeActions(edge: .leading,allowsFullSwipe: true){
                                            SwipeRestore(activity: activity)
                                        }
                                        .swipeActions(edge: .trailing,allowsFullSwipe: true){
                                            SwipeRestore(activity: activity)
                                        }
                                    
                                }
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .padding(.vertical, CSS.paddingVerticalList)
                                
                            },
                            header: {
                                Text("Deletadas")
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
        Activity(id: 7757, name: "Lição de Multimídia", activityDescription: "", value: 3, subjectClassId: 21074, finishDate: "2025-02-12T15:00:00.000Z", type: "ACTIVITY",
            subjectClass: SubjectClass(
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
            ),
        checked:false
        )
    ])
}

struct ActivityCard: View {
    
    let activity : Activity
    
    let backgroundDefault:Bool
    
    init(activity: Activity, backgroundDefault: Bool = true) {
        self.activity = activity
        self.backgroundDefault = backgroundDefault
    }

    var body: some View {
        
        ZStack {
            
            activity.getColor()
                .cornerRadius(CSS.cornerRadius)

            NavigationLink(destination:
                            ActivityList(activity: activity,backgroundDefault:backgroundDefault)
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

fileprivate struct SwipeCheck: View {
    
    let activity : Activity
    
    var body: some View {
        
        Button("Concluir",systemImage: "checkmark.square.fill"){
            print("WIP - Concluir Atividade")
            
            withAnimation(.snappy) {
                activity.checked = true
            }
        }
        .tint(Color("Primary_Green"))
        
    }
    
}

fileprivate struct SwipeEdit: View {
    
    let activity : Activity
    
    var body: some View {
        
        Button("Editar",systemImage: "square.and.pencil"){
            print("WIP - Editar Atividade")
        }
        .tint(Color("Gray_2"))
        
    }
    
}

fileprivate struct SwipeDelete: View {
    
    let activity : Activity
    
    var body: some View {
        
        Button("Excluir",systemImage: "minus.square.fill"){
            print("WIP - Excluir Atividade")
            
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

            let currentDate = Date()
            let currentDateISO = isoFormatter.string(from: currentDate)
            
            withAnimation(.snappy) {
                activity.deletedAt = currentDateISO
            }
            
        }
        .tint(Color("Primary_Red"))
        
    }
    
}

fileprivate struct SwipeRestore: View {
    
    let activity : Activity
    
    var body: some View {
        
        Button("Restaurar",systemImage: "arrow.circlepath"){
            print("WIP - Restaurar Atividade")
            
            withAnimation(.snappy) {
                activity.deletedAt = nil
            }
            
        }
        .tint(Color("Gray_2"))
        
    }
    
}

fileprivate struct SwipeUncheck: View {
    
    let activity : Activity
    
    var body: some View {
        
        Button("Desfazer",systemImage: "arrow.uturn.backward.square.fill"){
            print("WIP - Desfazer Conclusão")
            
            withAnimation(.snappy) {
                activity.checked = false
            }
        }
        .tint(Color("Gray_2"))
        
    }
    
}
