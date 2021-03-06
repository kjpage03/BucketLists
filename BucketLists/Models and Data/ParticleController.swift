//
//  ParticleController.swift
//  BucketLists
//
//  Created by Kaleb Page on 4/27/21.
//

import UIKit

struct ParticleController {
    
    var view: UIView
    
    func createBackgroundParticles() {
        
        //MARK: Explain Particles
        
        let particleEmitter = CAEmitterLayer()
        
        particleEmitter.emitterPosition = CGPoint(x: -40, y: view.frame.height * 0.75)
        //        -96
        particleEmitter.emitterShape = .point
        particleEmitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)
        
        let bottomCell = makeEmitterCell(color: UIColor.black, type: .bottom)
        
        particleEmitter.emitterCells = [bottomCell]
        
                
        view.layer.addSublayer(particleEmitter)
        
        let topEmitter = CAEmitterLayer()
        topEmitter.emitterPosition = CGPoint(x: view.frame.maxX + 40, y: view.frame.height * 0.20)
        
        topEmitter.emitterShape = .point
        topEmitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)
        let topCell = makeEmitterCell(color: UIColor.black, type: .top)

        topEmitter.emitterCells = [topCell]
        view.layer.addSublayer(topEmitter)
        
    }
    
    func createParticles() {
        
        //Configure Emitter
        
        let particleEmitter = CAEmitterLayer()
        
        particleEmitter.emitterPosition = CGPoint(x: view.center.x, y: -96)
        //        -96
        particleEmitter.emitterShape = .line
        particleEmitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)
        
        let red = makeEmitterCell(color: .red, type: .confetti)
        let green = makeEmitterCell(color: .green, type: .confetti)
        let blue = makeEmitterCell(color: .blue, type: .confetti)
        let yellow = makeEmitterCell(color: .yellow, type: .confetti)
        
        particleEmitter.emitterCells = [red, green, blue, yellow]
        
        //Add Emitter
        
        view.layer.addSublayer(particleEmitter)
    }
    
    enum CellEmitterType {
        case confetti
        case top
        case bottom
    }
    
    func makeEmitterCell(color: UIColor, type: CellEmitterType) -> CAEmitterCell {
        let cell = CAEmitterCell()
        
        //original
        
        //        cell.scale = 0.2
        //        cell.birthRate = 3
        //        cell.lifetime = 7.0
        //        cell.lifetimeRange = 0
        //        cell.color = color.cgColor
        //        cell.velocity = 200
        //        cell.velocityRange = 50
        //        cell.emissionLongitude = CGFloat.pi
        //        cell.emissionRange = CGFloat.pi / 4
        //        cell.spin = 2
        //        cell.spinRange = 3
        //        cell.scaleRange = 0.5
        //        cell.scaleSpeed = -0.05
        
        //modified
        
        //        cell.scale = 0.2
        //        cell.birthRate = 5
        //        cell.lifetime = 7.0
        //        cell.lifetimeRange = 0
        //        cell.color = color.cgColor
        //        cell.velocity = 300
        //        cell.velocityRange = 50
        //        cell.emissionLongitude = CGFloat.pi
        //        cell.emissionRange = CGFloat.pi / 4
        //        cell.spin = 3
        //        cell.spinRange = 3
        //        cell.scaleRange = 0.5
        //        cell.scaleSpeed = -0.05
        
        switch type {
        
        case .confetti :
            
            //configure cell
            
            cell.scale = 0.2
            cell.birthRate = 5
            cell.lifetime = 7.0
            cell.lifetimeRange = 0
            cell.color = color.cgColor
            cell.velocity = 300
            cell.velocityRange = 0
            cell.emissionLongitude = CGFloat.pi
            cell.emissionRange = CGFloat.pi / 4
            cell.spin = 2
            cell.spinRange = 3
            cell.scaleRange = 0
            cell.scaleSpeed = -0.05
            
            cell.contents = UIImage(named: "bucket5")?.cgImage
        
        case .bottom:
            
            cell.scale = 0.5
            cell.birthRate = 0.1
            cell.lifetime = 10.0
            cell.lifetimeRange = 0
            cell.color = color.cgColor
            cell.velocity = 50
            cell.velocityRange = 50
            cell.emissionLongitude = 0
            cell.emissionRange = 0
            cell.spin = 1
            cell.spinRange = 3
            cell.scaleRange = 0
            cell.scaleSpeed = -0.05
            cell.contents = UIImage(named: "bucketNoBG")?.cgImage

        case .top:
            
            cell.scale = 0.5
            cell.birthRate = 0.1
            cell.lifetime = 10.0
            cell.lifetimeRange = 0
            cell.color = color.cgColor
            cell.velocity = 50
            cell.velocityRange = 50
            cell.emissionLongitude = CGFloat.pi
            cell.emissionRange = 0
            cell.spin = 1
            cell.spinRange = 3
            cell.scaleRange = 0
            cell.scaleSpeed = -0.05
            cell.contents = UIImage(named: "bucketNoBG")?.cgImage
            
        }
        
        return cell
    }
    
}
