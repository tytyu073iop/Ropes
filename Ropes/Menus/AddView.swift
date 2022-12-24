import SwiftUI
#if canImport(AppIntents)
import AppIntents
#endif

struct AddView: View {
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
        animation: .default) private var fastAnswers : FetchedResults<FastAnswers>
    //db
    @ObservedObject var lnManager = LocalNotficationManager.shared
    @State var alert = false
    @State var noNotfication = false
    @State var past = false
    @State var addToFA = false
    @State var time : Bool = false
    @State var CustomRope : String = ""
    @State var remindDate : Date? = nil
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            
            //MARK: normal design
            List{
                ForEach(fastAnswers){ answer in
                    Button(action: {
                        do {
                            try AddRope(name: answer.name ?? "error", date : remindDate)
                        } catch NotificationErrors.missingTime {
                            past.toggle()
                        } catch AddingErrors.ThisNameIsExciting {
                            alert.toggle()
                        } catch {
                            print("what the heck \(error)")
                        }
                    },
                           label: {
                        HStack{
                            Spacer()
                            Text(answer.name ?? "error")
                            Spacer()
                        }
                    }).alert("OOPS", isPresented: $alert, actions: {
                        Button("ok", role : .cancel){}
                    }, message : {Text("Try another name or complete other rope with that name")})
                    .alert("Missing time", isPresented: $past, actions : {
                        Button("ok", role: .cancel){}
                    }, message : {
                        Text("You cannot set reminder at the past")
                    })
                    .alert("Notfications aren't allowed", isPresented: $noNotfication, actions: {
                        Button("Settings") {
                            //openSettings()
                        }
                        Button("ok", role: .cancel) {}
                    }, message: {
                        Text("You aren't allowed nofications")
                    })
                }
                Section("Add your own"){
                    TextField("Your rope", text: $CustomRope).onSubmit {
                        do {
                            try AddRope(name: CustomRope, date : remindDate)
                            if (addToFA) {
                                print("ya")
                                try FastAnswers(context : viewContext, name : CustomRope)
                            }
                        } catch NotificationErrors.missingTime {
                            past.toggle()
                        } catch AddingErrors.ThisNameIsExciting {
                            alert.toggle()
                        } catch NotificationErrors.noPermition {
                            noNotfication.toggle()
                            print("no notfication")
                        } catch {
                            print("what the heck \(error)")
                        }
                    }
                    if (CustomRope != "") {
                        withAnimation {
                            Toggle(isOn: $addToFA) {
                                Text("add to fast Answers")
                            }
                        }
                    }
                }
                if (beta) {
                    Section() {
                        Toggle(isOn: $time) {
                            Text("Set a remind time")
                        }
                        if (time){
                            //DatePicker("remind in", selection: Binding<Date>(get: {self.remindDate ?? Date.now}, set: {self.remindDate = $0}), displayedComponents: [.hourAndMinute])
                        }
                    }
                }
            }
        }
        .onAppear() {
        print(scenePhase)
    }
    .task {
        try? await LocalNotficationManager.shared.requestAuthorization(Options: [.sound,.alert,.badge,.carPlay])
    }
    .onChange(of: scenePhase) {
        print(scenePhase == .active)
        if $0 == .active {
            print("a")
            Task {
                try await lnManager.requestAuthorization()
                print("haha")
            }
        }
    }
    .onChange(of: time) {
        if !$0 {
            remindDate = nil
        }
    }
    }
    private func AddRope(name : String, time : Double = defaults.double(forKey: "time"), date : Date? = nil) throws {
        #if canImport(AppIntents)
        if #available(iOS 16.0, macOS 13.0, watchOS 9.0, *) {
            Task {
                try await IntentDonationManager.shared.donate(intent: AddTask(), result: .result(value: name, dialog: "Task name was created"))
            }
        }
        #endif
        if (date == nil) {
            try ToDo(context: viewContext, name: name)
        } else {
            try ToDo(context: viewContext, name: name, time: date!)
        }
        dismiss()
    }
#if os(iOS)
func openSettings() {
    if let url = URL(string: UIApplication.openSettingsURLString) {
        if UIApplication.shared.canOpenURL(url) {
            Task {
                await UIApplication.shared.open(url)
            }
        }
    }
}
#endif
}

struct MyPreviewProvider_Previews: PreviewProvider {
    @State static private var tu = true
    static var previews: some View {
        VStack {
            
        }.sheet(isPresented: $tu) {
            AddView()
        }
    }
}



