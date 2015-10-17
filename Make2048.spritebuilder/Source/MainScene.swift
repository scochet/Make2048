import Foundation

class MainScene: CCNode {
    // we always use the format weak var connectionName: ConnectionClass! for code connections to SpriteBuilder
    weak var grid: Grid!
    weak var scoreLabel: CCLabelTTF!
    weak var highscoreLabel: CCLabelTTF!
}
