//
//  Adding.swift
//  RopesForWatch Watch App
//
//  Created by Илья Бирюк on 9.08.22.
//

import Foundation
import SwiftUI
import WatchKit

struct Add: View {
    @Environment(\.managedObjectContext) private var viewContext
    var Ropes : FetchedResults<ToDo>
    var fastAnswers : FetchedResults<FastAnswers>
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    //var Ropes : [ToDo]
    //var fastAnswers : [FastAnswers]
    @State var alert = false
    @State var past = false
    @State var addToFA = false
    @State var time : Bool = false
    @State var CustomRope : String = ""
    @State var remindDate : Date? = nil
    var body: some View {
        //Text("This is an adding view")
        List{
            ForEach(fastAnswers){ answer in
                Button(action: {
                    do {
                        try AddRope(name: answer.name ?? "error")
                        WKInterfaceDevice.current().play(.success)
                        self.presentationMode.wrappedValue.dismiss()
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
            }
            Section("Add your own"){
                TextField("Your rope", text: $CustomRope).onSubmit {
                    do {
                        try AddRope(name: CustomRope)
                        WKInterfaceDevice.current().play(.success)
                        self.presentationMode.wrappedValue.dismiss()
                    } catch NotificationErrors.missingTime {
                        past.toggle()
                    } catch AddingErrors.ThisNameIsExciting {
                        alert.toggle()
                    } catch {
                        print("what the heck \(error)")
                    }
                }
            }
        }
        .task {
            try? await LocalNotficationManager.shared.requestAuthorization(Options: [.sound,.alert,.badge,.carPlay])
        }
    }
    @MainActor private func AddRope(name : String, time : Double = defaults.double(forKey: "time")) throws {
        if Ropes.contains(where: {$0.name == name}) {throw AddingErrors.ThisNameIsExciting}
        else {
            try ToDo(context: viewContext, name: name)
        }
    }
}

/*struct Adding_Previews: PreviewProvider {
    static var previews: some View {
        Adding(Ropes: [], fastAnswers: [FastAnswers(context: PersistenceController.shared.container.viewContext, name: "Test")])
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}*/
