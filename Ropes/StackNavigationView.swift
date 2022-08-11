//
//  StackNavigationView.swift
//  Ropes
//
//  Created by Илья Бирюк on 11.08.22.
//

import Foundation
import SwiftUI

struct StackNavigationView<RootContent>: View where RootContent: View {
    @Binding var currentSubview: AnyView
    @Binding var showingSubview: Bool
    let rootView: () -> RootContent
    //struct
    private struct StackNavigationSubview<Content>: View where Content: View {
        @Binding var isVisible: Bool
        let contentView: () -> Content
        var body: some View {
            VStack {
                contentView() // subview
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.3)) {
                            isVisible = false
                        }
                    }, label: {
                        Label("back", systemImage: "chevron.left")
                    })
                }
            }
        }
    }
    //struct
    var body: some View {
        VStack {
            if !showingSubview {
                rootView()
            } else {
                StackNavigationSubview(isVisible: $showingSubview) {
                    currentSubview
            }
            .transition(.move(edge: .trailing))
            }
        }
    }
    init(currentSubview: Binding<AnyView>, showingSubview: Binding<Bool>,
    @ViewBuilder rootView: @escaping () -> RootContent) {
            self._currentSubview = currentSubview
            self._showingSubview = showingSubview
            self.rootView = rootView
        }
}
