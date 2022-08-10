//
//  Adding.swift
//  RopesForWatch Watch App
//
//  Created by Илья Бирюк on 9.08.22.
//

import Foundation
import SwiftUI

struct Adding: View {
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
                        try AddRope(name: answer.name, date : remindDate)
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
                        Text(answer.name)
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
                        try AddRope(name: CustomRope, date : remindDate)
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
    }
    private func AddRope(name : String, time : Double = defaults.double(forKey: "time"), date : Date? = nil) throws {
        if Ropes.contains(where: {$0.name == name}) {throw AddingErrors.ThisNameIsExciting}
        else {
            if (date == nil) {
                ToDo(context: viewContext, name: name)
            } else {
                try ToDo(context: viewContext, name: name, time: date!)
            }
        }
    }
}

/*struct Adding_Previews: PreviewProvider {
    static var previews: some View {
        Adding(Ropes: [], fastAnswers: [FastAnswers(context: PersistenceController.shared.container.viewContext, name: "Test")])
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}*/
