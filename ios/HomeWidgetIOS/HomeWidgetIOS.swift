//
//  HomeWidgetIOS.swift
//  HomeWidgetIOS
//
//  Created by Tran Nhat Nam on 13/12/2023.
//

import WidgetKit
import SwiftUI
import Intents

private let widgetGroupId = "group.namtn.home_widget"

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { (entry) in
          let timeline = Timeline(entries: [entry], policy: .atEnd)
          completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct HomeWidgetIOSEntryView : View {
    var entry: Provider.Entry
    let data = UserDefaults.init(suiteName: widgetGroupId)
    let iconPath: String?

    init(entry: Provider.Entry) {
      self.entry = entry
      iconPath = data?.string(forKey: "widgetImage")

    }
    
    var body: some View {
        if #available(iOSApplicationExtension 17, *) {
            Button {
                BackgroundIntent(
                 url: URL(string: "homeWidget://home_widget"), appGroup: widgetGroupId)
            } label: {
                VStack.init(
                  alignment: .center, spacing:  100,
                  content: {
                    if iconPath != nil {
                      Image(uiImage: UIImage(contentsOfFile: iconPath!)!).resizable()
                        .scaledToFill()
                        .frame(width: 64, height: 64)
                    }
                  }
                )
            }.background(Color(uiColor: UIColor.red))
        } else {
            Button {
                print("Tingting")
            } label: {
                Text("TingTing")
            }.background(Color(uiColor: UIColor.blue))
        }
    }
}

struct HomeWidgetIOS: Widget {
    let kind: String = "HomeWidgetIOS"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HomeWidgetIOSEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct HomeWidgetIOS_Previews: PreviewProvider {
    static var previews: some View {
        HomeWidgetIOSEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
