//
//  NotificationCardView.swift
//  PoC_Save_Noti_To_CoreData
//
//  Created by Sukrit Chatmeeboon on 2/6/2565 BE.
//

import SwiftUI
import Kingfisher

struct NotificationCardData {
    var title = "Novel Title"
    var ownerAliasname = "Owner Aliasname"
    var mainTitle = "mainTitle"
    var subTitle = "subTitle"
    var totalChapter = 0
    var thumbnailNormal = "https://image.dek-d.com/contentimg/writer/assets/thumbnail/novel/default-summer.webp"
    var state = "ยังไม่จบ"
    var updateAt = Date()
    var chapterTitle = "ตอนที่ 100"
}

enum NotificationCardView {
    struct UpdateNovelCard: View {
        var data: NotificationCardData = NotificationCardData()
        
        var body: some View {
            HStack {
                VStack(alignment: .leading, spacing: 0){
                    Text(data.title)
                        .font(.system(size: 18))
                    HStack{
                        Image(systemName: "person.circle.fill")
                        Text(data.ownerAliasname)
                            .font(.system(size: 12))
                    }
                    HStack{
                        Image(systemName: "book.closed.circle.fill")
                        Text("\(data.mainTitle) >")
                            .font(.system(size: 12))
                        Text(data.subTitle)
                            .font(.system(size: 12))
                    }
                    HStack{
                        Image(systemName: "doc.circle.fill")
                        Text("\(data.totalChapter) ตอน")
                            .font(.system(size: 12))
                        Text("(\(data.state))")
                            .font(.system(size: 12))
                    }
                    HStack{
                        Image(systemName: "clock.circle.fill")
                        Text("อัปเดตล่าสุด :")
                            .font(.system(size: 12))
                        Text("\(data.updateAt, formatter: formatter)")
                            .font(.system(size: 12))
                    }
                    
                    Button {
                        print("[]")
                    } label: {
                        HStack {
                            Image(systemName: "bell.fill")
                                .resizable()
                                .frame(width: 15, height: 15)
                            Text("มีการอัปเดต")
                                .font(.system(size: 12))
                        }
                        .padding(8)
                        .background(Color.red)
                        .foregroundColor(Color.white)
                        .cornerRadius(5)
                    }
                    .padding([.top, .bottom], 5)
                    
                    Text(data.chapterTitle)
                        .font(.system(size: 16))
                }
                Spacer()
            
                KFImage(URL(string: data.thumbnailNormal)!)
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
            }
            .padding([.leading, .trailing], 20)
            .padding([.top, .bottom], 10)
            .background(Color.yellow.opacity(0.2))
            .cornerRadius(10)
        }
        
        private let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .medium
            return formatter
        }()
    }
}


struct NotificationCardView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationCardView.UpdateNovelCard()
    }
}
