import SwiftUI

struct ContentView: View {
    @State var lifeAreas: [LifeArea] = [LifeArea(name: "Fitness"), LifeArea(name: "Health"), LifeArea(name: "Learning")]
    @State var newLifeAreaName: String = ""
    @State var showAddLifeArea = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(lifeAreas) { lifeArea in
                        NavigationLink(destination: DailyActionView(lifeArea: lifeArea)) {
                            Text(lifeArea.name)
                                .foregroundColor(.white)
                                .padding()
                                .background(lifeArea.color)
                                .cornerRadius(10)
                        }
                    }
                    .onDelete(perform: deleteLifeArea)
                }
                .padding()

                Button(action: {
                    self.showAddLifeArea = true
                }) {
                    Text("Add New Life Area")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .navigationBarTitle("My Life Areas")
            .navigationBarItems(trailing: EditButton())
            .sheet(isPresented: $showAddLifeArea) {
                AddLifeAreaView(lifeAreaName: $newLifeAreaName, addLifeArea: { lifeAreaName in
                    self.addLifeArea(name: lifeAreaName)
                }, onCancel: { self.showAddLifeArea = false })
            }
        }
    }

    func addLifeArea(name: String) {
        let newLifeArea = LifeArea(name: name)
        self.lifeAreas.append(newLifeArea)
        self.newLifeAreaName = ""
        self.showAddLifeArea = false
    }
    
    func deleteLifeArea(at offsets: IndexSet) {
        self.lifeAreas.remove(atOffsets: offsets)
    }
}

class LifeArea: ObservableObject, Identifiable {
    var id = UUID()
    @Published var name: String
    @Published var dailyActions: [DailyAction]
    @Published var color: Color

    init(name: String, dailyActions: [DailyAction] = []) {
        self.name = name
        self.dailyActions = dailyActions
        self.color = Color.random
    }
}

extension Color {
    static var random: Color {
        return Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
    }
}

