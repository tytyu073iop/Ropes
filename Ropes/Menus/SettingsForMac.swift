//
//  SettingsForMac.swift
//  Ropes
//
//  Created by Илья Бирюк on 11.08.22.
//

import SwiftUI
import UserNotifications

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
    var times : [Double] = [5, 10, 15, 20, 30]
    @ObservedObject var Time = time()
    @ObservedObject var popup = PopUp()
    @State var a : String = ""
    var body: some View {
        List{
            Section("Fast answers"){
                    ForEach(FA){ answer in
                        HStack{
                            Text(answer.name)
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
            if admin{
            Section("admin settings"){
                Button("Disable all notifications"){
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    print("disabled")
                    print(Time.time)
            }
            }
            }
                Section("Time"){
                    Picker("chose the time", selection: $Time.time){
                        ForEach(times, id: \.self){
                            Text("\(Int($0)) minutes").tag($0)
                        }
                    }
                }
            .pickerStyle(.automatic)
            Section("Other") {
                Toggle(isOn: $popup.PopUp) {
                    Text("Showup an adding view on start")
                }
            }
        }
        .navigationTitle("settings")
    }
    private func AddFA(name : String){
        if FA.contains(where: {$0.name == name}) {alert.toggle()}
        else {
            let NewFA = FastAnswers(context: viewContext)
            NewFA.name = name
            NewFA.id = UUID()
            PersistenceController.save()
        }
    }
    private func RemoveFA(index : IndexSet) {
        let FAToRemove = FA[index.first!]
        FAToRemove.remove()
    }
}
