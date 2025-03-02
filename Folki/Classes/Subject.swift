//
//  Subject.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 08/02/25.
//

import Foundation
import SwiftData

@Model
class UserSubject: Decodable, Equatable {
    
    // Properties
    @Attribute(.unique) var id: Int
    var absences: Int
    var grading: Float
    var subjectClass: SubjectClass
    var color: String

    // Initializer
    init(id: Int, absences: Int, grading: Float, subjectClass: SubjectClass, color: String? = nil) {
        self.id = id
        self.absences = absences
        self.grading = grading
        self.subjectClass = subjectClass
        if(color == nil){
            self.color = UserSubject.randomDarkColor()
        }else{
            self.color = color ?? "#7500BC"
        }
    }
    
    // Equatable conformance
    static func ==(lhs: UserSubject, rhs: UserSubject) -> Bool {
        return lhs.id == rhs.id
    }

    // Decodable conformance
    enum CodingKeys: String, CodingKey {
        case id, absences, grading, subjectClass, color
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let absences = try container.decode(Int.self, forKey: .absences)
        let grading = try container.decode(Float.self, forKey: .grading)
        let subjectClass = try container.decode(SubjectClass.self, forKey: .subjectClass)
        let color = try container.decodeIfPresent(String.self, forKey: .color)

        self.init(id: id, absences: absences, grading: grading, subjectClass: subjectClass, color: color)
    }
    
    func update(userSubject : UserSubject){
        self.absences = userSubject.absences
        self.grading = userSubject.grading
        self.subjectClass.update(subjectClass: userSubject.subjectClass)
        //The colors should be preserved
        //self.color = userSubject.color
    }
    
    private static func randomDarkColor() -> String {
        let lum: CGFloat = -0.25
        let randomHex = String(format: "#%06X", Int(arc4random_uniform(0xFFFFFF)))
        
        var darkHex = "#"
        for i in 0..<3 {
            var c = Int(randomHex.dropFirst(i * 2 + 1).prefix(2), radix: 16)!
            c = max(0, min(255, Int(CGFloat(c) * (1 + lum))))
            darkHex += String(format: "%02X", c)
        }

        return darkHex
    }
    
}

@Model
class Subject: Decodable, Equatable {
    
    // Properties
    var id: Int
    var name: String
    var code: String?
    var content: String?
    var driveItemsNumber: Int?

    // Initializer
    init(id: Int, name: String, code: String? = nil, content: String? = nil, driveItemsNumber: Int? = nil) {
        self.id = id
        self.name = name
        self.code = code
        self.content = content
        self.driveItemsNumber = driveItemsNumber
    }
    
    // Equatable conformance
    static func ==(lhs: Subject, rhs: Subject) -> Bool {
        return lhs.id == rhs.id
    }

    // Decodable conformance
    enum CodingKeys: String, CodingKey {
        case id, name, code, content, driveItemsNumber
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let code = try container.decodeIfPresent(String.self, forKey: .code)
        let content = try container.decodeIfPresent(String.self, forKey: .content)
        let driveItemsNumber = try container.decodeIfPresent(Int.self, forKey: .driveItemsNumber)

        self.init(id: id, name: name, code: code, content: content, driveItemsNumber: driveItemsNumber)
    }
    
    func update(subject: Subject){
        self.id = subject.id
        self.name = subject.name
        self.code = subject.code
        self.content = subject.content
        self.driveItemsNumber = subject.driveItemsNumber
    }
    
}

@Model
class SubjectClass: Decodable, Equatable {
    
    // Properties
    var id: Int
    @Relationship(deleteRule: .cascade, inverse: \AvailableDay.parent) var availableDays: [AvailableDay]
    var subject: Subject

    // Initializer
    init(id: Int, availableDays: [AvailableDay], subject: Subject) {
        self.id = id
        self.availableDays = availableDays
        self.subject = subject
        
        // Configure the inverse relationship
        for availableDay in self.availableDays {
            availableDay.parent = self
        }
        
    }
    
    // Equatable conformance
    static func ==(lhs: SubjectClass, rhs: SubjectClass) -> Bool {
        return lhs.id == rhs.id
    }

    // Decodable conformance
    enum CodingKeys: String, CodingKey {
        case id, availableDays, subject
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let availableDays = try container.decode([AvailableDay].self, forKey: .availableDays)
        let subject = try container.decode(Subject.self, forKey: .subject)

        self.init(id: id, availableDays: availableDays, subject: subject)
    }
    
    func update(subjectClass: SubjectClass){
        self.id = subjectClass.id
        self.subject.update(subject: subjectClass.subject)
        self.availableDays.forEach{ availableDayAux in
            availableDayAux.update(availableDay: availableDayAux)
        }
    }
    
    func isToday() -> Bool {
        
        let calendar = Calendar.current
        
        for availableDay in self.availableDays {
            let nextLesson = availableDay.getNextDate()
            
            if(calendar.isDateInToday(nextLesson)){
                return true
            }
        }

        return false
        
    }
    
    func getNextAvailableDay() -> AvailableDay? {
        
        let calendar = Calendar.current
        
        let sortedNextAvailableDays = self.availableDays.sorted {
            (day1,day2) in
            
            let nextLesson1 = day1.getNextDate()
            let nextLesson2 = day2.getNextDate()
            
            return calendar.compare(nextLesson1, to: nextLesson2, toGranularity: .day) == .orderedAscending
        }
        
        return sortedNextAvailableDays.first
        
    }
    
    func getFirstAvailableDayStart(matching weekDay: Int) -> String {
        let matchingDays = self.availableDays.filter { availableDay in
            AvailableDay.Weekday[availableDay.day] == weekDay
        }

        return matchingDays.first?.start ?? "23:59"
    }
    
}

@Model
class AvailableDay: Decodable, Equatable, Comparable {
    
    // Properties
    var day: String
    var start: String
    var end: String
    var classRoom: String?
    
    var parent: SubjectClass?
    
    // Static
    static let Weekday: [String: Int] = [
        "dom": 1, "seg": 2, "ter": 3, "qua": 4, "qui": 5, "sex": 6, "sab": 7 // default: 8
    ]
    static let WeekdayStr: [String: String] = [
        "dom": "Domingo",
        "seg": "Segunda-feira",
        "ter": "Terça-feira",
        "qua": "Quarta-feira",
        "qui": "Quinta-feira",
        "sex": "Sexta-feira",
        "sab": "Sábado"
    ]

    // Initializer
    init(day: String, start: String, end: String, classRoom: String? = nil, parent: SubjectClass? = nil) {
        self.day = day
        self.start = start
        self.end = end
        self.classRoom = classRoom
    }

    // Decodable conformance
    enum CodingKeys: String, CodingKey {
        case day, start, end, classRoom
    }
    
    // Comparable conformance
    static func < (lhs: AvailableDay, rhs: AvailableDay) -> Bool {
        let lhsDate = lhs.getNextDate()
        let rhsDate = rhs.getNextDate()
        return lhsDate < rhsDate
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let day = try container.decode(String.self, forKey: .day)
        let start = try container.decode(String.self, forKey: .start)
        let end = try container.decode(String.self, forKey: .end)
        let classRoom = try container.decodeIfPresent(String.self, forKey: .classRoom)

        self.init(day: day, start: start, end: end, classRoom: classRoom)
    }
    
    func update(availableDay: AvailableDay){
        self.day = availableDay.day
        self.start = availableDay.start
        self.end = availableDay.end
        self.classRoom = availableDay.classRoom
    }
    
    /**
     Returns the next Date for the AvailableDay weekday
     */
    func getNextDate() -> Date {
        let today = Date()
        return today.getNextWeekday(AvailableDay.Weekday[self.day, default: 8])
    }
    
}
