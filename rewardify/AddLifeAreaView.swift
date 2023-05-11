import SwiftUI

struct AddLifeAreaView: View {
    @Binding var lifeAreaName: String
    var addLifeArea: (String) -> Void
    var onCancel: () -> Void

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter Life Area Name", text: $lifeAreaName)
                    .padding()

                HStack {
                    Button(action: {
                        self.addLifeArea(lifeAreaName)
                    }) {
                        Text("Save")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)

                    Button(action: {
                        self.onCancel()
                    }) {
                        Text("Cancel")
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
            }
            .navigationBarTitle("Add New Life Area")
        }
    }
}

struct LifeAreaView: View {
    var lifeArea: LifeArea

    var body: some View {
        Text(lifeArea.name)
            .navigationBarTitle(lifeArea.name)
    }
}
