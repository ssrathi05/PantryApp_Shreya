//
//  PieChartView.swift
//  Pantry
//
//  Created by Shreya Rathi on 4/18/25.
//

import SwiftUI

struct PieChartView: View {
    let expiredCount: Int
    let totalCount: Int
    
    private var expiredPercentage: Double {
        totalCount > 0 ? Double(expiredCount) / Double(totalCount) : 0
    }
    
    private var eatenPercentage: Double {
        1 - expiredPercentage
    }
    
    private func positionForAngle(_ angle: Double, radius: Double) -> (x: Double, y: Double) {
        let radians = angle * .pi / 180
        return (
            x: radius * cos(radians),
            y: radius * sin(radians)
        )
    }
    
    var body: some View {
        ZStack {
            // Background circle (all consumed items)
            Circle()
                .fill(Color("DarkGreen"))
                .frame(width: 170, height: 170)
            
            // Expired portion
            if expiredCount > 0 {
                Path { path in
                    let center = CGPoint(x: 85, y: 85)
                    let radius: CGFloat = 85
                    
                    path.move(to: center)
                    path.addArc(
                        center: center,
                        radius: radius,
                        startAngle: .degrees(0),
                        endAngle: .degrees(360 * expiredPercentage),
                        clockwise: false
                    )
                    path.closeSubpath()
                }
                .fill(Color("Red"))
            }
            
            // Text overlays
            ZStack {
                // Expired percentage in red section
                if expiredCount > 0 {
                    let expiredAngle = 360 * expiredPercentage / 2 // Middle of the red section
                    let pos = positionForAngle(expiredAngle, radius: 40)
                    Text("\(Int(expiredPercentage * 100))%")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .offset(x: pos.x, y: pos.y)
                }
                
                // Eaten percentage in green section
                let eatenAngle = 360 * (expiredPercentage + eatenPercentage / 2) // Middle of the green section
                let pos = positionForAngle(eatenAngle, radius: 40)
                Text("\(Int(eatenPercentage * 100))%")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .offset(x: pos.x, y: pos.y)
            }
        }
        .frame(width: 170, height: 170)
    }
}



