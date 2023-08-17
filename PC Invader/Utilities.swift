//
//  Utilities.swift
//  PC Invader
//
//  Created by An on 8/16/23.
//

import Foundation
import SpriteKit

public func randomFloat() -> CGFloat{ // Return a random float
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

public func randomFloat(min: CGFloat, max: CGFloat) -> CGFloat{
    return randomFloat() * (max - min) + min
}


class Utilities{
    
}
