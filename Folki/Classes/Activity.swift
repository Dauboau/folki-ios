//
//  Activity.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 10/02/25.
//

import Foundation
import SwiftData
import SwiftUICore

@Model
class Activity: Decodable, Equatable {

    // Properties
    @Attribute(.unique) var id: Int
    var name: String
    var activityDescription: String
    var value: Float
    var subjectClassId: Int
    var finishDate: String
    var type: String
    var subjectClass: SubjectClass?
    var checked: Bool?
    var ignored: Bool?
    var isPrivate: Bool?
    var deletedAt: String?

    // Initializer
    init(id: Int, name: String, activityDescription: String, value: Float, subjectClassId: Int, finishDate: String, type: String, subjectClass: SubjectClass? = nil, checked: Bool? = nil, ignored: Bool? = nil, isPrivate: Bool? = nil, deletedAt: String? = nil) {
        self.id = id
        self.name = name
        self.activityDescription = activityDescription
        self.value = value
        self.subjectClassId = subjectClassId
        self.finishDate = finishDate
        self.type = type
        self.subjectClass = subjectClass
        self.checked = checked
        self.ignored = ignored
        self.isPrivate = isPrivate
        self.deletedAt = deletedAt
    }

    // Equatable conformance
    static func ==(lhs: Activity, rhs: Activity) -> Bool {
        return lhs.id == rhs.id
    }

    // Decodable conformance
    enum CodingKeys: String, CodingKey {
        case id, name, activityDescription = "description", value, subjectClassId, finishDate, type, subjectClass, checked, ignored, isPrivate, deletedAt
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let activityDescription = try container.decode(String.self, forKey: .activityDescription)
        let value = try container.decode(Float.self, forKey: .value)
        let subjectClassId = try container.decode(Int.self, forKey: .subjectClassId)
        let finishDate = try container.decode(String.self, forKey: .finishDate)
        let type = try container.decode(String.self, forKey: .type)
        let subjectClass = try container.decodeIfPresent(SubjectClass.self, forKey: .subjectClass)
        let checked = try container.decodeIfPresent(Bool.self, forKey: .checked)
        let ignored = try container.decodeIfPresent(Bool.self, forKey: .ignored)
        let isPrivate = try container.decodeIfPresent(Bool.self, forKey: .isPrivate)
        let deletedAt = try container.decodeIfPresent(String.self, forKey: .deletedAt)

        self.init(id: id, name: name, activityDescription: activityDescription, value: value, subjectClassId: subjectClassId, finishDate: finishDate, type: type, subjectClass: subjectClass, checked: checked, ignored: ignored, isPrivate: isPrivate, deletedAt: deletedAt)
    }

    // Update function
    func update(activity: Activity) {
        self.name = activity.name
        self.activityDescription = activity.activityDescription
        self.value = activity.value
        self.subjectClassId = activity.subjectClassId
        self.finishDate = activity.finishDate
        self.type = activity.type
        //self.subjectClass = activity.subjectClass
        if(self.subjectClass != nil && activity.subjectClass != nil){
            self.subjectClass?.update(subjectClass: activity.subjectClass!)
        }else{
            self.subjectClass = activity.subjectClass
        }
        self.checked = activity.checked
        self.ignored = activity.ignored
        self.isPrivate = activity.isPrivate
        self.deletedAt = activity.deletedAt
    }
    
    func getDeadlineDate() -> Date? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        return isoFormatter.date(from: self.finishDate)
    }
    
    func isLate() -> Bool {

        if let date = getDeadlineDate() {
            let today = Date()
            let calendar = Calendar.current
            
            if(calendar.compare(date,to: today,toGranularity: .dayOfYear) == .orderedAscending){
               return true
            }else{
                return false
            }
 
        }

        return false
    }
    
    func isDueToday() -> Bool {

        if let date = getDeadlineDate() {
            let calendar = Calendar.current
            return calendar.isDateInToday(date)
        }

        return false
    }
    
    func isDue(_ date: Date) -> Bool {
        
        if let dueDate = getDeadlineDate() {
            let calendar = Calendar.current
            return calendar.isDate(dueDate,equalTo: date,toGranularity: .dayOfYear)
        }

        return false
        
    }
    
    func isDueThisWeek() -> Bool {
        
        if let date = getDeadlineDate() {
            let today = Date()
            let calendar = Calendar.current
            return calendar.isDate(date,equalTo: today,toGranularity: .weekOfYear)
        }

        return false
    }
    
    /**
    Get  the activity's color based on on the type of the activity
     */
    func getColor() -> Color {
        
        switch (self.type) {
            case "EXAM":
            return Color.secondaryGreen;
            case "HOMEWORK":
                return Color.secondaryYellow;
            case "ACTIVITY":
            return Color.secondaryBlue;
            case "LIST":
            return Color.secondaryDarkBlue;
            default:
                return Color.primaryPurple;
        }
        
    }
    
    func getType() -> String {
        
        switch (self.type) {
            case "EXAM":
                return "Prova"
            case "HOMEWORK":
                return "Trabalho"
            case "ACTIVITY":
                return "Atividade"
            case "LIST":
                return "Lista"
            default:
                return "Outro"
        }
        
    }
    
}
