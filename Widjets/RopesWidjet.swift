//
//  Widjets.swift
//  Widjets
//
//  Created by Илья Бирюк on 12.08.22.
//

import WidgetKit
import SwiftUI
import CoreData

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        ExampleEntry
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let context = PersistenceController.shared.container.viewContext
        // Create a fetch request for a specific Entity type
        var toDos = ToDo.fetch()
        if defaults.bool(forKey: "swap") {
            toDos.reverse()
        }
        print(toDos)
        let names : [String] = toDos.compactMap { toDo in
            return toDo.name
        }
        completion(SimpleEntry(names: names))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        print("widjetbegin")
        var entries: [SimpleEntry] = []
        
        let context = PersistenceController.shared.container.viewContext
        // Create a fetch request for a specific Entity type
        var toDos = ToDo.fetch()
        if defaults.bool(forKey: "swap") {
            toDos.reverse()
        }
        print(toDos)
        let names : [String] = toDos.compactMap { toDo in
            return toDo.name
        }
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let entryDate = currentDate
        let entry = SimpleEntry(date: entryDate, names: names)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    var names: [String]
    init(date: Date = Date(), names: [String]) {
        self.date = date
        self.names = names
    }
}

let ExampleEntry = SimpleEntry(date: Date(), names: ["wash","clean","dog"])

struct WidjetsEntryView : View {
    var entry: Provider.Entry
    var example: String = "test"
    @Environment(\.widgetFamily) var widjetFamily
    @ViewBuilder
    var body: some View {
        switch widjetFamily {
        case .systemSmall:
            if entry.names.isEmpty {
                Text("There's no ropes")
            }
            VStack {
                ForEach(entry.names.prefix(4), id: \.self) { name in
                    HStack{
                        Spacer()
                        Text(name)
                        Spacer()
                    }
                    if name != entry.names[entry.names.count > 3 ? 3 : entry.names.count - 1] {
                        Divider()
                    }
                }
            }
            #if !os(macOS)
        case .accessoryRectangular:
        if entry.names.isEmpty {
            Text("There's no ropes")
                .widgetAccentable()
        } else {
            VStack {
                if entry.names.count < 3 {
                    HStack {
                        Text("Your ropes:").bold()
                        Spacer()
                    }
                }
                ForEach(entry.names.prefix(3), id: \.self) { name in
                    HStack{
                        Text(name)
                        Spacer()
                    }
                }
            }
            .widgetAccentable()
        }
        case .accessoryCircular:
            ZStack {
                Circle()
                    .stroke(Color.gray,lineWidth: 10)
                Text("\(entry.names.count)").font(.system(size: 30))
            }
            .widgetAccentable()
            .widgetLabel(entry.names.first ?? "")
        case .accessoryInline:
            Text(entry.names.first ?? "You have no ropes")
                .widgetAccentable()
            #endif
            #if os(watchOS)
        case .accessoryCorner:
            ZStack {
                Text("\(entry.names.count)").font(.system(size: 30))
            }
            .widgetAccentable()
            .widgetLabel(entry.names.first ?? "")
            #endif
        default: Text("unknown type")
        }
    }
}



@main struct RopesWidjets: WidgetBundle{
    @WidgetBundleBuilder var body: some Widget {
        RopesWidjet()
    }
}

struct RopesWidjet: Widget {
    let kind: String = "CommonRopesWidjet"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidjetsEntryView(entry: entry)
        }
        .configurationDisplayName("Tasks")
        .description("All your tasks")
        #if os(iOS)
        .supportedFamilies([.systemSmall, .accessoryCircular, .accessoryRectangular, .accessoryInline])
        #endif
        #if os(macOS)
        .supportedFamilies([.systemSmall])
        #endif
        #if os(watchOS)
        .supportedFamilies([.accessoryInline, .accessoryRectangular, .accessoryCircular, .accessoryCorner])
        #endif
    }
}



struct Widjets_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            #if os(watchOS)
            WidjetsEntryView(entry: SimpleEntry(date: Date(), names: ["vasya","petya","fif","kik"])).previewContext(WidgetPreviewContext(family: .accessoryCorner))
            #endif
        }
    }
}
