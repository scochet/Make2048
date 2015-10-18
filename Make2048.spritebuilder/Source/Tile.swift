//
//  Tile.swift
//  Make2048
//
//  Created by Daniele Scochet on 17/10/15.
//  Copyright © 2015 Masca Labs di Daniele Scochet. All rights reserved.
//

import Foundation

class Tile: CCNode {
    
    /*
    **************************************
        properties
    **************************************
*/
    
    // CONNECTIONS
    // we always use the format weak var connectionName: ConnectionClass! for code connections to SpriteBuilder
    weak var valueLabel: CCLabelTTF!
    weak var backgroundNode: CCNodeColor!
    
    // stored properties
    var value: Int = 0 {
        // this is a property observer that updates the text of the label with the current value of the tile
        didSet {
            valueLabel.string = "\(value)"
        }
    }
    
    /*
    **************************************
        end of properties
    **************************************
    */



    /*
    **************************************
        methods
    **************************************
    */
    
    func didLoadFromCCB() {
        value = Int(CCRANDOM_MINUS1_1() + 2) * 2
    }
    
    /*
    **************************************
        end of methods
    **************************************
    */
}