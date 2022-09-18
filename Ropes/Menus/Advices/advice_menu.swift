//
//  advice_menu.swift
//  Ropes
//
//  Created by Илья Бирюк on 9.09.22.
//

import SwiftUI

struct advice_menu: View {
    var body: some View {
        TabView {
            Shortcuts_advice()
        }.tabViewStyle(.page)
    }
}

struct advice_menu_Previews: PreviewProvider {
    @State static private var tru = true
    static var previews: some View {
        VStack {}.sheet(isPresented: $tru, content: {
            
            advice_menu()
        })
    }
}
