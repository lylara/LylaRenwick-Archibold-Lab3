//
//  Functions.swift
//  LylaRenwick-Archibold-Lab3
//
//  Created by Lyla Renwick-Archibold on 10/3/23.
//

import Foundation
import UIKit

class Functions{
    static func distance(a: CGPoint, b:CGPoint)->CGFloat{
        return sqrt(pow(a.x-b.x,2)+pow(a.y-b.y,2))
    }
}
