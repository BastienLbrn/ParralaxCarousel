//
//  ParralaxCarouselConfig.swift
//  
//
//  Created by Bastien Lebrun on 26/08/2023.
//

import SwiftUI

public enum ParralaxEffect {
    case one
}

public struct ParralaxCarouselConfig {
    public let horizontalSpacing: CGFloat
    public let horizontalInset: CGFloat
    public let cornerRadius: CGFloat
    public let shadowColor: Color
    public let parralaxEffect: ParralaxEffect
    public let displayDots: Bool
    public let dotsCount: Int

    public init(
        horizontalSpacing: CGFloat = 8,
        horizontalInset: CGFloat = 30,
        cornerRadius: CGFloat = 15,
        shadowColor: Color = Color.black.opacity(0.25),
        parralaxEffect: ParralaxEffect = .one,
        displayDots: Bool = true,
        dotsCount: Int = 5
    ) {
        self.horizontalInset = horizontalInset
        self.horizontalSpacing = horizontalSpacing
        self.cornerRadius = cornerRadius
        self.shadowColor = shadowColor
        self.parralaxEffect = parralaxEffect
        self.displayDots = displayDots
        self.dotsCount = dotsCount
    }
}
