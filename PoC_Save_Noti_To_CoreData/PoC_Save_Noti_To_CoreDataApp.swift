//
//  PoC_Save_Noti_To_CoreDataApp.swift
//  PoC_Save_Noti_To_CoreData
//
//  Created by Sukrit Chatmeeboon on 1/6/2565 BE.
//

import SwiftUI

@main
struct PoC_Save_Noti_To_CoreDataApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var notificationCenter = NotificationCenter()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NotificationPageView(notificationCenter: notificationCenter)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

class NotificationCenter: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    private let viewContext = PersistenceController.shared.container.viewContext
    @Published var notification: UNNotification?
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let newPayload = MockPayload(context: viewContext)
        newPayload.title = notification.request.content.title
        newPayload.subTitle = notification.request.content.subtitle
        newPayload.timestamp = Date()

        do {
            try viewContext.save()
            self.notification = notification
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        completionHandler([.alert, .sound, .badge])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

//        let newPayload = MockPayload(context: viewContext)
//        newPayload.title = response.notification.request.content.title
//        newPayload.subTitle = response.notification.request.content.subtitle
//        newPayload.timestamp = Date()
//
//        do {
//            try viewContext.save()
//            self.notification = response.notification
//        } catch {
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) { }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        registerForPushNotification()
//        UINavigationBar.appearance().backgroundColor = .orange
        return true
    }
    
    func registerForPushNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
}
