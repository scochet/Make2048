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
        
        // avvio la gestione delle gestures
        setupGestures()
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
        Adding gesture recognizers
*/
    
    // Gesture recognizers need to be added to a UIView.
    // The main UIView in a Cocos2D application is the OpenGL view that is used to render the entire content of a Cocos2d app.
    // We access this main UIView through the "view" property of CCDirector.
    // The UISwipeGestureRecognizer allows to associate one method with each swipe direction.
    
    func setupGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "swipeLeft")
        swipeLeft.direction = .Left
        CCDirector.sharedDirector().view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "swipeRight")
        swipeRight.direction = .Right
        CCDirector.sharedDirector().view.addGestureRecognizer(swipeRight)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: "swipeUp")
        swipeUp.direction = .Up
        CCDirector.sharedDirector().view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: "swipeDown")
        swipeDown.direction = .Down
        CCDirector.sharedDirector().view.addGestureRecognizer(swipeDown)
    }
    
    func swipeLeft() {
        move(CGPoint(x: -1, y: 0))
    }
    
    func swipeRight() {
        move(CGPoint(x: 1, y: 0))
    }
    
    func swipeUp() {
        move(CGPoint(x: 0, y: 1))
    }
    
    func swipeDown() {
        move(CGPoint(x: 0, y: -1))
    }
    
    func move(direction: CGPoint) {
        // apply negative vector until reaching boundary, this way we get the tile that is the farthest away
        // bottom left corner
        var currentX = 0
        var currentY = 0
        // Move to relevant edge by applying direction until reaching border
        while indexValid(currentX, y: currentY) {
            let newX = currentX + Int(direction.x)
            let newY = currentY + Int(direction.y)
            if indexValid(newX, y: newY) {
                currentX = newX
                currentY = newY
            } else {
                break
            }
        }
        // store initial row value to reset after completing each column
        var initialY = currentY
        // define changing of x and y value (moving left, up, down or right?)
        var xChange = Int(-direction.x)
        var yChange = Int(-direction.y)
        if xChange == 0 {
            xChange = 1
        }
        if yChange == 0 {
            yChange = 1
        }
        // visit column for column
        while indexValid(currentX, y: currentY) {
            while indexValid(currentX, y: currentY) {
                // get tile at current index
                if let tile = gridArray[currentX][currentY] {
                    // if tile exists at index
                    var newX = currentX
                    var newY = currentY
                    // find the farthest position by iterating in direction of the vector until reaching boarding of
                    // grid or occupied cell
                    while indexValidAndUnoccupied(newX+Int(direction.x), y: newY+Int(direction.y)) {
                        newX += Int(direction.x)
                        newY += Int(direction.y)
                    }
                    //After the loop terminates we check if the position of the selected tile has changed. For example, if the selected tile already is located left edge of the grid and we want to move it to the left, the position will not change. Only if the position changed we call the moveTile method.
                    if newX != currentX || newY != currentY {
                        moveTile(tile, fromX: currentX, fromY: currentY, toX: newX, toY: newY)
                    }
                }
                // move further in this column
                currentY += yChange
            }
            currentX += xChange
            currentY = initialY
        }
    }
    
    // All this method does is checking wether the index is within the bounds of the two dimensional array.
    func indexValid(x: Int, y: Int) -> Bool {
        var indexValid = true
        indexValid = (x >= 0) && (y >= 0)
        if indexValid {
            indexValid = x < Int(gridArray.count)
            if indexValid {
                indexValid = y < Int(gridArray[x].count)
            }
        }
        return indexValid
    }
    
    func indexValidAndUnoccupied(x: Int, y: Int) -> Bool {
        let indexValid = self.indexValid(x, y: y)
        if !indexValid {
            return false
        }
        // unoccupied?
        return gridArray[x][y] == noTile
    }
    
    func moveTile(tile: Tile, fromX: Int, fromY: Int, toX: Int, toY: Int) {
        gridArray[toX][toY] = gridArray[fromX][fromY]
        gridArray[fromX][fromY] = noTile
        let newPosition = positionForColumn(toX, row: toY)
        let moveTo = CCActionMoveTo(duration: 0.2, position: newPosition)
        // applico una easing al movimento
        let easedAction = CCActionEaseOut(action: moveTo, rate: 3.0)
        //tile.runAction(moveTo)
        tile.runAction(easedAction)
    }
    
    /*
    **************************************
        end of methods
    **************************************
*/
}