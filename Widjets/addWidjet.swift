//
//  AddWidjet.swift
//  WidjetsExtension
//
//  Created by Илья Бирюк on 7.08.23.
//

import Foundation
import SwiftUI
import WidgetKit
let context = PersistenceController.shared.container.newBackgroundContext()
func getFASs() -> [String] {
    let request = FastAnswers.fetchRequest()
    request.fetchLimit = 4
    request.propertiesToFetch = ["name"]
    request.resultType = .dictionaryResultType
    var dictionaries = try! context.fetch(request) as [NSDictionary]
    var names : [String] = dictionaries.map { dictionar in
        return dictionar["name"] as! String
    }
    return names
}
struct AddWidjet: Widget {
    let kind: String = "CommonAddRopesWidjet"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AddProvider(), content: {AddWidjetView(entry: $0)})
            .configurationDisplayName("Fast Answers")
            .description("Create ropes quicly")
            .supportedFamilies([.systemSmall])
    }
}
struct AddWidjetView: View {
    @Environment(\.colorScheme) var colorScheme
    let entry: AddEntry
    var body: some View {
        ForEach(entry.FAs, id: \.self) { FA in
            Button(intent: AddRopeShortcut(Task: FA), label: {
                HStack{
                    Spacer()
                    Text(FA)
                    Spacer()
                }
            })
            .buttonStyle(AddButtonConfig())
        }
        .containerBackground(colorScheme == .dark ? .black : .white , for: .widget)
    }
}
struct AddProvider: TimelineProvider {
    var FAs = ["test1", "test2", "test3", "1"]
    
    func placeholder(in context: Context) -> AddEntry {
        AddEntry(FAs: FAs)
    }
    func getSnapshot(in context: Context, completion: @escaping (AddEntry) -> ()) {
        let context = PersistenceController.shared.container.viewContext
        // Create a fetch request for a specific Entity type
        
        completion(AddEntry(FAs: FAs))
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries : [AddEntry] = []
        let entry = AddEntry(FAs: FAs)
        entries.append(entry)
        completion(Timeline(entries: entries, policy: .never))
    }
}
struct AddEntry: TimelineEntry {
    let date: Date
    var FAs : [String]
    init(date: Date = Date(), FAs: [String]) {
        self.date = date
        self.FAs = FAs
    }
}
#Preview(as: .systemSmall, widget: {AddWidjet()}, timeline: {
    AddEntry(FAs: ["hey","hello", "hi", "999"])
})
