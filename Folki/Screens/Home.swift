//
//  Home.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 07/02/25.
//

import SwiftUI

struct Home: View {
    
    // Parameters
    let user : User
    let activities: [Activity]
    let userSubjects: [UserSubject]
    
    // Self Initialized
    let weekDay : String
    let semesterProgress : Int
    
    init(user: User, activities: [Activity], userSubjects: [UserSubject]) {
        self.user = user
        self.activities = activities
        self.userSubjects = userSubjects
        
        self.semesterProgress = user.university?.calculateSemester() ?? 0
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.dateFormat = "EEEE"
        self.weekDay = dateFormatter.string(from: date)
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack{
                
                DefaultBackground()
                
                VStack{
                    
                    HStack{
                        Text("Olá, \(user.name?.split(separator: " ")[0] ?? "Usuário")!")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.bottom,CSS.paddingBottomText)
                    
                    HStack{
                        Text("Outro/a \(weekDay) na USP!")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.bottom,CSS.paddingBottomText)
                    
                    HStack{
                        Text("\(semesterProgress)% do Semestre Concluído. Vamos lá!")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.bottom,CSS.paddingBottomText)
                    
                    ScrollView{
                        
                        VStack{
                            
                            HStack{
                                Text("Atividades de Hoje")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                    .bold()
                                Spacer()
                            }
                            
                            ForEach(activities.filter{
                                activity in
                                return activity.isDueToday()
                            }) { activity in
                                
                                ActivityCard(activity: activity)
                                
                            }
                            .padding(.vertical, CSS.paddingVerticalScrollView)
                            
                        }
                        .padding()
                        .background(Color("Gray_2"))
                        .cornerRadius(CSS.cornerRadius)
                        .padding(.bottom)
                        
                        VStack{
                            
                            HStack{
                                Text("Aulas de Hoje")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                    .bold()
                                Spacer()
                            }
                            
                            // Disciplinas com aulas hoje
                            let filteredSubjects = userSubjects.filter{
                                userSubject in
                                return userSubject.subjectClass.isToday()
                            }
                            
                            // Disciplinas com aulas hoje ordenadas pelo horário de aula hoje
                            let sortedFilteredSubjects = filteredSubjects.sorted { e1, e2 in
                                let weekday = Calendar.current.component(.weekday, from: Date())
                                
                                let e1Start = e1.subjectClass.getFirstAvailableDayStart(matching: weekday)
                                let e2Start = e2.subjectClass.getFirstAvailableDayStart(matching: weekday)
                                
                                return e1Start < e2Start
                            }
                            
                            ForEach(sortedFilteredSubjects) { userSubject in
                                
                                WeekCard(userSubject:userSubject)
                                
                            }
                            .padding(.vertical, CSS.paddingVerticalScrollView)
                            
                        }
                        .padding()
                        .background(Color("Gray_2"))
                        .cornerRadius(CSS.cornerRadius)
                        .padding(.bottom)
                        
                        VStack{
                            
                            HStack{
                                Text("Atividades da Semana")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                    .bold()
                                Spacer()
                            }
                            
                            ForEach(activities.filter{
                                activity in
                                return activity.isDueThisWeek()
                            }) { activity in
                                
                                ActivityCard(activity: activity)
                                
                            }
                            .padding(.vertical, CSS.paddingVerticalScrollView)
                            
                        }
                        .padding()
                        .background(Color("Gray_2"))
                        .cornerRadius(CSS.cornerRadius)
                                                
                    }
                    
                }
                .safeAreaPadding()
                
            }
            
        }
        
    }
}

#Preview {
    Home(
        user: User(id: 6681, email: "romanzinidaniel@usp.br", name: "Daniel Contente Romanzini", instituteId: 32, courseId: 84, isVerified: nil, institute: nil, notificationId: nil, userVersion: nil, university: University(id: 1, name: "Universidade de São Paulo", slug: "USP")),
        
        activities:
            [
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
        ],
        
        userSubjects:
            [
                UserSubject(
                    id: 39275,
                    absences: 0,
                    grading: 3.5,
                    subjectClass: SubjectClass(
                        id: 21074,
                        availableDays: [
                            AvailableDay(day: "qua", start: "14:00", end: "17:00")
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
                    grading: 7.2,
                    subjectClass: SubjectClass(
                        id: 21074,
                        availableDays: [
                            AvailableDay(day: "qua", start: "14:00", end: "17:00")
                        ],
                        subject: Subject(
                            id: 15461,
                            name: "Processamento de Linguagem Natural",
                            code: "SCC0261",
                            driveItemsNumber: 0
                        )
                    )
                ),
            ]
    )
}

