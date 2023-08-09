//
//  Widjets.swift
//  Widjets
//
//  Created by Илья Бирюк on 12.08.22.
//

import WidgetKit
import SwiftUI
import CoreData

func TodoNames (context: NSManagedObjectContext) -> [String] {
    var request = ToDo.fetchRequest()
    request.fetchLimit = 4
    request.propertiesToFetch = ["name"]
    request.resultType = .dictionaryResultType
    var dictionaries = try! context.fetch(request) as [NSDictionary]
    var names : [String] = dictionaries.map { dictionar in
        return dictionar["name"] as! String
    }
    if defaults.bool(forKey: "swap") {
        names.reverse()
    }
    return names
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        ExampleEntry
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let context = PersistenceController.shared.container.viewContext
        // Create a fetch request for a specific Entity type
        
        completion(SimpleEntry(ropes: []))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        print("widjetbegin")
        Task {
            var entries: [SimpleEntry] = []
            
            // Create a fetch request for a specific Entity type
            let context = PersistenceController.shared.container.newBackgroundContext()
            let currentDate = Date()
            let entryDate = currentDate
            let entry = SimpleEntry(date: entryDate, ropes: try! await RopeQuiery().suggestedEntities())
            entries.append(entry)
            
            let timeline = Timeline(entries: entries, policy: .never)
            completion(timeline)
        }
    }
}
let bcontext = PersistenceController.shared.container.newBackgroundContext()
var Trequest = ToDo.fetchRequest()
struct SimpleEntry: TimelineEntry {
    let date: Date
    var ropes: [RopeEntity]
    var relevance: TimelineEntryRelevance? = TimelineEntryRelevance(score: Float(try! bcontext.fetch(Trequest).count))
    init(date: Date = Date(), ropes: [RopeEntity]) {
        self.date = date
        self.ropes = ropes
    }
}

let ExampleEntry = SimpleEntry(date: Date(), ropes: [RopeEntity(id: UUID(), name: "hello"), RopeEntity(id: UUID(), name: "hi")])

struct WidjetsEntryView : View {
    var entry: Provider.Entry
    var example: String = "test"
    @Environment(\.widgetFamily) var widjetFamily
    @Environment(\.colorScheme) var colorScheme
    @ViewBuilder
    var body: some View {
        switch widjetFamily {
        case .systemSmall:
            if entry.ropes.isEmpty {
                Text("There's no ropes")
            }
            VStack {
                ForEach(entry.ropes.prefix(4)) { rope in
                    HStack {
                        Spacer()
                        Text(rope.name)
                        Spacer()
                        Button(intent: RemoveRope(rope: rope), label: {Image(systemName: "trash")}).buttonStyle(PlainButtonStyle())
                    }
                    if rope != entry.ropes[entry.ropes.count > 3 ? 3 : entry.ropes.count - 1] {
                        Divider()
                    }
                }
            }.containerBackground(colorScheme == .dark ? .black : .white , for: .widget)
            #if !os(macOS)
        case .accessoryRectangular:
        if entry.ropes.isEmpty {
            Text("There's no ropes")
                .widgetAccentable()
        } else {
            VStack {
                if entry.ropes.count < 3 {
                    HStack {
                        Text("Your ropes:").bold()
                        Spacer()
                    }
                }
                ForEach(entry.ropes.prefix(3), id: \.self) { name in
                    HStack{
                        Text(name.name)
                        Spacer()
                    }
                }
            }
            .containerBackground(colorScheme == .dark ? .black : .white , for: .widget)
            .widgetAccentable()
        }
        case .accessoryCircular:
            ZStack {
                Circle()
                    .stroke(Color.gray,lineWidth: 5)
                Text("\(entry.ropes.count)").font(.system(size: 30))
            }
            .containerBackground(colorScheme == .dark ? .black : .white , for: .widget)
            .widgetAccentable()
            .widgetLabel(entry.ropes.first?.name ?? "")
        case .accessoryInline:
            Text(entry.ropes.first?.name ?? "You have no ropes")
                .widgetAccentable()
            #endif
            #if os(watchOS)
        case .accessoryCorner:
            ZStack {
                Text("\(entry.ropes.count)").font(.system(size: 30))
            }
            .containerBackground(colorScheme == .dark ? .black : .white , for: .widget)
            .widgetAccentable()
            .widgetLabel(entry.ropes.first?.name ?? "")
            #endif
        default: Text("unknown type")
        }
    }
}



@main struct RopesWidjets: WidgetBundle {
    @WidgetBundleBuilder var body: some Widget {
        RopesWidjet()
        #if !os(watchOS)
        AddWidjet()
        #endif
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



#Preview(as: .accessoryCircular, widget: {
    RopesWidjet()
}, timeline: {
    ExampleEntry
})

