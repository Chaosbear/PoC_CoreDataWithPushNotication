//
//  PoC_Save_Noti_To_CoreDataApp.swift
//  PoC_Save_Noti_To_CoreData
//
//  Created by Sukrit Chatmeeboon on 1/6/2565 BE.
//

import SwiftUI

@main
struct PoC_Save_Noti_To_CoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
