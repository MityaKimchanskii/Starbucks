//
//  RewardsGraphView.swift
//  Starbucks
//
//  Created by Mitya Kim on 8/23/22.
//

import Foundation
import UIKit

class RewardsGraphView: UIView {
    
    let imageView = UIImageView()
    
    let initialFrameWidth: CGFloat = 200
    var actualFrameWidth: CGFloat?
    
    let height: CGFloat = 80
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        drawRewardsGraph()
        
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func drawRewardsGraph() {
        let frameWidth: CGFloat = actualFrameWidth ?? initialFrameWidth
        
        let padding: CGFloat = 20
        let dotSize:CGFloat = 12
        let lineWidth: CGFloat = 2
        let numberOfDots: CGFloat = 5
        let numberOfSection = numberOfDots - 1
        
        let spacingBetweenDots = (frameWidth - 2 * padding) / (numberOfSection + 0.5)
        
        let shortSegmentLenght = spacingBetweenDots * 0.25
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: frameWidth, height: height))
        
        var dots: [CGPoint] = []
        let labels: [String] = ["25", "50", "150", "250", "400"]
        
        let indicatorOffset: CGFloat = 34
        let yOffset = (dotSize + lineWidth) / 2 + indicatorOffset
        
        let img = renderer.image { ctx in
            
            // Define dots
            for index in 0...Int((numberOfDots - 1)) {
                let x = padding + shortSegmentLenght + (spacingBetweenDots * CGFloat(index))
                dots.append(CGPoint(x: x, y: yOffset))
            }
            
            // Define our lines between dots
            ctx.cgContext.setLineWidth(lineWidth)
            ctx.cgContext.setStrokeColor(UIColor.systemGray4.cgColor)
            
            // Draw starting segment
            let firstShortSegmentBegin = padding
            let firstShortSegmentEnd = padding + shortSegmentLenght - dotSize/2
            
            ctx.cgContext.move(to: CGPoint(x: firstShortSegmentBegin, y: yOffset))
            ctx.cgContext.addLine(to: CGPoint(x: firstShortSegmentEnd, y: yOffset))
            ctx.cgContext.strokePath()
            
            // Draw ending segment
            let lastShortSegmentEnd = frameWidth - padding
            let lastShortSegmentBegin = lastShortSegmentEnd - shortSegmentLenght
            
            ctx.cgContext.move(to: CGPoint(x: lastShortSegmentBegin, y: yOffset))
            ctx.cgContext.addLine(to: CGPoint(x: lastShortSegmentEnd, y: yOffset))
            ctx.cgContext.strokePath()
            
            ctx.cgContext.addLines(between: dots)
            ctx.cgContext.strokePath()
            
            ctx.cgContext.setFillColor(UIColor.white.cgColor)
            
            // Draw our dots
            for dot in dots {
                let dotBounds = CGRect(x: dot.x - (dotSize * 0.5), y: dot.y - (dotSize * 0.5), width: dotSize, height: dotSize)
                ctx.cgContext.addEllipse(in: dotBounds)
                ctx.cgContext.drawPath(using: CGPathDrawingMode.fillStroke)
            }
            
            // Draw points consumed
            let pointsConsumedBegin =  firstShortSegmentBegin
            let pointsConsumedEnd = padding + shortSegmentLenght / 2
            
            ctx.cgContext.setStrokeColor(UIColor.starYellow.cgColor)
            
            ctx.cgContext.move(to: CGPoint(x: pointsConsumedBegin, y: yOffset))
            ctx.cgContext.addLine(to: CGPoint(x: pointsConsumedEnd, y: yOffset))
            ctx.cgContext.strokePath()
            
            // Draw green indicator
            let indicatorX = pointsConsumedEnd - 8
            let indicatorY = yOffset - 36
            let star = UIImage(named: "green-indicator")
            
            star?.draw(at: CGPoint(x: indicatorX, y: indicatorY))
            
            // Draw our labels
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.preferredFont(forTextStyle: .footnote),
                .paragraphStyle: paragraphStyle
            ]
            
            for (i, dot) in dots.enumerated() {
                let string = labels[i]
                
                let attributedString = NSAttributedString(string: string, attributes: attrs)
                attributedString.draw(with: CGRect(x: dot.x - 15, y: dot.y + 16, width: 30, height: 20), options: .usesLineFragmentOrigin, context: nil)
            }
        }
        imageView.image = img
    }
}
