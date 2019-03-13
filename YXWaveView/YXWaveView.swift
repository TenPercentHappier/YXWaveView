//
//  YXWaveView.swift
//  YXWaveView
//
//  Created by YourtionGuo on 8/26/16.
//  Copyright © 2016 Yourtion. All rights reserved.
//

import UIKit

open class YXWaveView: UIView {
  
  open var waveCurvature: CGFloat = 1.5
  open var waveSpeed: CGFloat = 0.6
  open var waveHeightPercentage: CGFloat = 0.1
  open var waveColor: UIColor = UIColor.red {
    didSet {
      self.waveLayer.fillColor = self.waveColor.cgColor
      self.baseLayer.fillColor = self.waveColor.cgColor
    }
  }
  
  open var baseHeightPercent: CGFloat = 0.5
  
  private var timer: CADisplayLink?
  
  private var waveLayer: CAShapeLayer = CAShapeLayer()
  private var baseLayer: CAShapeLayer = CAShapeLayer()
  
  private var offset: CGFloat = 0
  
  public required init(color: UIColor) {
    super.init(frame: .zero)
    
    self.waveColor = color
    
    waveLayer.fillColor = self.waveColor.cgColor
    baseLayer.fillColor = self.waveColor.cgColor
    
    self.layer.addSublayer(self.waveLayer)
    self.layer.addSublayer(self.baseLayer)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  open func start() {
    if (timer == nil) {
      wave()
      timer = CADisplayLink(target: self, selector: #selector(wave))
      timer?.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
    }
  }
  
  open func stop(){
    if (timer != nil) {
      timer?.invalidate()
      timer = nil
    }
  }
  
  @objc func wave() {
    
    var frame = self.bounds
    
    let baseHeight: CGFloat = frame.size.height * baseHeightPercent
    let waveHeight: CGFloat = frame.size.height * waveHeightPercentage
    
    frame.origin.y = frame.size.height - waveHeight - baseHeight
    waveLayer.frame = frame
    
    frame.origin.y = frame.size.height - baseHeight
    baseLayer.frame = frame
    
    offset += waveSpeed
    
    let width = frame.width
    
    let wavePath = CGMutablePath()
    wavePath.move(to: CGPoint(x: 0, y: waveHeight))
    var y: CGFloat = 0
    
    let offset_f = Float(offset * 0.045)
    let waveCurvature_f = Float(0.01 * waveCurvature)
    
    for x in 0...Int(width) {
      y = waveHeight * CGFloat(sinf( waveCurvature_f * Float(x) + offset_f))
      wavePath.addLine(to: CGPoint(x: CGFloat(x), y: y))
    }
    
    wavePath.addLine(to: CGPoint(x: width, y: waveHeight))
    wavePath.addLine(to: CGPoint(x: 0, y: waveHeight))
    wavePath.closeSubpath()
    self.waveLayer.path = wavePath
    
    let basePath = CGMutablePath()
    basePath.move(to: CGPoint(x: 0, y: 0))
    basePath.addLine(to: CGPoint(x: 0, y: baseHeight))
    basePath.addLine(to: CGPoint(x: width, y: baseHeight))
    basePath.addLine(to: CGPoint(x: width, y: 0))
    basePath.addLine(to: CGPoint(x: 0, y: 0))
    basePath.closeSubpath()
    
    self.baseLayer.path = basePath
  }
}
