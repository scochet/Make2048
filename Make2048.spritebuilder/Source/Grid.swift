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
    // consts
    let gridSize = 4
    let startTiles = 2
    
    
    // vars
    var columnWidth: CGFloat = 0
    var columnHeight: CGFloat = 0
    var tileMarginVertical: CGFloat = 0
    var tileMarginHorizontal: CGFloat = 0
    
    var gridArray = [[Tile?]]()
    var noTile: Tile? = nil
    
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
        setupBackground()
        
        // riempio grid di vettori colonna vuoti
        for i in 0..<gridSize {
            var column = [Tile?]()
            for j in 0..<gridSize {
                column.append(noTile)
            }
            gridArray.append(column)
        }
        
        // popolo la grid del numero di tiles predeterminate in startTiles (qui, startTiles = 2)
        spawnStartTiles()
    }
    
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
    
    func positionForColumn(column: Int, row: Int) -> CGPoint {
        let x = tileMarginHorizontal + CGFloat(column) * (tileMarginHorizontal + columnWidth)
        let y = tileMarginVertical + CGFloat(row) * (tileMarginVertical + columnHeight)
        return CGPoint(x: x, y: y)
    }
    
    func addTileAtColumn(column: Int, row: Int) {
        let tile = CCBReader.load("Tile") as! Tile
        gridArray[column][row] = tile
        tile.scale = 0
        addChild(tile)
        tile.position = positionForColumn(column, row: row)
        let delay = CCActionDelay(duration: 0.3)
        let scaleUp = CCActionScaleTo(duration: 0.2, scale: 1)
        let sequence = CCActionSequence(array: [delay, scaleUp])
        tile.runAction(sequence)
    }
    
    func spawnRandomTile() {
        var spawned = false
        while !spawned {
            let randomRow = Int(CCRANDOM_0_1() * Float(gridSize))
            let randomColumn = Int(CCRANDOM_0_1() * Float(gridSize))
            let positionFree = gridArray[randomColumn][randomRow] == noTile
            if positionFree {
                addTileAtColumn(randomColumn, row: randomRow)
                spawned = true
            }
        }
    }
    
    func spawnStartTiles() {
        for _ in 0..<startTiles {
            spawnRandomTile()
        }
    }
    
    /*
    **************************************
        end of methods
    **************************************
*/
}