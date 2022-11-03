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
        completion(ExampleEntry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        print("widjetbegin")
        var entries: [SimpleEntry] = []
        
        let context = PersistenceController.shared.container.viewContext
        // Create a fetch request for a specific Entity type
        let toDos = ToDo.fetch()
        print(toDos)
        let names : [String] = toDos.compactMap { toDo in
            return toDo.name
        }
        #if DEBUG
        #endif
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
    @Environment(\.widgetFamily) var widjetFamily
    @ViewBuilder
    var body: some View {
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
    }
}

struct RecLockWid : View {
    var entry: Provider.Entry
    
    @ViewBuilder
    var body: some View {
        if entry.names.isEmpty {
            Text("There's no ropes")
                .widgetAccentable()
        } else {
            VStack {
                HStack {
                    Text("Your ropes:").bold()
                    Spacer()
                }
                ForEach(entry.names.prefix(2), id: \.self) { name in
                    HStack{
                        Text(name)
                        Spacer()
                    }
                }
            }
            .widgetAccentable()
        }
    }
}

struct CircleWidjetView : View {
    var entry : Provider.Entry
    
    @ViewBuilder var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray,lineWidth: 10)
            Text("\(entry.names.count)").font(.system(size: 30))
        }
        .widgetAccentable()
    }
}

struct CornerWidjetView : View {
    var entry : Provider.Entry
    
    @ViewBuilder var body: some View {
        ZStack {
            Text("\(entry.names.count)").font(.system(size: 30))
        }
        .widgetAccentable()
    }
}


struct InLineWidjetView : View {
    var entry : Provider.Entry
    
    @ViewBuilder var body: some View {
        Text(entry.names.first ?? "You have no ropes")
            .widgetAccentable()
    }
}

@main struct RopesWidjets: WidgetBundle{
    @WidgetBundleBuilder var body: some Widget {
        #if os(iOS)
        RopesWidjet()
        #endif
            LockRectangleWidjet()
            LockCircleWidjet()
            LockInLineWidjet()
            #if os(watchOS)
            CornerWidjet()
            #endif
    }
}

@available(iOS 16.0,watchOS 9.0, *) struct LockInLineWidjet: Widget {
    let kind: String = "InLineRopesWidjet"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            InLineWidjetView(entry: entry)
        }
        .configurationDisplayName("Tasks")
        .description("All your tasks")
        .supportedFamilies([.accessoryInline])
    }
}

@available(iOS 16.0,watchOS 9.0, *) struct LockRectangleWidjet: Widget {
    let kind: String = "RectangleRopesWidjet"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RecLockWid(entry: entry)
        }
        .configurationDisplayName("Tasks")
        .description("All your tasks")
        .supportedFamilies([.accessoryRectangular])
    }
}


@available(iOS 16.0,watchOS 9.0, *) struct LockCircleWidjet: Widget {
    let kind: String = "CircleRopesWidjet"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CircleWidjetView(entry: entry)
        }
        .configurationDisplayName("Tasks")
        .description("All your tasks")
        .supportedFamilies([.accessoryCircular])
    }
}

#if os(iOS)
struct RopesWidjet: Widget {
    let kind: String = "CommonRopesWidjet"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidjetsEntryView(entry: entry)
        }
        .configurationDisplayName("Tasks")
        .description("All your tasks")
        .supportedFamilies([.systemSmall])
    }
}
#endif

#if os(watchOS)
@available(watchOS 9.0, *) struct CornerWidjet: Widget {
    let kind: String = "CornerRopesWidjet"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CornerWidjetView(entry: entry)
        }
        .configurationDisplayName("Tasks")
        .description("All your tasks")
        .supportedFamilies([.accessoryCorner])
    }
}
#endif



struct Widjets_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            RecLockWid(entry: SimpleEntry(date: Date(), names: ["vasya","petya","fif","kik"]))
                .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
        }
    }
}
