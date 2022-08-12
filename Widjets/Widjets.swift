//
//  Widjets.swift
//  Widjets
//
//  Created by Илья Бирюк on 12.08.22.
//

import WidgetKit
import SwiftUI

var names = ["ilya","vanya","rodion"]

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), names: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), names: [])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let entryDate = currentDate
        let entry = SimpleEntry(date: entryDate, names: names)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    var names: [String]
}

struct WidjetsEntryView : View {
    var entry: Provider.Entry

    @ViewBuilder
    var body: some View {
        VStack {
            ForEach(entry.names, id: \.self) { name in
                HStack{
                    Spacer()
                    Text(name)
                    Spacer()
                }
            }
            HStack{
                Image(systemName: "plus")
            }
        }
    }
}

@main
struct Widjets: Widget {
    let kind: String = "Tasks"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidjetsEntryView(entry: entry)
        }
        .configurationDisplayName("Tasks")
        .description("All your tasks")
    }
}

struct Widjets_Previews: PreviewProvider {
    static var previews: some View {
        WidjetsEntryView(entry: SimpleEntry(date: Date(), names: names))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
