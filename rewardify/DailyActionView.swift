import SwiftUI

import SwiftUI

struct DailyActionView: View {
    @ObservedObject var lifeArea: LifeArea
    @State private var newActionName = ""
    @State private var newActionGoalFrequency = 1
    @State private var newActionTimePeriod = TimePeriod.daily
    @State private var showSheet = false
    @State private var selectedAction: DailyAction?
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(lifeArea.dailyActions.indices, id: \.self) { index in
                        VStack {
                            if isEditing {
                                HStack {
                                    TextField(action.name, text: $editText) { _ in } onCommit: {
                                        action.name = editText
                                        isEditing = false
                                    }
                                    .textFieldStyle(.roundedBorder)
                                    
                                    Button(action: {
                                        isEditing = false
                                        editText = ""
                                    }) {
                                        Text("Cancel")
                                    }
                                }
                            } else {
                                
                                /*
                                 HStack {
                                     Text("Time period: \(lifeArea.dailyActions[index].timePeriod.rawValue)")
                                     Spacer()
                                     Text("\(lifeArea.dailyActions[index].count)/\(lifeArea.dailyActions[index].goalFrequency)")
                                 }
                                 */
                                
                                HStack {
                                    Text(action.name)
                                        .font(.headline)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text("Time period: \(action.timePeriod.rawValue)")
                                    Spacer()
                                    Text("\(action.count)/\(action.goalFrequency)")
                                }
                                .contentShape(Rectangle())
                                
                                .onLongPressGesture {
                                    isEditing = true
                                    editText = action.name
                                }
                            }
                        }
                        .background(isSelected == action ? Color.yellow.opacity(0.3) : Color.clear)
                        .onTapGesture {
                            isSelected = action
                        }

                        /*VStack {
                            DailyActionRow(action: $lifeArea.dailyActions[index], isSelected: $selectedAction)
                        }*/
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedAction = lifeArea.dailyActions[index]
                        }
                        /*.swipeActions(edge: .leading) {
                          Button {
                            print("Bookmark")
                          } label: {
                            Label("Bookmark", systemImage: "bookmark")
                          }.tint(.indigo)
                        }*/

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
                    .listRowSeparator(.visible)
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
                                
                                
                                /*
                                 @Published var name: String
                                 @Published var count = 0
                                 @Published var timePeriod: TimePeriod = .daily
                                 @Published var goalFrequency = 1
                                 @Published var isComplete = false
                                 
                                 */
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
                EditDailyActionView(action: $lifeArea.dailyActions[lifeArea.dailyActions.firstIndex(where: { $0.id == action.id })!])
            }
            .navigationBarTitle(lifeArea.name)
        }
    }
}

struct DailyActionRow: View {
    @Binding var action: DailyAction
    @Binding var isSelected: DailyAction?

    @State private var isEditing = false
    @State private var editText = ""

    var body: some View {
        VStack {
            if isEditing {
                HStack {
                    TextField(action.name, text: $editText) { _ in } onCommit: {
                        action.name = editText
                        isEditing = false
                    }
                    .textFieldStyle(.roundedBorder)
                    
                    Button(action: {
                        isEditing = false
                        editText = ""
                    }) {
                        Text("Cancel")
                    }
                }
            } else {
                
                /*
                 HStack {
                     Text("Time period: \(lifeArea.dailyActions[index].timePeriod.rawValue)")
                     Spacer()
                     Text("\(lifeArea.dailyActions[index].count)/\(lifeArea.dailyActions[index].goalFrequency)")
                 }
                 */
                
                HStack {
                    Text(action.name)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Time period: \(action.timePeriod.rawValue)")
                    Spacer()
                    Text("\(action.count)/\(action.goalFrequency)")
                }
                .contentShape(Rectangle())
                
                .onLongPressGesture {
                    isEditing = true
                    editText = action.name
                }
            }
        }
        .background(isSelected == action ? Color.yellow.opacity(0.3) : Color.clear)
        .onTapGesture {
            isSelected = action
        }
    }
}

struct EditDailyActionView: View {
    @Binding var action: DailyAction
    
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
                    }
                }
            }
            .navigationBarTitle("Edit action")
            .navigationBarItems(trailing: Button("Save") {
                self.action.objectWillChange.send()
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


