//
//  BelongingsSiuationSignboard.swift
//  Motimono
//
//  Created by 吉田翔 on 2025/04/15.
//

import Foundation
import SwiftUI

struct BelongingsSiuationSignboard: View {
    
    let title: String
    let preparedCount: Int
    let totalCount: Int
    var lastCompletedAt: Date?
    
    
    
    var body: some View {
        ZStack {
            // 背景色
            Color.yellow.opacity(0.7)

            // 内容配置
            VStack {
                HStack {
                    Text(title)
                        .font(.title)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if let date = lastCompletedAt {
                        Text(formattedDate(from: date))
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .frame(alignment: .trailing)
                    }
                }

                HStack {
                    Spacer()
                    Text("\(preparedCount)/\(totalCount)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .cornerRadius(15)
    }
    
    
    private func formattedDate(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let timePart = "\(hour):\(String(format: "%02d", minute))"
        
        if calendar.isDateInToday(date) {
            return "今日 \(timePart)"
        } else if calendar.isDateInYesterday(date) {
            return "昨日 \(timePart)"
        }
        
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        return "\(month)/\(day) \(timePart)"
    }

    
    
}


#Preview {
    BelongingsSiuationSignboard(title: "仕事前", preparedCount: 2, totalCount: 5, lastCompletedAt: Date())
}


struct ProjectRow: View {
    let iconName: String
    let title: String
    let price: String
    let timeLeft: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.white)
                .padding()
                .background(Color.black)
                .clipShape(Circle())

            VStack(alignment: .leading) {
                Text(title)
                    .fontWeight(.semibold)
                HStack {
                    Text(price)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Spacer()
                    Text(timeLeft)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color.green.opacity(0.08))
        .cornerRadius(15)
    }
}





struct RedBorderModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.red, lineWidth: 2)
            )
    }
}

extension Image {
    func redBorder() -> some View {
        self
            .modifier(RedBorderModifier())
    }
}
extension Image {
    func withSystemStyle() -> Image {
        self
            .renderingMode(.template)
            .resizable()
    }
}








#Preview {
    ProjectRow(iconName: "person", title: "RND Freelance Subscription", price: "$2,299.99", timeLeft: "22 HOURS LEFT")
}


struct TaskDashboardView: View {
    
    var listCells = [
        PendingTaskRow(title: "Approve Payment to Nidal Benatia", amount: "$2369.99", actionLabel: "Review", color: .blue)
         ,
        PendingTaskRow(title: "Add receipt for Travel Expense", amount: "$569.69", actionLabel: "Add Receipt", color: .green)
        
        
        
    ]
    
    
    let listCells2 = [
        ProjectRow(iconName: "person", title: "RND Freelance Subscription", price: "$2,299.99", timeLeft: "22 HOURS LEFT"),
        ProjectRow(iconName: "rectangle.stack.person.crop", title: "Hoopla Redesign", price: "$11,239.69", timeLeft: "11 HOURS LEFT"),
        ProjectRow(iconName: "star.fill", title: "Zand Bank App Design", price: "$22,239.69", timeLeft: "FIXED PRICE")
        
        ]
    
    
    var body: some View {
        
        
        
        
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(spacing: 0) {
                // MARK: - Header
                HStack {

                        
                        
                        HStack{
                            
                            
                            Text("2")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Capsule().fill(Color.orange))
                              
                            
                            Text("PENDING TASKS")
                                .fontWeight(.bold)
                                .foregroundColor(.black)

                           
                            
                        }
                      

                    Spacer()
                    
                    
                    Button("SHOW ALL") {
                        // Action
                    }
                    .font(.caption)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    
                
                    
                }
                .padding()
                
                // MARK: - Pending Tasks
                List {
                    ForEach(Array(listCells.enumerated()), id: \.offset) { index, row in
                        row
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                            .swipeActions(edge: .trailing) {
                                Button("Delete") {
                                    // 編集処理（モーダル表示・画面遷移など）
                                }
                                .tint(.red)
                                Button("Edit") {
                                    // 編集処理（モーダル表示・画面遷移など）
                                }
                                .tint(.blue)
                                
                            }
                    }
               
                    
                    
                }
              
                .listStyle(.plain)
                .frame(height: 200)
                
                
                Divider()
                
                // MARK: - Projects
                HStack {
                    HStack {
                        
                        Text("6")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(Color.yellow))
                        
                        
                        Text("PROJECTS")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                     
                    }
                    Spacer()
                    
                    Button("SHOW ALL") {
                        // Action
                    }
                    .font(.caption)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    
                }
                .padding()
                
                // MARK: - Project Cards
                List {
                    ForEach(Array(listCells2.enumerated()), id: \.offset) { index, row in
                        row
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                    }
                }
                .listStyle(.plain)
                .frame(height: 330)
                
                // MARK: - Create Project
                Button(action: {
                    // Action
                }) {
                    Text("Create New Project")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(10)
                }
                .padding()
                
                Spacer()
                
                // MARK: - Bottom Tab Bar
                
            }
            
            
            VStack(spacing:0){
                
                
                Spacer()
                    .frame(height: 730)
                
                CustomTabBar()
                
                
            }
        
    }
    }
    
    
    
    
    func deleteItem(at offsets: IndexSet) {
        
    }



}





struct CustomTabBar: View {
    var fontSize: CGFloat = 26

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 27)
                .fill(Color.black)
                .frame(height: 60)
                .padding(.horizontal, 24)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 4)

            HStack {
                Spacer()
                Button(action: {
                    // Home タブ押下時の処理
                }) {
                    Image(systemName: "house.fill")
                        .foregroundColor(.white)
                        .font(.system(size: fontSize))
                }

                Spacer()
                Button(action: {
                    // Grid タブ押下時の処理
                }) {
                    Image(systemName: "square.grid.2x2")
                        .foregroundColor(.gray)
                        .font(.system(size: fontSize))
                }

                Spacer()
                Button(action: {
                    // Hexagon タブ押下時の処理
                }) {
                    Image(systemName: "hexagon.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: fontSize))
                }
                Spacer()
            }
            .frame(height: 60)
            .padding(.horizontal, 36)
        }
    }
}








// MARK: - Components

struct PendingTaskRow: View {
    let title: String
    let amount: String
    let actionLabel: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: "doc.text")
                .padding()
                .background(Capsule().fill(Color.white))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                Text(amount)
                    .font(.footnote)
                    .fontWeight(.bold)
            }
            Spacer()
            Button(actionLabel) {}
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(color.opacity(0.1))
                .cornerRadius(8)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(Color.green.opacity(0.08))
        .cornerRadius(15)
    }
}


