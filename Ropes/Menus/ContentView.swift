import SwiftUI
import UserNotifications
import WatchConnectivity
import WidgetKit
import CloudKit
#if os(watchOS)
import WatchKit
#endif

struct ContentView: View {
    let buttonName : LocalizedStringKey = "ADD"
    //db
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity:ToDo.entity(), 
        sortDescriptors: [NSSortDescriptor(keyPath: \ToDo.date, ascending: false)],
        animation: .default
    )
    private var Ropes : FetchedResults<ToDo>
    @FetchRequest(
        entity: FastAnswers.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FastAnswers.name, ascending: false)],
        animation: .default) private var FA : FetchedResults<FastAnswers>
    //db
    @State private var showingSheet = defaults.bool(forKey: "popup")
    @State private var settings = false
    @State private var advice = false
    var body: some View {
        NavigationView{
            List{
                #if os(watchOS)
                    NavigationLink(destination: Adding(Ropes: Ropes, fastAnswers: FA/*[FastAnswers(context: PersistenceController.shared.container.viewContext, name: "Test")]*/), label: { Image(systemName: "plus") })
                #endif
                ForEach(Ropes) {rope in
                    HStack{
                        VStack{
                            HStack{
                                Spacer()
                                Text(rope.name ?? "error")
                                Spacer()
                            }
#if !os(watchOS)
                            HStack {
                                Spacer()
                                Text(dateFormater.string(from: rope.date ?? Date()))
                                Spacer()
                            }
#endif
                        }
                        Button(action: {
                            rope.remove()
                        }, label: {Image(systemName: "trash")})
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                if admin{
                    Button("Notify"){
                        do {
                            try LocalNotficationManager.shared.request(text : "Test", time : 10)
                        } catch {
                            print(error.localizedDescription)
                        }
                        let _ = print("requested by test")
                    }
                    Button("requests") {
                        Task {
                            await LocalNotficationManager.shared.PrintRequests()
                        }
                    }
                }
            }
#if !os(watchOS)
            .navigationTitle("Ropes")
#endif
            .toolbar(content: {
#if os(iOS)
                ToolbarItem(placement: .automatic){
                    Button(action: {
                        advice.toggle()
                    }, label: {
                        Image(systemName: "lightbulb")
                    })
                    .sheet(isPresented: $advice) {
                        advice_menu()
                    }
                }
                ToolbarItem(placement: .bottomBar){
                    Button(buttonName){
                        showingSheet.toggle()
                    }
                    .keyboardShortcut("a")
                    .sheet(isPresented: $showingSheet) {Adding()}
                    
                }
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: { settings.toggle() },
                           label: {Image(systemName: "gear")})
                    .sheet(isPresented: $settings){ settin() }
                }
#endif
            })
        }
#if os(iOS)
        .navigationViewStyle(.stack)
#endif
        .onAppear(){
            Task {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.carPlay,.sound]) { yes, error in
                    if error == nil, yes {
                        print("OFB \(defaults.bool(forKey: "OFB"))")
                        if !defaults.bool(forKey: "OFB") {
                            let privateDB = CKContainer.default().privateCloudDatabase
                            let predicate = NSPredicate(value: true)
                            let query = CKQuery(recordType: "CD_ToDo", predicate: predicate)
                            privateDB.fetch(withQuery: query) { result in
                                print("OFB begin")
                                switch result {
                                case .success((let matchResults, _)):
                                    for (_, res) in matchResults {
                                        switch res {
                                        case .success(let record):
                                            let ID = UUID(uuidString: record.value(forKey: "CD_id") as! String)
                                            let name = record.value(forKey: "CD_name") as! String
                                            do {
                                                try LocalNotficationManager.shared.request(text: name)
                                            } catch {
                                                print("MatchResults failed \(error.localizedDescription)")
                                            }
                                        case .failure(_):
                                            print("MatchResults failed")
                                        }
                                    }
                                    defaults.set(true, forKey: "OFB")
                                case .failure(_):
                                    print("OFB failed")
                                    defaults.set(true, forKey: "OFB")
                                }
                            }
                        }
                    } else {
                        print("OFB \(error?.localizedDescription)")
                    }
                }
                print("haha")
            }
            #if os(watchOS)
            SetUP()
            #endif
        }.onChange(of: scenePhase, perform: {
            print("MAIN scene changed")
            if $0 == .active {
                showingSheet = PopUp().PopUp
            }
        })
    }
    
    private func RemoveRope(index : IndexSet) {
        let RopeToRemove = Ropes[index.first!]
        RopeToRemove.remove(context: viewContext)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

