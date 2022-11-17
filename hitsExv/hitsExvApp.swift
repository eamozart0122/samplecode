//
//  hitsExvApp.swift
//  hitsExv
//
//  Created by 阿久津栄一 on 2022/11/17.
//

import SwiftUI

@main
struct hitsExvApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
