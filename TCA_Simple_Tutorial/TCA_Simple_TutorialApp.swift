//
//  TCA_Simple_TutorialApp.swift
//  TCA_Simple_Tutorial
//
//  Created by MDsqr on 2022/12/29.
//

import SwiftUI

@main
struct TCA_Simple_TutorialApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
