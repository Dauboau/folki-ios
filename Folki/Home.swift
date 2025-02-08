//
//  Home.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 07/02/25.
//

import SwiftUI

struct Home: View {
    
    let user : User
    
    @State var weekDay : String = "segunda-feira"
    @State var semesterProgress : Int = 0
    
    var body: some View {
        
        NavigationStack {
            
            ZStack{
                
                Color.gray2
                    .ignoresSafeArea()
                
                VStack{
                    
                    HStack{
                        Text("Olá, \(user.name?.split(separator: " ")[0] ?? "Usuário")!")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.bottom,5)
                    
                    HStack{
                        Text("Outra \(weekDay) na USP!")
                            .foregroundColor(.white)
                        Spacer()
                    }.onAppear(){
                        let date = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "pt_BR")
                        dateFormatter.dateFormat = "EEEE"
                        weekDay = dateFormatter.string(from: date)
                    }
                    .padding(.bottom,5)
                    
                    HStack{
                        Text("\(semesterProgress)% do Semestre Concluído. Vamos lá!")
                            .foregroundColor(.white)
                        Spacer()
                    }.onChange(of: user){
                        if let universityId = user.university?.id {
                            semesterProgress = calculateSemester(universityId: universityId)
                        }
                    }
                    
                    Spacer()
                    
                }
                .safeAreaPadding()
                
            }
            
        }
        
    }
}

#Preview {
    Home(user: User(id: 6681, email: "romanzinidaniel@usp.br", name: "Daniel Contente Romanzini", instituteId: 32, courseId: 84, isVerified: nil, institute: nil, notificationId: nil, userVersion: nil, university: University(id: 1, name: "Universidade de São Paulo", slug: "USP")))
}

let universityDates: [Int: [Date]] = [
    1: [Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 5))!,
        Calendar.current.date(from: DateComponents(year: 2024, month: 12, day: 12))!],
    2: [Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 14))!,
        Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 7))!]
]

func calculateSemester(universityId: Int) -> Int {
    let today = Date()
    guard let dates = universityDates[universityId] else {
        return 0
    }
    
    let start = dates[0]
    let end = dates[1]
    
    let total = end.timeIntervalSince(start)
    let current = today.timeIntervalSince(start)
    
    let percentage = (current / total) * 100
    return Int(min(max(floor(percentage), 0), 100))
}
