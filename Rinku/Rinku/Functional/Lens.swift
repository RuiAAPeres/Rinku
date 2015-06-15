//
//  Lens.swift
//  Rinku
//
//  Created by Rui Peres on 15/06/2015.
//  Copyright © 2015 Rinku. All rights reserved.
//

import Foundation

// From here http://chris.eidhof.nl/posts/lenses-in-swift.html 🎉
struct Lens<T,U> {
    let from : T -> U
    let to : (U, T) -> T
}