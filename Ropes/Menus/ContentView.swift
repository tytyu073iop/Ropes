import SwiftUI
import UserNotifications

struct ContentView: View {
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
    @State private var showingSheet = false
    @State private var settings = false
    var body: some View {
        NavigationView{
            List{
                #if os(watchOS)
                    NavigationLink(destination: Adding(Ropes: Ropes, fastAnswers: FA/*[FastAnswers(context: PersistenceController.shared.container.viewContext, name: "Test")]*/), label: { Image(systemName: "plus") })
                #endif
                ForEach(Ropes) {rope in
                    VStack{
                        HStack{
                            Spacer()
                            Text(rope.name)
                            Spacer()
                        }
                        #if !os(watchOS)
                        HStack {
                            Spacer()
                            Text(dateFormater.string(from: rope.date))
                            Spacer()
                        }
                        #endif
                    }
                }.onDelete(perform: {
                    RemoveRope(index: $0)
                })
                if admin{
                    Button("Notify"){
                        LocalNotficationManager.shared.request(text : "Test", time : 10)
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
            .toolbar {
                ToolbarItem(placement: .automatic){
#if os(iOS)
                    EditButton()
#endif
                }
                #if os(iOS)
                ToolbarItem(placement: .bottomBar){
                    Button("ADD"){
                        showingSheet.toggle()
                    }
                    .sheet(isPresented: $showingSheet) {Adding(Ropes : Ropes, fastAnswers: FA)}
                }
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: { settings.toggle() },
                           label: {Image(systemName: "gear")})
                        .sheet(isPresented: $settings){ settin() }
                }
                #endif
            }
        }
        #if os(iOS)
        .navigationViewStyle(.stack)
        #endif
        .onAppear(){
            self.UserSetUp()
            if (defaults.bool(forKey: "OFB") == false) {
                defaults.set(false, forKey: "popup")
                defaults.set(true, forKey: "OFB")
                print("ofb ended")
            }
            if (defaults.bool(forKey: "popup") == true) {
                showingSheet.toggle()
            }
        }.onChange(of: scenePhase, perform: {_ in print("MAIN scene changed")})
    }
    private func UserSetUp() {
        dateFormater.dateStyle = .short
        dateFormater.timeStyle = .short
        print("Begining set-up")
        if defaults.double(forKey: "time") == 0.0 { defaults.set(Double(10), forKey: "time")}
        print("set-up completed")
    }
    private func RemoveRope(index : IndexSet) {
        let RopeToRemove = Ropes[index.first!]
        RopeToRemove.remove(context: viewContext)
    }
}




