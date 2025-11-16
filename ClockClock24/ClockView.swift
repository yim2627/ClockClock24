//
//  ClockView.swift
//  ClockClock24
//
//  Created by 임지성 on 11/16/25.
//

import SwiftUI
import Combine

struct ClockGridView: View {
	private let rowCount: Int = 3
	private let columnCount: Int = 8
	private let clockCount: Int = 24
	
	@State private var clockStates: [MiniClockState] = (0..<24).map { _ in
		MiniClockState(angleSmallHand: 0.0, angleBigHand: 0.0)
	}
	@State private var segmentStatuses: [SegmentStatus] = Array(repeating: .none, count: 24)
	@State private var previousMinute: Int? = nil
	
	private let timerPublisher = Timer
		.publish(every: 1, on: .main, in: .common)
		.autoconnect()
	
	var body: some View {
		GeometryReader { geometry in
			let viewWidth = geometry.size.width
			let viewHeight = geometry.size.height
			let cellWidth = viewWidth / CGFloat(columnCount)
			let cellHeight = viewHeight / CGFloat(rowCount)
			let cellSize = min(cellWidth, cellHeight)
			
			VStack(spacing: 0) {
				ForEach(0..<rowCount, id: \.self) { rowIndex in
					HStack(spacing: 0) {
						ForEach(0..<columnCount, id: \.self) { columnIndex in
							let index = rowIndex * columnCount + columnIndex
							MiniClockView(state: clockStates[index])
								.frame(width: cellSize, height: cellSize)
						}
					}
				}
			}
			.frame(width: cellSize * CGFloat(columnCount),
						 height: cellSize * CGFloat(rowCount))
			.position(x: viewWidth / 2.0, y: viewHeight / 2.0)
		}
		.background(Color.white.ignoresSafeArea())
		.onAppear {
			applyCurrentTime(animated: false)
		}
		.onReceive(timerPublisher) { currentDate in
			handleTick(currentDate: currentDate)
		}
	}
	
	private func handleTick(currentDate: Date) {
		let calendar = Calendar.current
		let currentMinute = calendar.component(.minute, from: currentDate)
		
		if currentMinute != previousMinute {
			previousMinute = currentMinute
			applyCurrentTime(animated: true)
		}
		
		rotateNoneSegmentsStep()
	}
	
	private func rotateNoneSegmentsStep() {
		let rotationStepDegrees: Double = 20.0
		
		withAnimation(.linear(duration: 2.0)) {
			for index in 0..<clockStates.count {
				if segmentStatuses[index] == .none {
					clockStates[index].angleSmallHand += rotationStepDegrees
					clockStates[index].angleBigHand += rotationStepDegrees
				}
			}
		}
	}
	
	private func applyCurrentTime(animated: Bool) {
		let currentDate = Date()
		let calendar = Calendar.current
		
		let hour = calendar.component(.hour, from: currentDate)
		let minute = calendar.component(.minute, from: currentDate)
		
		// 10 digit
		let hourTens = hour / 10
		// 1 digit
		let hourOnes = hour % 10
		// 10 digit
		let minuteTens = minute / 10
		// 1 digit
		let minuteOnes = minute % 10
		
		let digits = [hourTens, hourOnes, minuteTens, minuteOnes]
		
		var newSegmentStatuses: [SegmentStatus] = Array(repeating: .none, count: clockCount)
		
		for (placeIndex, digit) in digits.enumerated() {
			let digitPattern = DigitPatterns.pattern(for: digit)
			let baseColumnIndex = placeIndex * 2
			
			for cellIndex in 0..<digitPattern.count {
				let rowIndexWithinDigit = cellIndex / 2
				let columnIndexWithinDigit = cellIndex % 2
				let columnIndex = baseColumnIndex + columnIndexWithinDigit
				
				let gridIndex = rowIndexWithinDigit * columnCount + columnIndex
				if gridIndex >= 0 && gridIndex < newSegmentStatuses.count {
					newSegmentStatuses[gridIndex] = digitPattern[cellIndex]
				}
			}
		}
		
		segmentStatuses = newSegmentStatuses
		
		let updateBlock = {
			for index in 0..<clockStates.count {
				let segmentStatus = segmentStatuses[index]
				
				let (smallAngle, bigAngle) = SegmentAngles.angles(for: segmentStatus)
				clockStates[index].angleSmallHand = smallAngle
				clockStates[index].angleBigHand = bigAngle
			}
		}
		
		if animated {
			withAnimation(.easeInOut(duration: 2)) {
				updateBlock()
			}
		} else {
			updateBlock()
		}
	}
}
