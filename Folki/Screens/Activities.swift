//
//  Activities.swift
//  Folki
//
//  Created by Daniel Contente Romanzini on 10/02/25.
//

import SwiftUI

struct Activities: View {
    
    let activities : [Activity]
    let userSubjects : [UserSubject]
    
    @State var expandedLate : Bool = true
    @State var expandedDue : Bool = true
    @State var expandedChecked : Bool = true
    @State var expandedDeleted : Bool = true
    
    @State private var addActivityPopover = false
    @State var editActivity: Activity?
    
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
                        Button("Adicionar Atividade",systemImage: "plus"){
                            addActivityPopover = true
                        }
                        .labelStyle(.iconOnly)
                        .tint(.white)
                    }
                    .padding(.bottom,CSS.paddingBottomText)
                    
                    .sheet(isPresented: $addActivityPopover, content:{
                        AddActivitySheet(userSubjects)
                    })
                    
                    .sheet(item: $editActivity){activity in
                        EditActivitySheet(activity,userSubjects)
                    }
                    
                    HStack{
                        Text("\(activities.count{$0.checked != true && $0.deletedAt == nil && $0.isLate() == false}) Atividade(s) Restante(s)!")
                            .foregroundColor(.white)
                            .contentTransition(.numericText())
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
                                            SwipeEdit(activity: activity,editActivity: $editActivity)
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
                                            SwipeEdit(activity: activity,editActivity: $editActivity)
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
                                            SwipeEdit(activity: activity,editActivity: $editActivity)
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
    ], userSubjects: [
        UserSubject(
            id: 39275,
            absences: 0,
            grading: 4.2,
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
            grading: 4.2,
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
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    if(activity.subjectClass != nil){
                        HStack {
                            Text("\(activity.subjectClass?.subject.name ?? "")")
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                    }
                    HStack {
                        Text(String("\(Int(activity.value) * 10)% da Nota - \(DateFormatter.localizedString(from: activity.getDeadlineDate()!, dateStyle: .short, timeStyle: .none))"))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
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
    
    let token : String? = UserDefaults.standard.string(forKey: "token")
    
    let activity : Activity
    
    var body: some View {
        
        Button("Concluir",systemImage: "checkmark.square.fill"){
            
            withAnimation(.snappy) {
                checkData(activity)
            }
        }
        .tint(Color("Primary_Green"))
        
    }
    
    func checkData(_ activity: Activity){
        Task.detached(){
            
            // Check Activity
            let checkAux = checkActivity(token: token!,activity: activity)
            
            if(checkAux == nil){
                return
            }
            
            await MainActor.run{
                
                #if DEBUG
                print("\(activity.name) checked!")
                #endif
                
                withAnimation {
                    activity.checked = true
                }
                
            }
            
        }
    }
    
}

fileprivate struct SwipeEdit: View {
    
    let activity : Activity
    var editActivity: Binding<Activity?> = .constant(nil)
    
    var body: some View {
        
        Button("Editar",systemImage: "square.and.pencil"){
            editActivity.wrappedValue = activity
        }
        .tint(Color("Gray_2"))
        
    }
    
}

fileprivate struct SwipeDelete: View {
    
    let token : String? = UserDefaults.standard.string(forKey: "token")
    
    let activity : Activity
    
    var body: some View {
        
        Button("Excluir",systemImage: "minus.square.fill"){
            
            withAnimation(.snappy) {
                deleteData(activity)
            }
            
        }
        .tint(Color("Primary_Red"))
        
    }
    
    func deleteData(_ activity: Activity){
        Task.detached(){
            
            // Delete Activity
            let deleteAux = deleteActivity(token: token!,activity: activity)
            
            if(deleteAux == nil){
                return
            }
            
            if(deleteAux!){
                await MainActor.run{
                    
                    #if DEBUG
                    print("\(activity.name) deleted!")
                    #endif
                    
                    let isoFormatter = ISO8601DateFormatter()
                    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                    
                    let currentDate = Date()
                    let currentDateISO = isoFormatter.string(from: currentDate)
                    
                    withAnimation {
                        activity.deletedAt = currentDateISO
                    }
                    
                }
            }
            
        }
    }
    
}

fileprivate struct SwipeRestore: View {
    
    let token : String? = UserDefaults.standard.string(forKey: "token")
    
    let activity : Activity
    
    var body: some View {
        
        Button("Restaurar",systemImage: "arrow.circlepath"){

            
            withAnimation(.snappy) {
                restoreData(activity)
            }
            
        }
        .tint(Color("Gray_2"))
        
    }
    
    func restoreData(_ activity: Activity){
        Task.detached(){
            
            // Delete Activity
            let restoreAux = restoreActivity(token: token!,activity: activity)
            
            if(restoreAux == nil){
                return
            }
            
            if(restoreAux!){
                await MainActor.run{
                    
                    #if DEBUG
                    print("\(activity.name) restored!")
                    #endif
                    
                    withAnimation {
                        activity.deletedAt = nil
                    }
                    
                }
            }
            
        }
    }
    
}

fileprivate struct SwipeUncheck: View {
    
    let token : String? = UserDefaults.standard.string(forKey: "token")
    
    let activity : Activity
    
    var body: some View {
        
        Button("Desfazer",systemImage: "arrow.uturn.backward.square.fill"){
            
            withAnimation(.snappy) {
                uncheckData(activity)
            }
        }
        .tint(Color("Gray_2"))
        
    }
    
    func uncheckData(_ activity: Activity){
        Task.detached(){
            
            // Uncheck Activity
            let uncheckAux = uncheckActivity(token: token!,activity: activity)
            
            if(uncheckAux == nil){
                return
            }
            
            await MainActor.run{
                
                #if DEBUG
                print("\(activity.name) unchecked!")
                #endif
                
                withAnimation {
                    activity.checked = false
                }
                
            }
            
        }
    }
    
}

fileprivate struct AddActivitySheet: View {
    
    let token : String? = UserDefaults.standard.string(forKey: "token")
    
    let userSubjects : [UserSubject]
    
    init(_ userSubjects: [UserSubject]) {
        self.userSubjects = userSubjects
    }
    
    @State private var activityName = ""
    @State private var date = Date()
    @State private var value = ""
    @State private var type = ""
    @State private var subjectIdString = ""
    @State private var publicString = ""
    @State private var errorFlag: Bool = false
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataValidity: Cache.Validity
    
    var body: some View {
        
        ZStack{
            
            DefaultBackgroundSheet()
            
            VStack{
                
                Text("Nova Atividade")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(CSS.paddingBottomText)
                
                TextField("Nome da Atividade", text: $activityName)
                    .textFieldStyle(.roundedBorder)
                    .padding(CSS.paddingBottomText)
                
                TextField("Valor da Atividade (0 até 10)", text: $value)
                    .textFieldStyle(.roundedBorder)
                    .padding(CSS.paddingBottomText)
                
                DatePicker("Data", selection: $date, displayedComponents: [.date])
                    .datePickerStyle(.compact)
                    .foregroundColor(.white)
                    .environment(\.colorScheme, .dark)
                    .padding(.horizontal,5)
                    .padding(CSS.paddingBottomText)
                
                HStack{
                    Picker(selection: $type, label: Text("Tipo de Atividade")) {
                        Text("Tipo de Atividade").tag("")
                        Text("Prova").tag("EXAM")
                        Text("Trabalho").tag("HOMEWORK")
                        Text("Atividade").tag("ACTIVITY")
                        Text("Lista").tag("LIST")
                    }
                    .pickerStyle(.menu)
                    .tint(.white)
                    Spacer()
                }
                
                HStack{
                    Picker(selection: $subjectIdString, label: Text("Disciplina da Atividade")) {
                        Text("Disciplina da Atividade").tag("")
                        ForEach(userSubjects){
                            userSubject in
                            Text(userSubject.subjectClass.subject.name).tag(String(userSubject.id))
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(.white)
                    Spacer()
                }
                
                HStack{
                    Picker(selection: $publicString, label: Text("A Atividade é Pública?")) {
                        Text("A Atividade é Pública?").tag("")
                        Text("Atividade Pública").tag("Sim")
                        Text("Atividade Privada").tag("Não")
                    }
                    .pickerStyle(.menu)
                    .tint(.white)
                    Spacer()
                }
                
                HStack{
                    Button(action: {
                        
                        if(activityName.isEmpty || value.isEmpty || type.isEmpty || subjectIdString.isEmpty || publicString.isEmpty){
                            errorFlag = true
                            return
                        }
                        
                        let isPrivate: Bool = {
                            switch publicString {
                                case "Sim":
                                    return false
                                case "Não":
                                    return true
                                default:
                                    return true
                            }
                        }()
                        
                        let userSubject: UserSubject = userSubjects.first(where: { $0.id == Int(subjectIdString)! })!
                        
                        addData(activityName, date, Float(value) ?? 0, type, userSubject, isPrivate)
                        
                    }) {
                        Text("Criar")
                            .frame(maxWidth: CSS.maxWidth)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.primaryPurple)
                    .controlSize(.regular)
                    .padding(.top,20)
                }
                
                .alert("Erro de Preenchimento", isPresented: $errorFlag, actions: {
                    Button("Tentar Novamente") {}
                }, message: {
                    Text("Por favor preencha todos os campos.")
                })
                
            }
            .safeAreaPadding()
            
        }
        
    }
    
    func addData(_ activityName: String,_ date: Date,_ value: Float,_ type: String,_ userSubject: UserSubject, _ isPrivate: Bool){
        Task.detached(){
            
            // Add Activity
            let addActivityAux: Activity? = addActivity(token: token!, finishDate: date, isPrivate: isPrivate, name: activityName, userSubject: userSubject, type: type, value: value)
            
            if(addActivityAux == nil){
                return
            }
            
            await MainActor.run{
                
                #if DEBUG
                print("\(activityName) added!")
                #endif
                
                // Triggers Reload of Data
                dataValidity.valid = false
                
                // Dismiss Sheet
                dismiss()
                
            }
            
        }
    }
    
}

fileprivate struct EditActivitySheet: View {
    
    let token : String? = UserDefaults.standard.string(forKey: "token")
    
    let activity: Activity
    let userSubjects: [UserSubject]
    
    init(_ activity: Activity,_ userSubjects: [UserSubject]) {
        self.userSubjects = userSubjects
        self.activity = activity
        
        self.activityName = activity.name
        self.date = activity.getDeadlineDate() ?? Date()
        self.value = String(activity.value)
        self.type = activity.type
        
        let subjectId:Int = userSubjects.first(where: { $0.subjectClass.id == Int(activity.subjectClassId) })!.id
        self.subjectIdString = String(subjectId)
    }
    
    @State private var activityName: String
    @State private var date: Date
    @State private var value: String
    @State private var type: String
    @State private var subjectIdString: String
    @State private var errorFlag: Bool = false
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataValidity: Cache.Validity
    
    var body: some View {
        
        ZStack{
            
            DefaultBackgroundSheet()
            
            VStack{
                
                Text("Atualizar Atividade")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding(CSS.paddingBottomText)
                
                TextField("Nome da Atividade", text: $activityName)
                    .textFieldStyle(.roundedBorder)
                    .padding(CSS.paddingBottomText)
                
                TextField("Valor da Atividade (0 até 10)", text: $value)
                    .textFieldStyle(.roundedBorder)
                    .padding(CSS.paddingBottomText)
                
                DatePicker("Data", selection: $date, displayedComponents: [.date])
                    .datePickerStyle(.compact)
                    .foregroundColor(.white)
                    .environment(\.colorScheme, .dark)
                    .padding(.horizontal,5)
                    .padding(CSS.paddingBottomText)
                
                HStack{
                    Picker(selection: $type, label: Text("Tipo de Atividade")) {
                        Text("Tipo de Atividade").tag("")
                        Text("Prova").tag("EXAM")
                        Text("Trabalho").tag("HOMEWORK")
                        Text("Atividade").tag("ACTIVITY")
                        Text("Lista").tag("LIST")
                    }
                    .pickerStyle(.menu)
                    .tint(.white)
                    Spacer()
                }
                
                HStack{
                    Picker(selection: $subjectIdString, label: Text("Disciplina da Atividade")) {
                        Text("Disciplina da Atividade").tag("")
                        ForEach(userSubjects){
                            userSubject in
                            Text(userSubject.subjectClass.subject.name).tag(String(userSubject.id))
                        }
                    }
                    .pickerStyle(.menu)
                    .tint(.white)
                    Spacer()
                }
                
                HStack{
                    Button(action: {
                        
                        if(activityName.isEmpty || value.isEmpty || type.isEmpty || subjectIdString.isEmpty){
                            errorFlag = true
                            return
                        }
                        
                        let userSubject: UserSubject = userSubjects.first(where: { $0.id == Int(subjectIdString)! })!
                        
                        editData(activity, activityName, date, Float(value) ?? 0, type, userSubject)
                        
                    }) {
                        Text("Atualizar")
                            .frame(maxWidth: CSS.maxWidth)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.primaryPurple)
                    .controlSize(.regular)
                    .padding(.top,20)
                }
                
                .alert("Erro de Preenchimento", isPresented: $errorFlag, actions: {
                    Button("Tentar Novamente") {}
                }, message: {
                    Text("Por favor preencha todos os campos.")
                })
                
            }
            .safeAreaPadding()
            
        }
        
    }
    
    func editData(_ activity: Activity,_ activityName: String,_ date: Date,_ value: Float,_ type: String,_ userSubject: UserSubject){
        Task.detached(){
            
            // Edit Activity
            let editActivityAux: Bool? = editActivity(token: token!, activityId: activity.id, finishDate: date, name: activityName, userSubject: userSubject, type: type, value: value)
            
            if(editActivityAux == nil){
                return
            }
            
            if(editActivityAux!){
                await MainActor.run{
                    
                    #if DEBUG
                    print("\(activity.name) edited!")
                    #endif
                    
                    let isoFormatter = ISO8601DateFormatter()
                    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                    let finishDateISO: String = isoFormatter.string(from: date)
                    
                    activity.name = activityName
                    activity.finishDate = finishDateISO
                    activity.value = value
                    activity.type = type
                    activity.subjectClass = userSubject.subjectClass
                    
                    // Dismiss Sheet
                    dismiss()
                    
                }
            }
            
        }
    }
    
}
