import SwiftUI
import UserNotifications
import WatchConnectivity

struct settin: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @FetchRequest(
        entity: FastAnswers.entity(), 
        sortDescriptors: [NSSortDescriptor(keyPath: \FastAnswers.name, ascending: false)],
        animation: .default) 
    private var FA : FetchedResults<FastAnswers>
    @State var alert = false
    @ObservedObject var time = Time()
    @ObservedObject var popup = PopUp()
    @State var a : String = ""
    var body: some View {
        NavigationView{
        Form{
            Section("Fast answers"){
                List{
                    ForEach(FA){ answer in 
                        HStack{
                            Text(answer.name ?? "error")
                        }.transition(.move(edge: .top))
                }.onDelete(perform: {
                    RemoveFA(index: $0)
                })
                    TextField("Enter something", text: $a).onSubmit {
                        withAnimation { 
                                AddFA(name: a)
                                a = ""
                            }
                    }.alert("OOPS", isPresented: $alert, actions: {
                        Button("ok", role : .cancel){}
                    }, message : {Text("Try another name or complete other rope with that name")})
                }
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
                Toggle(isOn: $popup.PopUp) {
                    Text("Showup an adding view on start")
                }
                if WCSession.isSupported() {
                    /*Button("Sync with watch") {
                        Task {
                            // Create a fetch request for a specific Entity type
                            let fetchRequest2 = FastAnswers.fetchRequest()
                            
                            // Get a reference to a NSManagedObjectContext
                            let context2 = PersistenceController.shared.container.viewContext
                            
                            // Fetch all objects of one Entity type
                            let objects2 = try! context2.fetch(fetchRequest2)
                            print(objects2)
                            var fastAnswers : [FastAnswers] = objects2.compactMap { object in
                                object as? FastAnswers
                            }
                            // Create a fetch request for a specific Entity type
                            let fetchRequest = ToDo.fetchRequest()
                            
                            // Get a reference to a NSManagedObjectContext
                            let context = PersistenceController.shared.container.viewContext
                            
                            // Fetch all objects of one Entity type
                            let objects = try! context.fetch(fetchRequest)
                            print(objects)
                            var toDos : [ToDo] = objects.compactMap { object in
                                object as? ToDo
                            }
                            
                            var syncObjects : [String : [[String : Any]]] = [:]
                            syncObjects["FastAnswers"] = []
                            for fastAnswer in fastAnswers {
                                syncObjects["FastAnswers"]!.append(["Name" : fastAnswer.name, "ID" : fastAnswer.id?.uuidString])
                            }
                            syncObjects["Ropes"] = []
                            for toDo in toDos {
                                syncObjects["Ropes"]!.append(["Name" : toDo.name, "ID" : toDo.id?.uuidString, "Date" : toDo.date])
                            }
                            print(syncObjects)
                            //await WC.shared.send(syncObjects, RequiresReply: true)
                        }
                    }*/
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
            #endif
            ToolbarItem(placement: .confirmationAction){
                Button("ready"){
                    dismiss()
                    print(scenePhase)
                }
            }
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
        FAToRemove.remove()
    }
}

struct MyPreviewProvi: PreviewProvider {
    static var previews: some View {
        settin()
    }
}
