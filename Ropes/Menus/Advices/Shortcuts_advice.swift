//
//  Shortcuts_advice.swift
//  Ropes
//
//  Created by Илья Бирюк on 9.09.22.
//

import SwiftUI
#if canImport(AppIntents)
import AppIntents
#endif

struct Shortcuts_advice: View {
    private var padding = 5
    fileprivate func iOS16Text() -> Text {
        return Text("Oh. You have to update to iOS 16 or newer", comment: "error")
            .foregroundColor(Color(.gray))
    }
    
    var body: some View {
        VStack {
            Text("You can use shortcuts app to rope", comment: "ropes is an app")
                .multilineTextAlignment(.center)
                .padding(EdgeInsets(top: CGFloat(padding), leading: CGFloat(padding), bottom: CGFloat(padding), trailing: CGFloat(padding)))
            #if canImport(AppIntents)
            if #available(iOS 16.0, *) {
                SiriTipView(intent: AddTask())
                    .frame(width: 100)
            } else {
                iOS16Text()
            }
            #else
                iOS16Text()
            #endif
            Text("or")
            #if canImport(AppIntents)
            if #available(iOS 16.0, *) {
                SiriTipView(intent: AddCustomTask())
                    .frame(width: 100)
            } else {
                iOS16Text()
            }
            #else
            iOS16Text()
            #endif
            Text("or to show ropes.", comment: "ropes is an app")
                .padding(EdgeInsets(top: CGFloat(padding), leading: CGFloat(padding), bottom: CGFloat(padding), trailing: CGFloat(padding)))
            #if canImport(AppIntents)
            if #available(iOS 16.0, *) {
                SiriTipView(intent: ShowTasks())
                    .frame(width: 100)
            } else {
                iOS16Text()
            }
            #else
                iOS16Text()
            #endif
            Text("You can even delete them")
            #if canImport(AppIntents)
            if #available(iOS 16.0, *) {
                SiriTipView(intent: RemoveRope())
                    .frame(width: 100)
            } else {
                iOS16Text()
            }
            #else
                iOS16Text()
            #endif
        }
    }
}

struct Shortcuts_advice_Previews: PreviewProvider {
    @State static private var tru = true
    static var previews: some View {
        VStack {}.sheet(isPresented: $tru) {
            Shortcuts_advice().environment(\.locale, .init(identifier: "ru"))
        }.previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
            .previewDisplayName("iPhone 14 pro max")
    }
}
