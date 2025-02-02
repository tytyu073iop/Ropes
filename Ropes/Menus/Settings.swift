import SwiftUI
import UserNotifications

struct settin: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @FetchRequest(
        entity: FastAnswers.entity(), 
        sortDescriptors: [],
        animation: .default)
    private var FA : FetchedResults<FastAnswers>
    @State var alert = false
    @ObservedObject var time = Time()
    @ObservedObject var popup = PopUp()
    @ObservedObject var swap = Swap()
    @State var a : String = ""
    var body: some View {
        NavigationStack{
        List{
            Section("Fast answers"){
                    ForEach(FA){ answer in 
                        HStack{
                            Text(answer.name ?? "error")
                            #if os(macOS)
                            Button(action: {
                                viewContext.deleteWithSave(answer)
                            }, label: {Image(systemName: "trash")})
                            .buttonStyle(PlainButtonStyle())
                            #endif
                        }.transition(.move(edge: .top))
                }.onDelete(perform: {
                    RemoveFA(index: $0)
                })
                    TextField("Enter something", text: $a).onSubmit {
                        withAnimation { 
                                try! FastAnswers(name: a)
                                a = ""
                            }
                    }.alert("OOPS", isPresented: $alert, actions: {
                        Button("ok", role : .cancel){}
                    }, message : {Text("You have the same fast answer")})
            }
            if admin{
            Section("admin settings"){
                Button("Disable all notifications"){
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    print("disabled")
                    print(time.time)
            }
            }
            }
                Section("Time"){
                    Picker("chose the time", selection: $time.time){
                        ForEach(times, id: \.self){
                            Text("\(Int($0)) minutes").tag($0)
                        }
                    }
                }
            #if os(iOS)
                .pickerStyle(.wheel)
            #else
                .pickerStyle(.automatic)
            #endif
            Section("Other") {
                Toggle(isOn: $swap.Swap) {
                    Text("Show ropes in widjets like in the app order")
                }
            }
        }
        .navigationTitle("settings")
            #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
            #endif
        .toolbar{
            #if os(iOS)
            ToolbarItem(placement: .navigationBarLeading){
            EditButton()
            }
            ToolbarItem(placement: .confirmationAction){
                Button("ready"){
                    dismiss()
                    print(scenePhase)
                }
            }
            #endif
        }
        }
    }
    private func AddFA(name : String){
        if FA.contains(where: {$0.name == name}) {alert.toggle()}
        else {
            try! FastAnswers(name: name)
        }
    }
    private func RemoveFA(index : IndexSet) {
        let FAToRemove = FA[index.first!]
        viewContext.deleteWithSave(FAToRemove)
    }
}

struct MyPreviewProvi: PreviewProvider {
    static var previews: some View {
        settin()
    }
}
