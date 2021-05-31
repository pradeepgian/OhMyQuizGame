//
//  ConfettiEmitter.swift
//  QuizApp
//
//  Created by Pradeep Gianchandani on 31/05/21.
//

import UIKit

class ConfettiEmitter {
    static func get(with image: UIImage) -> CAEmitterLayer {
        let emitter = CAEmitterLayer()
        emitter.emitterShape = .line
        emitter.emitterCells = createEmitterCellsWithImage(image)
        emitter.setValue(NSNumber(value: Double(225)), forKeyPath: "emitterCells.confetti.velocity")
        emitter.setValue(NSNumber(value: 500), forKeyPath: "emitterCells.confetti.birthRate")
        emitter.emitterMode = .surface
        emitter.emitterShape = .rectangle
        emitter.speed = 1.75
        return emitter
    }
    
    static func createEmitterCellsWithImage(_ image: UIImage) -> [CAEmitterCell] {
        var cells = [CAEmitterCell]()
        let cell = CAEmitterCell()
        cell.contents = image.cgImage
        cell.blueRange = 1.5
        cell.blueSpeed = 0
        cell.redRange = 1.5
        cell.redSpeed = 0
        cell.greenRange =  1.5
        cell.greenSpeed = 0
        
        cell.velocity = 225
        cell.velocityRange = floor(cell.velocity / 10)
        cell.name = "confetti"
        cell.birthRate = 0
        cell.lifetime = 7
        cell.lifetimeRange = 2

        cell.alphaSpeed = 4.5
        cell.alphaRange = 0.5

        cell.scale = 0.5
        cell.scaleRange = 0.5
        cell.scaleSpeed = 0.1

        cell.speed = 0.1

        cell.spin = CGFloat.pi
        cell.spinRange = CGFloat.pi/2
        cell.emissionLongitude = 270 * (.pi/180)
        cell.emissionRange = 90 * (.pi/180)

        cell.yAcceleration = 180
        
        cells.append(cell)
        
        
        return cells
    }
    
}

