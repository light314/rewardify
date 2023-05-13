import SwiftUI

import SwiftUI

struct DailyActionView: View {
    @ObservedObject var lifeArea: LifeArea
    @State private var newActionName = ""
    @State private var newActionGoalFrequency = 1
    @State private var newActionTimePeriod = TimePeriod.daily
    @State private var showSheet = false
    @State private var selectedAction: DailyAction?
    @State private var isEditing = false
    @State private var editText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(lifeArea.dailyActions.indices, id: \.self) { index in
                        VStack{
                            
                                VStack {
                                    Text(lifeArea.dailyActions[index].name)
                                        .font(.headline)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    HStack{
                                    Text("Time period: \(lifeArea.dailyActions[index].timePeriod.rawValue)")
                                    Spacer()
                                    Text("\(lifeArea.dailyActions[index].count)/\(lifeArea.dailyActions[index].goalFrequency)")
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                        selectedAction = lifeArea.dailyActions[index]
                                    }
                                .onLongPressGesture {
                                    /*isEditing = true
                                    editText = lifeArea.dailyActions[index].name*/
                                    selectedAction = lifeArea.dailyActions[index]
                                }
                                .background(selectedAction == lifeArea.dailyActions[index] ? Color.yellow.opacity(0.3) : Color.clear)
                                                            
                        }
                        .listRowSeparator(.visible)
                        .swipeActions(edge: .leading) {
                                Button(action: {
                                    lifeArea.dailyActions[index].count += 1
                                    if lifeArea.dailyActions[index].count >= lifeArea.dailyActions[index].goalFrequency {
                                        lifeArea.dailyActions[index].isComplete = true
                                    }
                                }) {
                                    Label("Complete", systemImage: "checkmark.circle.fill")
                                        .tint(.green)
                                }
                                .tint(.green)
                                Button(role: .destructive, action: {
                                    lifeArea.dailyActions.remove(at: index)
                                }) {
                                    Label("Delete", systemImage: "trash")
                                }
                            }


                        
                        
                     
                    }
                }
                .listStyle(.inset)
                VStack {
                    Form {
                        TextField("Add new daily action", text: $newActionName)

                        Stepper("Goal Frequency: \(newActionGoalFrequency)", value: $newActionGoalFrequency, in: 1...10)

                        Picker(selection: $newActionTimePeriod, label: Text("Time Period")) {
                            ForEach(TimePeriod.allCases, id: \.self) { period in
                                Text(period.rawValue.capitalized).tag(period)
                            }
                        }
                    }.frame(height: 200)

                    HStack {
                        Spacer()

                        Button(action: {
                            if !self.newActionName.isEmpty {
                                let newAction = DailyAction(
                                    name: self.newActionName)
                                newAction.timePeriod = self.newActionTimePeriod
                                newAction.goalFrequency = self.newActionGoalFrequency
                                self.lifeArea.dailyActions.append(newAction)
                                self.newActionName = ""
                                self.newActionGoalFrequency = 1
                                self.newActionTimePeriod = .daily
                            }
                        }) {
                            Text("Add")
                        }
                    }
                    .padding()
                }
            }
            .sheet(item: $selectedAction) { action in
                EditDailyActionView(action: action,
                                    lifeArea: lifeArea)
            }
            .navigationBarTitle(lifeArea.name)

        }
    }
}

struct EditDailyActionView: View {
    @ObservedObject var action: DailyAction
    @ObservedObject var lifeArea: LifeArea
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        TextField("New name", text: $action.name)
                    }
                    
                    Section(header: Text("Goal frequency")) {
                        Stepper(value: $action.goalFrequency, in: 1...10) {
                            Text("\(action.goalFrequency) time\(action.goalFrequency == 1 ? "" : "s") per \(action.timePeriod.rawValue.lowercased())")
                        }
                        Picker(selection: $action.timePeriod, label: Text("Time period")) {
                            ForEach(TimePeriod.allCases, id: \.self) { timePeriod in
                                Text(timePeriod.rawValue.capitalized).tag(timePeriod)
                            }
                        }
                    }

                }
            }
            .navigationBarTitle("Edit action")
            .navigationBarItems(trailing: Button("Save") {
                let index = lifeArea.dailyActions.firstIndex(where: { $0.id == action.id })!
                lifeArea.dailyActions[index] = action
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
}



class DailyAction: ObservableObject, Identifiable, Equatable {
    let id = UUID()
    @Published var name: String
    @Published var count = 0
    @Published var timePeriod: TimePeriod = .daily
    @Published var goalFrequency = 1
    @Published var isComplete = false
    
    static func ==(lhs: DailyAction, rhs: DailyAction) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(name: String) {
        self.name = name
    }
}
enum TimePeriod: String, CaseIterable {
    case hourly = "Hourly"
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case quarterly = "Quarterly"
    case yearly = "Yearly"
}


