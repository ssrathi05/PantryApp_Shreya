//
//  ConsumptionStatsView.swift
//  Pantry
//
//  Created by Shreya Rathi on 4/18/25.
//

import SwiftUI

struct ConsumptionStatsView: View {
    let stats: (eatenThisMonth: Int, wastedThisMonth: Int, itemsTrackedThisMonth: Int,
                eatenAllTime: Int, wastedAllTime: Int, itemsTrackedAllTime: Int)
    @Binding var allTimeButtonTrue: Bool
    
    var body: some View {
        ZStack {
            Color("LightGreen")
            
            VStack {
                TimeRangeButtons(allTimeButtonTrue: $allTimeButtonTrue)
                
                Spacer()
                
                StatsDisplay(stats: stats, allTimeButtonTrue: allTimeButtonTrue)
                
                Spacer()
            }
        }
        .cornerRadius(20)
        .frame(height: 250)
        .padding(20)
    }
}



struct ConsumptionDiaryCard: View {
    let stats: (eatenThisMonth: Int, wastedThisMonth: Int, itemsTrackedThisMonth: Int,
                eatenAllTime: Int, wastedAllTime: Int, itemsTrackedAllTime: Int)
    @Binding var allTimeButtonTrue: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.white)
                .frame(height: 450)
                .cornerRadius(50)
            
            VStack {
                Text("CONSUMPTION DIARY")
                    .fontWeight(.bold)
                Text("Reducing food waste is good for your wallet and the enviorment.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 15)
                    .padding(.top, 0.5)
                
                ConsumptionStatsView(stats: stats, allTimeButtonTrue: $allTimeButtonTrue)
            }
        }
    }
}
