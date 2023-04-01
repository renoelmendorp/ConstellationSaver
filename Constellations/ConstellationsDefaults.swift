//
//  ConstellationsDefaults.swift
//  Constellations
//

import ScreenSaver

class ConstellationsDefaults {
    
    private var defaults = ScreenSaverDefaults(forModuleWithName: "nl.relmendorp.Constellations")
    
    var numberOfNodes: Int = 150 {
        didSet {
            if let defaults = self.defaults {
                defaults.set(numberOfNodes, forKey: "NumberOfNodes")
            }
        }
    }
    var minSpeed = 1.0 {
        didSet {
            if let defaults = self.defaults {
                defaults.set(minSpeed, forKey: "MinSpeed")
            }
        }
    }
    var maxSpeed = 5.0 {
        didSet {
            if let defaults = self.defaults {
                defaults.set(maxSpeed, forKey: "MaxSpeed")
            }
        }
    }
    var minRadius = 2.0 {
        didSet {
            if let defaults = self.defaults {
                defaults.set(minRadius, forKey: "MinRadius")
            }
        }
    }
    var maxRadius = 5.0 {
        didSet {
            if let defaults = self.defaults {
                defaults.set(maxRadius, forKey: "MaxRadius")
            }
        }
    }
    var lineDistance = 200.0 {
        didSet {
            if let defaults = self.defaults {
                defaults.set(lineDistance, forKey: "LineDistance")
            }
        }
    }
    
    var backgroundColor: NSColor = .black {
        didSet {
            if let defaults = self.defaults {
                defaults.set(backgroundColor, forKey: "BackgroundColor")
            }
        }
    }
    var nodeColor: NSColor = .white {
        didSet {
            if let defaults = self.defaults {
                defaults.set(nodeColor, forKey: "NodeColor")
            }
        }
    }
    var lineColor: NSColor = .white {
        didSet {
            if let defaults = self.defaults {
                defaults.set(lineColor, forKey: "LineColor")
            }
        }
    }
}
