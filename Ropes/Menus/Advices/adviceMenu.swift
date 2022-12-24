//
//  advice_menu.swift
//  Ropes
//
//  Created by Илья Бирюк on 9.09.22.
//

import SwiftUI

struct adviceMenu: View {
    let advices = [viewList(view: Shortcuts_advice(), name: "Shortcuts")]
    @State private var selection : UUID? = nil
    var body: some View {
    #if os(macOS)
    NavigationSplitView {
        List(advices, selection: $selection) { advice in
            Text(advice.name)
        }
    } detail: {
        switch selection {
        default: Shortcuts_advice()
        }
    }
    #else
        TabView {
            Shortcuts_advice()
        }.tabViewStyle(.page)
    #endif
    }
}

struct viewList: Identifiable{
    let view: any View
    let name: String
    let id = UUID()
}

struct advice_menu_Previews: PreviewProvider {
    @State static private var tru = true
    static var previews: some View {
        VStack {}.sheet(isPresented: $tru, content: {
            adviceMenu()
        })
    }
}
