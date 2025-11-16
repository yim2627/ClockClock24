//
//  MiniClockView.swift
//  ClockClock24
//
//  Created by 임지성 on 11/16/25.
//

import SwiftUI
import Combine

struct MiniClockState: Identifiable {
	let id = UUID()
	var angleSmallHand: Double
	var angleBigHand: Double
}

struct MiniClockView: View {
	let state: MiniClockState
	
	var body: some View {
		GeometryReader { geometry in
			let size = min(geometry.size.width, geometry.size.height)
			let lineWidth = size * 0.15
			let handLength = size * 0.5
			
			
			ZStack {
				Circle()
					.stroke(Color.secondary,
									lineWidth: lineWidth * 0.3)
					.background(
							Circle()
									.fill(
											.shadow(.inner(color: Color(red: 197/255, green: 197/255, blue: 197/255),radius: 5, x:3, y: 3))
											.shadow(.inner(color: .white, radius:5, x: -3, y: -3))
									)
									.foregroundColor(Color(red: 236/255, green: 234/255, blue: 235/255)))
				
				clockHand(length: handLength, thickness: lineWidth)
					.rotationEffect(.degrees(state.angleSmallHand))
				
				clockHand(length: handLength, thickness: lineWidth)
					.rotationEffect(.degrees(state.angleBigHand))
			}
			.frame(width: size, height: size)
		}
		.aspectRatio(1, contentMode: .fit)
	}
	
	private func clockHand(length: CGFloat, thickness: CGFloat) -> some View {
		RoundedRectangle(cornerRadius: thickness / 2)
			.foregroundStyle(.black)
			.frame(width: thickness, height: length)
			.offset(y: -length / 2)
	}
}
