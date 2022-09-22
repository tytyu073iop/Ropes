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
        let fetchRequest = ToDo.fetchRequest()
        print("stage1")
        print(fetchRequest)
        // Get a reference to a NSManagedObjectContext
        print("stage2")

        // Fetch all objects of one Entity type
        print("i")
        var toDos = [ToDo]()
        let objects = try! context.fetch(fetchRequest)
        print(objects)
        do {
            try toDos = objects as! [ToDo]
        } catch {
            print("blyat \(error.localizedDescription)")
        }
        print(toDos)
        var names : [String] = toDos.compactMap { toDo in
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

@main
struct Widjets: Widget {
    let kind: String = "Tasks"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidjetsEntryView(entry: entry)
        }
        .configurationDisplayName("Tasks")
        .description("All your tasks")
        .supportedFamilies([.systemSmall])
    }
}

struct Widjets_Previews: PreviewProvider {
    static var previews: some View {
        WidjetsEntryView(entry: SimpleEntry(date: Date(), names: ["vasya","petya","fif","kik"]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
