import SwiftUI
import UserNotifications
#if canImport(watchConnectivity)
import WatchConnectivity
#endif
import WidgetKit
import CloudKit
#if os(watchOS)
import WatchKit
#endif

struct ContentView: View {
    let buttonName : LocalizedStringKey = "ADD"
    #if !os(watchOS)
    @Environment(\.openWindow) private var openWindow
    #endif
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
        NavigationStack{
            List{
                #if os(watchOS)
                NavigationLink(destination: AddView(), label: { Image(systemName: "plus") })
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
                    Button("DELETE ALL DATA") {
                        for fa in FastAnswers.fetch() {
                            fa.remove()
                        }
                        for todo in ToDo.fetch() {
                            todo.remove()
                        }
                        defaults.set(5, forKey: "time")
                        defaults.set(false, forKey: "popup")
                    }
                }
            }
#if !os(watchOS)
            .navigationTitle("Ropes")
#endif
            .toolbar(content: {
                #if !os(watchOS)
                if admin {
                    ToolbarItem(placement: .automatic){
                        Button(action: {
                        #if os(macOS)
                            openWindow(id: "Advice")
                        #else
                            advice.toggle()
                        #endif
                        }, label: {
                            Image(systemName: "lightbulb")
                        })
                        .sheet(isPresented: $advice) {
                            adviceMenu()
                        }
                    }
                }
                #if os(iOS)
                ToolbarItem(placement: .bottomBar){
                    Button(buttonName){
                        #if os(macOS)
                        openWindow(id: "Adding")
                        #else
                        showingSheet.toggle()
                        #endif
                    }
                    .keyboardShortcut("a")
                    .sheet(isPresented: $showingSheet) { AddView() }
                }
                #else
                ToolbarItem(placement: .automatic){
                    Button(buttonName){
                        #if os(macOS)
                        openWindow(id: "Adding")
                        #else
                        showingSheet.toggle()
                        #endif
                    }
                    .keyboardShortcut("a")
                    .sheet(isPresented: $showingSheet) { AddView() }
                }
                #endif
                #endif
                #if os(iOS)
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: { settings.toggle() },
                           label: {Image(systemName: "gear")})
                    .sheet(isPresented: $settings){ settin() }
                }
                #endif
            })
        }
        .onAppear(){
            Task {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.carPlay,.sound]) { yes, error in
                    if error == nil, yes {
                        print("OFB \(defaults.bool(forKey: "OFB"))")
                        if defaults.bool(forKey: "OFB") {
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
                                case .failure(_):
                                    print("OFB failed")
                                }
                                defaults.set(true, forKey: "OFB")
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

