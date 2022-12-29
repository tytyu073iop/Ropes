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
    private var padding = 0
    fileprivate func iOS16Text() -> Text {
        return Text("Oh. You have to update to iOS 16 or newer", comment: "error")
            .foregroundColor(Color(.gray))
    }
    
    var body: some View {
        VStack {
            #if os(macOS)
            Text("You can use shortcuts app and siri to rope. Look at shortcuts app", comment: "ropes is an app")
            #else
            Text("You can use shortcuts app to rope", comment: "ropes is an app")
                .padding(EdgeInsets(top: CGFloat(padding), leading: CGFloat(padding), bottom: CGFloat(padding), trailing: CGFloat(padding)))
                .multilineTextAlignment(.center)
            Text("or")
                SiriTipView(intent: AddCustomTask())
                    .frame(width: 100)
            Text("or to show ropes.", comment: "ropes is an app")
                .padding(EdgeInsets(top: CGFloat(padding), leading: CGFloat(padding), bottom: CGFloat(padding), trailing: CGFloat(padding)))
                SiriTipView(intent: ShowTasks())
                    .frame(width: 100)
            Text("You can even delete them")
                SiriTipView(intent: RemoveRope())
                    .frame(width: 100)
                ShortcutsLink()
                    .padding(10)
            #endif
        }
    }
}

struct Shortcuts_advice_Previews: PreviewProvider {
    @State static private var tru = true
    static var previews: some View {
        VStack {}.sheet(isPresented: $tru) {
            Shortcuts_advice().environment(\.locale, .init(identifier: "ru"))
        }
    }
}
