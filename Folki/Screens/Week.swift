//
//  Week.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 12/02/25.
//

import SwiftUI

struct Week: View {
    
    let userSubjects : [UserSubject]
    
    var subjectsWeekDays: [(key: Int, value: String)] = []
    
    init(userSubjects: [UserSubject]){
        self.userSubjects = userSubjects
        
        var subjectsWeekDaysDictionary: [Int: String] = [:]

        userSubjects.forEach{
            userSubject in
            userSubject.subjectClass.availableDays.forEach{
                availableDay in
                subjectsWeekDaysDictionary[AvailableDay.Weekday[availableDay.day,default: 8]]
                = AvailableDay.WeekdayStr[availableDay.day,default: "Outros"]
            }
        }
        
        subjectsWeekDays = subjectsWeekDaysDictionary.sorted(by: {$0.key < $1.key})
        
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack{
                
                DefaultBackground()
                
                VStack{
                    
                    HStack{
                        Text("Semana")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.bottom,CSS.paddingBottomText)
                    
                    HStack{
                        Text("Suas aulas aqui ;)")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.bottom,CSS.paddingBottomText)
                    
                    ScrollView{
                            
                        ForEach(subjectsWeekDays, id: \.key) { weekDay in
                            
                            VStack{
                                
                                HStack{
                                    Text("\(weekDay.value)")
                                        .foregroundColor(.white)
                                        .font(.title2)
                                        .bold()
                                    Spacer()
                                }
                                
                                // Disciplinas com aulas neste dia da semana
                                let filteredSubjects = userSubjects.filter { userSubject in
                                    return userSubject.subjectClass.availableDays.contains { availableDay in
                                        AvailableDay.Weekday[availableDay.day] == weekDay.key
                                    }
                                }

                                // Disciplinas com aulas neste dia da semana ordenadas pelo horário de aula
                                let sortedFilteredSubjects = filteredSubjects.sorted { e1, e2 in
                                    let e1Start = e1.subjectClass.getFirstAvailableDayStart(matching: weekDay.key)
                                    let e2Start = e2.subjectClass.getFirstAvailableDayStart(matching: weekDay.key)
                                    return e1Start < e2Start
                                }
                                
                                ForEach(sortedFilteredSubjects){
                                    userSubject in
                                    
                                    let weekDayOnly = userSubject.subjectClass.availableDays.filter {
                                        availableDay in
                                        AvailableDay.Weekday[availableDay.day] == weekDay.key
                                    }
                                    
                                    WeekCard(userSubject:userSubject,nextLessonAvailableDay:weekDayOnly.first)
                                }
                                
                            }
                            .padding()
                            .background(Color("Gray_2"))
                            .cornerRadius(CSS.cornerRadius)
                            .padding(.bottom)
                            
                        }
                        .padding(.vertical, CSS.paddingVerticalScrollView)
                                                
                    }
                    
                }
                .safeAreaPadding()
                
            }
            
        }
    }
    
}

#Preview {
    Week(userSubjects:
        [
            UserSubject(
                id: 39275,
                absences: 0,
                grading: 4.2,
                subjectClass: SubjectClass(
                    id: 21074,
                    availableDays: [
                        AvailableDay(day: "qui", start: "17:00", end: "19:00"),
                        AvailableDay(day: "qua", start: "15:00", end: "17:00")
                    ],
                    subject: Subject(
                        id: 15461,
                        name: "Multimídia",
                        code: "SCC0261",
                        driveItemsNumber: 0
                    )
                )
            ),
            UserSubject(
                id: 392753,
                absences: 1,
                grading: 4.2,
                subjectClass: SubjectClass(
                    id: 21074,
                    availableDays: [
                        AvailableDay(day: "sex", start: "14:00", end: "17:00")
                    ],
                    subject: Subject(
                        id: 15461,
                        name: "Processamento de Linguagem Natural",
                        code: "SCC0261",
                        driveItemsNumber: 0
                    )
                )
            ),
            UserSubject(
                id: 391275,
                absences: 4,
                grading: 4.2,
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
                )
            )
        ])
}

struct WeekCard: View {
    
    let userSubject : UserSubject
    
    let nextLessonAvailableDay : AvailableDay?
    
    init(userSubject: UserSubject,nextLessonAvailableDay : AvailableDay? = nil) {
        self.userSubject = userSubject
        
        if(nextLessonAvailableDay == nil){
            let subjectClass = userSubject.subjectClass
            self.nextLessonAvailableDay = subjectClass.getNextAvailableDay()
        }else{
            self.nextLessonAvailableDay = nextLessonAvailableDay
        }

    }
    
    var body: some View {
        ZStack {
            Color(hex: userSubject.color)
                .cornerRadius(CSS.cornerRadius)
            
            NavigationLink(destination:
                AbsenceList(userSubject:userSubject)
            ){
                VStack {
                    HStack {
                        Text("\(userSubject.subjectClass.subject.name)")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    HStack {
                        Text("\(nextLessonAvailableDay?.start ?? "") - \(nextLessonAvailableDay?.end ?? "")")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    HStack {
                        Text(String("\(userSubject.absences) Faltas Cadastradas"))
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

func dayStart(for userSubject: UserSubject, matching weekDayKey: Int) -> String {
    let matchingDays = userSubject.subjectClass.availableDays.filter { availableDay in
        AvailableDay.Weekday[availableDay.day] == weekDayKey
    }

    return matchingDays.first?.start ?? "23:59"
}
