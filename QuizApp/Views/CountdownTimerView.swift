//
//  CountdownTimerView.swift
//  QuizApp
//
//  Created by Pradeep Gianchandani on 26/05/21.
//

import UIKit

protocol CountdownViewDelegate: AnyObject {
    func didFinishCountdown()
}

class CountdownTimerView: UIView {
    
    private let shapeLayer = CAShapeLayer()
    weak var delegate: CountdownViewDelegate?
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .white
        return label
    }()
    
    private var timer = Timer()
    var timeLeft = 60  {
        didSet {
            seconds = TimeInterval(timeLeft)
        }
    }
    
    lazy private var seconds: TimeInterval = TimeInterval(timeLeft) //default value
    private var endTime: Date?
    
    init(radius: CGFloat) {
        
        super.init(frame: .zero)
        self.frame.size.height = radius * 2
        addSubview(timerLabel)
        timerLabel.frame = CGRect(x: 0, y: 0, width: 50, height: 25)
        timerLabel.center = center
        timerLabel.text = timeString(time: TimeInterval(seconds))
        
        let trackLayer = CAShapeLayer()
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false)
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor(red: 184/255, green: 166/255, blue: 240/255, alpha: 1).cgColor
        trackLayer.lineWidth = 2
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.position = center
        
        layer.addSublayer(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor(red: 207/255, green: 75/255, blue: 102/255, alpha: 1).cgColor
        shapeLayer.lineWidth = 15
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.position = center
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 1
        
        layer.addSublayer(shapeLayer)
        
    }
    
    func startTimer() {
        endTime = Date().addingTimeInterval(seconds)
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                      target: self,
                                      selector: (#selector(updateTimer)),
                                      userInfo: nil,
                                      repeats: true)
    }
    
    func resetTimer() {
        timer.invalidate()
    }
    
    @objc private func updateTimer() {
        if seconds < 0 {
            timerLabel.text = "0:00"
            timer.invalidate()
            //Send alert to indicate time's up.
            self.delegate?.didFinishCountdown()
        } else {
            seconds = endTime?.timeIntervalSinceNow ?? 0
            timerLabel.text = timeString(time: TimeInterval(seconds))
            let percentage = CGFloat(seconds) / CGFloat(timeLeft)
            shapeLayer.strokeEnd = percentage
        }
    }
    
    private func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%01i:%02i", minutes, seconds)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
