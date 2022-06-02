//
//  NotificationPageView.swift
//  PoC_Save_Noti_To_CoreData
//
//  Created by Sukrit Chatmeeboon on 2/6/2565 BE.
//

import SwiftUI
import CoreData

struct NotificationPageView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var notificationCenter: NotificationCenter
    
    @State var itemList = [MockPayload]()
    @State var currentFetchOffset = 0
    private let dataFetchLimit = 3
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("นิยายอัปเดตล่าสุด \(itemList.count) รายการ")
                        .font(.system(size: 16))
                        .foregroundColor(.brown)
                    Spacer()
                    Button("เคลียร์การแจ้งเตือน") {
                        clearItem()
                    }
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                }
                .padding([.top, .bottom], 5)
                .padding([.leading, .trailing], 10)
               
                ZStack(alignment: .bottom) {
                    List {
                        ForEach(itemList, id: \.self) { item in
                            let data = NotificationCardData(title: item.title ?? "n/a")
                            NotificationCardView.UpdateNovelCard(data: data)
                                .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                    
                    VStack(spacing: 0) {
                        Button {
                            requestAuthForNotification()
                        } label: {
                            HStack {
                                Text("Grant Permission")
                                    .font(.system(size: 16))
                            }
                            .padding(8)
                            .background(Color.orange)
                            .foregroundColor(Color.white)
                            .cornerRadius(5)
                        }
                        .padding([.top], 20)
                        Button {
                            getLocalNotification()
                        } label: {
                            HStack {
                                Text("Local Notification")
                                    .font(.system(size: 16))
                            }
                            .padding(8)
                            .background(Color.orange)
                            .foregroundColor(Color.white)
                            .cornerRadius(5)
                        }
                        .padding([.top], 5)
              
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width, height: 140)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                    .shadow(color: .white, radius: 5)
                }
                .ignoresSafeArea(.all)
            }
            .onAppear {
                loadMockPayload()
            }
            .onReceive(notificationCenter.$notification) {_ in
                loadMockPayload()
            }
            .navigationTitle("แจ้งเตือนนิยายอัปเดต")
            .navigationBarTitleDisplayMode(.inline)
        }
        .ignoresSafeArea(.all)
    }
    
    private func loadMockPayload(with request: NSFetchRequest<MockPayload> = MockPayload.fetchRequest(), predicate: NSPredicate? = nil) {
//        request.fetchOffset = currentFetchOffset
//        request.fetchLimit = dataFetchLimit
        
        do {
            let dataList = try viewContext.fetch(request)
            itemList = dataList
            currentFetchOffset += dataFetchLimit
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    private func deleteItem() {
        
    }
    
    private func clearItem() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MockPayload")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try viewContext.execute(deleteRequest)
            itemList.removeAll()
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    private func getLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Feed the cat"
        content.subtitle = "It looks hungry"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
    
    private func requestAuthForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}


struct GlassBackground: View {

    let width: CGFloat
    let height: CGFloat
    let color: Color

    var body: some View {
        ZStack{
            RadialGradient(colors: [.clear, color],
                           center: .center,
                           startRadius: 1,
                           endRadius: 100)
                .opacity(0.6)
            Rectangle().foregroundColor(color)
        }
        .opacity(0.2)
        .blur(radius: 2)
        .cornerRadius(10)
        .frame(width: width, height: height)
    }
}

