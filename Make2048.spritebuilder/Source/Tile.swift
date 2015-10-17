//
//  Tile.swift
//  Make2048
//
//  Created by Daniele Scochet on 17/10/15.
//  Copyright © 2015 Masca Labs di Daniele Scochet. All rights reserved.
//

import Foundation

class Tile: CCNode {
    // we always use the format weak var connectionName: ConnectionClass! for code connections to SpriteBuilder
    weak var valueLabel: CCLabelTTF!
    weak var backgroundNode: CCNodeColor!
}