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
    @Attribute(.unique) var id: Int?
    var absences: Int?
    var grading: Float?
    var subjectClass: SubjectClass
    var color: String?
    var observation: String?

    // Initializer
    init(id: Int? = nil, absences: Int? = nil, grading: Float? = nil, subjectClass: SubjectClass, color: String? = nil, observation: String? = nil) {
        self.id = id
        self.absences = absences
        self.grading = grading
        self.subjectClass = subjectClass
        self.color = color
        self.observation = observation
    }
    
    // Equatable conformance
    static func ==(lhs: UserSubject, rhs: UserSubject) -> Bool {
        return lhs.id == rhs.id
    }

    // Decodable conformance
    enum CodingKeys: String, CodingKey {
        case id, absences, grading, subjectClass, color, observation
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decodeIfPresent(Int.self, forKey: .id)
        let absences = try container.decodeIfPresent(Int.self, forKey: .absences)
        let grading = try container.decodeIfPresent(Float.self, forKey: .grading)
        let subjectClass = try container.decode(SubjectClass.self, forKey: .subjectClass)
        let color = try container.decodeIfPresent(String.self, forKey: .color)
        let observation = try container.decodeIfPresent(String.self, forKey: .observation)

        self.init(id: id, absences: absences, grading: grading, subjectClass: subjectClass, color: color, observation: observation)
    }
    
    func update(userSubject : UserSubject){
        self.absences = userSubject.absences
        self.grading = userSubject.grading
        self.subjectClass.update(subjectClass: userSubject.subjectClass)
        self.color = userSubject.color
        self.observation = userSubject.observation
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
        "dom": 1, "seg": 2, "ter": 3, "qua": 4, "qui": 5, "sex": 6, "sab": 7
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
        return today.getNextWeekday(AvailableDay.Weekday[self.day, default: 1])
    }
    
}
