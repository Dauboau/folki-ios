//
//  Calendar.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 12/02/25.
//

import SwiftUI

struct CalendarScreen: View {
    
    let activities : [Activity]
    
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    @State private var selectedDate: Date? = Date()
    @State private var selectedActivity: Activity?
    
    @State private var preferredColumn = NavigationSplitViewColumn.sidebar
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    
    init(activities: [Activity]) {
        self.activities = activities
    }
    
    var body: some View {
            
        NavigationSplitView(columnVisibility: $columnVisibility, preferredCompactColumn: $preferredColumn){
            
            ZStack{
                
                DefaultBackground()
                
                VStack{
                    
                    HStack{
                        Text("Calendário")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.bottom,CSS.paddingBottomText)
                    
                    HStack{
                        Text("Vamos organizar seu dia!")
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.bottom,CSS.paddingBottomText)
                    
                    Spacer()
                    
                    CalendarView(activities: activities, selectedDate: $selectedDate)
                        .frame(maxHeight: 500)
                    
                        .onChange(of: selectedDate){
                            preferredColumn = NavigationSplitViewColumn.content
                        }
                    
                    Spacer()
                    
                }
                .safeAreaPadding()
                //.toolbar(removing: .sidebarToggle)
                
            }
            
        } content: {
            
            let dayActivities = activities.filter{
                activity in
                if(selectedDate != nil){
                    return activity.isDue(selectedDate!)
                }
                return false
            }
            
            NavigationStack{
                
                ZStack{
                    
                    DefaultBackground()
                    
                    VStack{
                        
                        Text("\(selectedDate?.formatted(date: .numeric, time: .omitted) ?? "")")
                            .foregroundStyle(.white)
                            .font(.title)
                            .bold()
                        
                        if(dayActivities.isEmpty){
                            
                            Spacer()
                            
                            Text("Nenhuma Atividade Encontrada")
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            Spacer()
                            
                            
                        }else{
                            
                            ScrollView{
                                
                                ForEach(dayActivities) { activity in
                                    
                                    ActivityCard(activity:activity)
                                        .padding(.vertical, CSS.paddingVerticalScrollView)
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    .safeAreaPadding()
                    
                }
                
            }
            
        } detail: {
            
            let firstActivity = activities.first{
                activity in
                return activity.isDue(selectedDate ?? Date())
            }
            
            if(firstActivity != nil){
                ActivityList(activity: firstActivity!)
            }else{
                ZStack{
                    
                    DefaultBackground()
                    
                    VStack{
                        
                        Text("Atividade")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("Nenhuma Atividade Encontrada")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                        
                    }
                    .safeAreaPadding()
                    
                }
                
            }
            
        }
        .navigationSplitViewStyle(.balanced)

    }
}

struct CalendarView: UIViewRepresentable {
    
    let activities: [Activity]
    @Binding var selectedDate: Date?
    
    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.delegate = context.coordinator
        calendarView.availableDateRange = DateInterval(start: Date(), end: Calendar.current.date(byAdding: .month, value: 6, to: Date())!)
        calendarView.overrideUserInterfaceStyle = .dark

        // Set up selection behavior for single date selection
        let selection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        calendarView.selectionBehavior = selection
        
        // Accepts SwiftUI customizations
        calendarView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        calendarView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return calendarView
    }

    func updateUIView(_ uiView: UICalendarView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(activities: activities,selectedDate: $selectedDate)
    }
    
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        
        let activities: [Activity]
        @Binding var selectedDate: Date?
        
        init(activities: [Activity],selectedDate: Binding<Date?>) {
            self.activities = activities
            _selectedDate = selectedDate
        }
        
        // Date selection
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            guard let dateComponents = dateComponents,
                  let selectedDate = Calendar.current.date(from: dateComponents) else {
                return
            }

            // Update the selected date in the SwiftUI view
            self.selectedDate = selectedDate

            // Print the selected date
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            let formattedDate = dateFormatter.string(from: selectedDate)
            
            print("Selected Date: \(formattedDate)")
        }

        // Runs for every date to decorate with activities
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            
            guard let date = Calendar.current.date(from: dateComponents) else { return nil }

            // Filter activities due this date
            let dueActivities = activities.filter { activity in
                return Calendar.current.isDate(activity.getDeadlineDate() ?? Date(), inSameDayAs: date)
            }
            
            if !dueActivities.isEmpty {
                let dotCount = dueActivities.count
                let parentView = UIView()
                
                var i = 0
                for activity in dueActivities {
                    // Small dot size
                    let dot = UIView(frame: CGRect(x: i * 8, y: 0, width: 6, height: 6))
                    dot.backgroundColor = UIColor(activity.getColor())
                    dot.layer.cornerRadius = 3
                    parentView.addSubview(dot)
                    i += 1
                }
                
                // Set the size of the parent view based on the number of dots
                parentView.frame.size = CGSize(width: dotCount * 8, height: 6)

                return .customView {
                    return parentView
                }
            }
            
            return nil
        }
    }
}

#Preview {
    CalendarScreen(activities: [
        Activity(id: 7757, name: "Lição de Multimídia", activityDescription: "", value: 3, subjectClassId: 21074, finishDate: "2025-02-21T15:00:00.000Z", type: "ACTIVITY",
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
        ),
        Activity(id: 7157, name: "Lição Contente", activityDescription: "", value: 3, subjectClassId: 21074, finishDate: "2025-02-21T15:00:00.000Z", type: "ACTIVITY",
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
        ),
        Activity(id: 7137, name: "Lição Contente", activityDescription: "", value: 3, subjectClassId: 21074, finishDate: "2025-02-21T15:00:00.000Z", type: "EXAM",
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
