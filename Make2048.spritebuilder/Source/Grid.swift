//
//  Grid.swift
//  Make2048
//
//  Created by Daniele Scochet on 17/10/15.
//  Copyright © 2015 Masca Labs di Daniele Scochet. All rights reserved.
//

import Foundation

class Grid: CCNodeColor {
    
    /*
    **************************************
        properties
    **************************************
*/
    let gridSize = 4
    
    var columnWidth: CGFloat = 0
    var columnHeight: CGFloat = 0
    var tileMarginVertical: CGFloat = 0
    var tileMarginHorizontal: CGFloat = 0
    
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
    
    func setupBackground() {
        /*
        First we load a Tile.ccb to read the height and width of a single tile
*/
        let tile = CCBReader.load("Tile") as! Tile
        columnWidth = tile.contentSize.width
        columnHeight = tile.contentSize.height
        
        tileMarginHorizontal = (contentSize.width - (CGFloat(gridSize) * columnWidth)) / CGFloat(gridSize + 1)
        tileMarginVertical = (contentSize.height - (CGFloat(gridSize) * columnHeight)) / CGFloat(gridSize + 1)
        
        var x = tileMarginHorizontal
        var y = tileMarginVertical
        
        /*
        Swift allows the use of an underscore instead of a variable name in cases where the index in the loop isn't used
*/
        for _ in 0..<gridSize {
            x = tileMarginHorizontal
            for _ in 0..<gridSize {
                let backgroundTile = CCNodeColor.nodeWithColor(CCColor.grayColor())
                backgroundTile.contentSize = CGSize(width: columnWidth, height: columnHeight)
                backgroundTile.position = CGPoint(x: x, y: y)
                addChild(backgroundTile)
                x += columnWidth + tileMarginHorizontal
            }
            y += columnHeight + tileMarginVertical
        }
    }
    
    /*
    **************************************
        end of methods
    **************************************
*/
}