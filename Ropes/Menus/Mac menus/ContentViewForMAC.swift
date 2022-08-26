//
//  ContentViewForMAC.swift
//  Ropes
//
//  Created by Илья Бирюк on 11.08.22.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @Environment(\.openURL) var openURL
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
            List{
                ForEach(Ropes) {rope in
                    HStack {
                        VStack{
                            HStack{
                                Spacer()
                                Text(rope.name)
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                Text(dateFormater.string(from: rope.date))
                                Spacer()
                            }
                        }
                        HStack {
                            //FIXME: termination on delete
                            Button(action: {rope.remove()}, label: {Image(systemName: "trash")})
                        }
                    }
                }
                if admin{
                    Button("Notify"){
                        try! LocalNotficationManager.shared.request(text : "Test", time : 10)
                        let _ = print("requested by test")
                    }
                    Button("requests") {
                        Task {
                            await LocalNotficationManager.shared.PrintRequests()
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        if let url = URL(string: "Ropes://Adding") {
                            openURL(url)
                        }
                    }, label: {Image(systemName: "plus")})
                    .keyboardShortcut("a")
                }
            }
        .onAppear(){
            #if DEBUG
            Task {
                do {
                    try await LocalNotficationManager.shared.requestAuthorization()
                } catch {
                    print("blat")
                }
                
            }
            #endif
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




