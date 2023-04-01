//
//  ConstellationsView.swift
//  Constellations
//

import ScreenSaver

class ConstellationsView: ScreenSaverView {
    
    // MARK: Properties
    private var nodes: [Node] = []
    
    private var defaults = ConstellationsDefaults()
    
    // MARK: Initialization
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        
        nodes = initNodes(defaults.numberOfNodes)
    }
    
    @available(*, unavailable)
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func draw(_ rect: NSRect) {
        // Draw a single frame in this function
        drawBackground(defaults.backgroundColor)
        drawLines()
        drawNodes()
    }
    
    private func drawBackground(_ color: NSColor) {
        let background = NSBezierPath(rect: bounds)
        color.setFill()
        background.fill()
    }
    
    private func drawNodes() {
        for node in nodes {
            if nodeIsVisible(node) {
                let nodeRect = NSRect(
                    x: node.position.x - node.radius,
                    y: node.position.y - node.radius,
                    width: node.radius * 2,
                    height: node.radius * 2
                )
                let node = NSBezierPath(
                    roundedRect: nodeRect,
                    xRadius: node.radius,
                    yRadius: node.radius
                )
                defaults.nodeColor.setFill()
                node.fill()
            }
        }
    }
    
    private func drawLines() {
        for firstNode in nodes {
            for secondNode in nodes {
                let minX = min(firstNode.position.x, secondNode.position.x)
                let maxX = max(firstNode.position.x, secondNode.position.x)
                let minY = min(firstNode.position.y, secondNode.position.y)
                let maxY = max(firstNode.position.y, secondNode.position.y)
                
                let xDist = maxX - minX
                let yDist = maxY - minY
                
                let distance = sqrt(xDist*xDist + yDist*yDist)
                if distance <= defaults.lineDistance {
                    let intensity = 1.0 - distance / defaults.lineDistance
                    let line = NSBezierPath()
                    let color = defaults.lineColor.withAlphaComponent(intensity)
                    color.setStroke()
                    line.move(to: firstNode.position)
                    line.line(to: secondNode.position)
                    line.close()
                    line.stroke()
                }
            }
        }
    }
    
    override func animateOneFrame() {
        super.animateOneFrame()
        
        for node in nodes {
            node.step()
            if !nodeIsActive(node) {
                node.position = randomBorderPosition()
                node.vector = randomVector()
                node.radius = randomRadius()
            }
        }
        
        // Update the "state" of the screensaver in this function
        setNeedsDisplay(bounds)
    }
    
    // MARK: Helper Functions
    private func initNodes(_ numberOfNodes: Int) -> [Node] {
        return (0..<numberOfNodes).map { _ in
                .init(position: randomBorderPosition(),
                      vector: randomVector(),
                      radius: randomRadius())
        }
    }
    
    private func randomBorderPosition(_ radius: CGFloat = 0.0) -> CGPoint {

        let maxRange = bounds.width * 2 + bounds.height * 2
        let linearPosition = SSRandomFloatBetween(0.0, maxRange)
        
        var x: CGFloat
        var y: CGFloat
        
        switch linearPosition {
        case (0..<bounds.width):
            x = linearPosition
            y = -defaults.lineDistance
            
        case (bounds.width..<2*bounds.width):
            x = linearPosition - bounds.width
            y = bounds.height + defaults.lineDistance
            
        case (2*bounds.width..<2*bounds.width+bounds.height):
            x = -defaults.lineDistance
            y = linearPosition - 2*bounds.width
            
        default:
            x = bounds.width + defaults.lineDistance
            y = linearPosition - 2*bounds.width - bounds.height
        }
        
        return .init(x: x, y: y)
    }
    
    private func randomRadius() -> CGFloat {
        return SSRandomFloatBetween(defaults.minRadius, defaults.maxRadius)
    }
    
    private func randomVector() -> CGVector {
        let magnitude = SSRandomFloatBetween(defaults.minSpeed, defaults.maxSpeed)
        let iVector = SSRandomFloatBetween(-1.0, 1.0)
        let jVector = SSRandomFloatBetween(-1.0, 1.0)
        
        let scaling = magnitude / sqrt(iVector*iVector + jVector*jVector)
        
        return .init(dx: iVector * scaling, dy: jVector * scaling)
    }
    
    private func nodeIsWithinBounds(_ node: Node, margin: CGFloat) -> Bool {
        return (node.position.x + margin >= 0 &&
                node.position.x - margin <= bounds.width &&
                node.position.y + margin >= 0 &&
                node.position.y - margin <= bounds.height)
    }
    
    private func nodeIsActive(_ node: Node) -> Bool {
        return nodeIsWithinBounds(node, margin: defaults.lineDistance)
    }
    
    private func nodeIsVisible(_ node: Node) -> Bool {
        return nodeIsWithinBounds(node, margin: node.radius)
    }
}

class Node {
    var position: CGPoint
    var vector: CGVector
    var radius: CGFloat
    
    init(position: CGPoint, vector: CGVector, radius: CGFloat) {
        self.position = position
        self.vector = vector
        self.radius = radius
    }
    
    func step() {
        self.position.x += self.vector.dx
        self.position.y += self.vector.dy
    }
}
