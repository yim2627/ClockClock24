//
//  Pattern.swift
//  ClockClock24
//
//  Created by 임지성 on 11/16/25.
//

import Foundation

enum SegmentStatus {
	case leftTop
	case rightTop
	case rightBottom
	case leftBottom
	case straight
	case bottomOnly
	case topOnly
	case rightOnly
	case leftOnly
	case sideways
	case diagonal
	case none
}

struct SegmentAngles {
	static func angles(for status: SegmentStatus) -> (Double, Double) {
		switch status {
			case .straight:
				return (0.0, 180.0)
				
			case .leftTop:
				return (270.0, 0.0)
				
			case .rightTop:
				return (90.0, 0.0)
				
			case .rightBottom:
				return (90.0, 180.0)
				
			case .leftBottom:
				return (270.0, 180.0)
				
			case .rightOnly:
				return (90.0, 90.0)
				
			case .leftOnly:
				return (270.0, 270.0)
				
			case .topOnly:
				return (0.0, 0.0)
				
			case .bottomOnly:
				return (180.0, 180.0)
				
			case .none:
				return (225.0, 225.0)
				
			case .diagonal:
				return (45.0, -135.0)
				
			case .sideways:
				return (270.0, 90.0)
		}
	}
}

struct DigitPatterns {
	static let patterns: [[SegmentStatus]] = [
		// 0
		[.rightBottom, .leftBottom, .straight, .straight, .rightTop, .leftTop],
		// 1
		[.none, .bottomOnly, .none, .straight, .none, .topOnly],
		// 2
		[.rightOnly, .leftBottom, .rightBottom, .leftTop, .rightTop, .leftOnly],
		// 3
		[.rightOnly, .leftBottom, .rightOnly, .straight, .rightOnly, .leftTop],
		// 4
		[.bottomOnly, .bottomOnly, .rightTop, .straight, .none, .topOnly],
		// 5
		[.rightBottom, .leftOnly, .rightTop, .leftBottom, .rightOnly, .leftTop],
		// 6
		[.rightBottom, .leftOnly, .straight, .leftBottom, .rightTop, .leftTop],
		// 7
		[.rightOnly, .leftBottom, .none, .straight, .none, .topOnly],
		// 8
		[.rightBottom, .leftBottom, .rightTop, .leftBottom, .rightTop, .leftTop],
		// 9
		[.rightBottom, .leftBottom, .rightTop, .straight, .rightOnly, .leftTop]
	]
	
	static func pattern(for digit: Int) -> [SegmentStatus] {
		guard digit >= 0 && digit < patterns.count else {
			return patterns[0]
		}
		return patterns[digit]
	}
}
