//
//  StatsDisplay.swift
//  Pantry
//
//  Created by Shreya Rathi on 4/18/25.
//

import SwiftUI

struct StatsDisplay: View {
    let stats: (eatenThisMonth: Int, wastedThisMonth: Int, itemsTrackedThisMonth: Int,
                eatenAllTime: Int, wastedAllTime: Int, itemsTrackedAllTime: Int)
    let allTimeButtonTrue: Bool
    
    private func calculatePercentage(part: Int, total: Int) -> Int {
        total > 0 ? Int((Double(part) / Double(total)) * 100) : 0
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    let eatenPercentage = calculatePercentage(
                        part: allTimeButtonTrue ? stats.eatenAllTime : stats.eatenThisMonth,
                        total: allTimeButtonTrue ? stats.itemsTrackedAllTime : stats.itemsTrackedThisMonth
                    )
                    Text("\(eatenPercentage)%")
                        .fontWeight(.semibold)
                        .font(.system(size: 17))
                    Text("eaten")
                }
                HStack {
                    let wastedPercentage = calculatePercentage(
                        part: allTimeButtonTrue ? stats.wastedAllTime : stats.wastedThisMonth,
                        total: allTimeButtonTrue ? stats.itemsTrackedAllTime : stats.itemsTrackedThisMonth
                    )
                    Text("\(wastedPercentage)%")
                        .fontWeight(.semibold)
                        .font(.system(size: 17))
                    Text("wasted")
                }
                
                Text("")
                
                Text(allTimeButtonTrue ? "\(stats.itemsTrackedAllTime) items tracked" : "\(stats.itemsTrackedThisMonth) items tracked")
                
                NavigationLink {
                    ViewItemsView(allTime: allTimeButtonTrue)
                } label: {
                    Text("View Items")
                        .foregroundStyle(.black)
                        .navigationBarBackButtonHidden()
                        .underline()
                }
            }
            .padding(.leading, 25)
            
            Spacer()
            
            PieChartView(
                expiredCount: allTimeButtonTrue ? stats.wastedAllTime : stats.wastedThisMonth,
                totalCount: allTimeButtonTrue ? stats.itemsTrackedAllTime : stats.itemsTrackedThisMonth
            )
            .padding()
        }
    }
}

