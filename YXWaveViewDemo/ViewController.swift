//
//  ViewController.swift
//  YXWaveViewDemo
//
//  Created by YourtionGuo on 8/26/16.
//  Copyright © 2016 Yourtion. All rights reserved.
//

import UIKit
import YXWaveView

class ViewController: UIViewController {
  
  private let segControl = UISegmentedControl(items: ["Top", "Bottom"])
  
  private let plusCurveButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("+Curve", for: .normal)
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  
  private let minusCurveButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("-Curve", for: .normal)
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  
  private let plusHeightButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("+Height", for: .normal)
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  
  private let minusHeightButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("-Height", for: .normal)
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  
  private let plusBaseButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("+Base", for: .normal)
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  
  private let minusBaseButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("-Base", for: .normal)
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  
  private let plusSpeedButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("+Speed", for: .normal)
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  
  private let minusSpeedButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setTitle("-Speed", for: .normal)
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  
  private var topInfoLabel = UILabel(frame: .zero)
  private var bottomInfoLabel = UILabel(frame: .zero)
  
  private var titleLabel = UILabel(frame: .zero)
  private var topWave: YXWaveView?
  private var bottomWave: YXWaveView?
  
  private var selectedWave: YXWaveView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    topWave = createWave(curvature: 0.5,
                         waveHeightPercentage: 0.1,
                         baseHeightPercent: 0.25,
                         speed: 0.2)
    bottomWave = createWave(curvature: 0.5,
                            waveHeightPercentage: 0.1,
                            baseHeightPercent: 0.20,
                            speed: 0.3)
    
    selectedWave = topWave
    
    [segControl,
     plusCurveButton, minusCurveButton,
     plusHeightButton, minusHeightButton,
     plusBaseButton, minusBaseButton,
     plusSpeedButton, minusSpeedButton,
     topInfoLabel, bottomInfoLabel].forEach { v in
      view.addSubview(v)
      v.translatesAutoresizingMaskIntoConstraints = false
    }
    
    segControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    segControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10).isActive = true
    segControl.selectedSegmentIndex = 0
    segControl.addTarget(self, action: #selector(waveChanged(_:)), for: .valueChanged)
    
    plusCurveButton.topAnchor.constraint(equalTo: segControl.bottomAnchor, constant: 10).isActive = true
    plusCurveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    plusCurveButton.addTarget(self, action: #selector(increaseCurve(_:)), for: .touchUpInside)
    
    plusHeightButton.topAnchor.constraint(equalTo: segControl.bottomAnchor, constant: 10).isActive = true
    plusHeightButton.leadingAnchor.constraint(equalTo: plusCurveButton.trailingAnchor, constant: 10).isActive = true
    plusHeightButton.addTarget(self, action: #selector(increaseHeight(_:)), for: .touchUpInside)
    
    plusBaseButton.topAnchor.constraint(equalTo: segControl.bottomAnchor, constant: 10).isActive = true
    plusBaseButton.leadingAnchor.constraint(equalTo: plusHeightButton.trailingAnchor, constant: 10).isActive = true
    plusBaseButton.addTarget(self, action: #selector(increaseBase(_:)), for: .touchUpInside)
    
    plusSpeedButton.topAnchor.constraint(equalTo: segControl.bottomAnchor, constant: 10).isActive = true
    plusSpeedButton.leadingAnchor.constraint(equalTo: plusBaseButton.trailingAnchor, constant: 10).isActive = true
    plusSpeedButton.addTarget(self, action: #selector(increaseSpeed(_:)), for: .touchUpInside)
    
    minusCurveButton.topAnchor.constraint(equalTo: plusCurveButton.bottomAnchor, constant: 10).isActive = true
    minusCurveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    minusCurveButton.addTarget(self, action: #selector(decreaseCurve(_:)), for: .touchUpInside)
    
    minusHeightButton.topAnchor.constraint(equalTo: plusCurveButton.bottomAnchor, constant: 10).isActive = true
    minusHeightButton.leadingAnchor.constraint(equalTo: minusCurveButton.trailingAnchor, constant: 10).isActive = true
    minusHeightButton.addTarget(self, action: #selector(decreaseHeight(_:)), for: .touchUpInside)
    
    minusBaseButton.topAnchor.constraint(equalTo: plusCurveButton.bottomAnchor, constant: 10).isActive = true
    minusBaseButton.leadingAnchor.constraint(equalTo: minusHeightButton.trailingAnchor, constant: 10).isActive = true
    minusBaseButton.addTarget(self, action: #selector(decreaseBase(_:)), for: .touchUpInside)
    
    minusSpeedButton.topAnchor.constraint(equalTo: plusCurveButton.bottomAnchor, constant: 10).isActive = true
    minusSpeedButton.leadingAnchor.constraint(equalTo: minusBaseButton.trailingAnchor, constant: 10).isActive = true
    minusSpeedButton.addTarget(self, action: #selector(decreaseSpeed(_:)), for: .touchUpInside)
    
    topInfoLabel.font = UIFont.systemFont(ofSize: 8)
    topInfoLabel.numberOfLines = 0
    topInfoLabel.topAnchor.constraint(equalTo: minusSpeedButton.bottomAnchor, constant: 10).isActive = true
    topInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    topInfoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    
    bottomInfoLabel.font = UIFont.systemFont(ofSize: 8)
    bottomInfoLabel.numberOfLines = 0
    bottomInfoLabel.topAnchor.constraint(equalTo: topInfoLabel.bottomAnchor, constant: 10).isActive = true
    bottomInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    bottomInfoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    
    titleLabel.text = "3:46"
    titleLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 60, weight: .light)
    titleLabel.textColor = .black
    view.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    
    updateInfo()
  }
  
  private func createWave(curvature: CGFloat,
                          waveHeightPercentage: CGFloat,
                          baseHeightPercent: CGFloat,
                          speed: CGFloat) -> YXWaveView {
    let wave = YXWaveView(color: UIColor(red: 177/255, green: 226/255, blue: 226/255, alpha: 0.5))
    wave.backgroundColor = .clear
    
    wave.waveCurvature = curvature
    wave.waveHeightPercentage = waveHeightPercentage
    wave.baseHeightPercent = baseHeightPercent
    wave.waveSpeed = speed
    
    // Add WaveView
    view.addSubview(wave)
    wave.translatesAutoresizingMaskIntoConstraints = false
    wave.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    wave.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    wave.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    wave.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    
    // Start wave
    wave.start()
    
    return wave
  }
  
  @objc func waveChanged(_ sender: Any) {
    if segControl.selectedSegmentIndex == 0 {
      selectedWave = topWave
    } else {
      selectedWave = bottomWave
    }
  }
  
  @objc func increaseCurve(_ sender: Any) {
    if let selectedWave = selectedWave {
      selectedWave.waveCurvature = selectedWave.waveCurvature + CGFloat(0.025)
      updateInfo()
    }
  }
  
  @objc func decreaseCurve(_ sender: Any) {
    if let selectedWave = selectedWave {
      selectedWave.waveCurvature = selectedWave.waveCurvature - CGFloat(0.025)
      updateInfo()
    }
  }
  
  @objc func increaseHeight(_ sender: Any) {
    if let selectedWave = selectedWave {
      selectedWave.waveHeightPercentage = selectedWave.waveHeightPercentage + CGFloat(0.005)
      updateInfo()
    }
  }
  
  @objc func decreaseHeight(_ sender: Any) {
    if let selectedWave = selectedWave {
      selectedWave.waveHeightPercentage = selectedWave.waveHeightPercentage - CGFloat(0.005)
      updateInfo()
    }
  }
  
  @objc func increaseBase(_ sender: Any) {
    if let selectedWave = selectedWave {
      selectedWave.baseHeightPercent = selectedWave.baseHeightPercent + CGFloat(0.01)
      updateInfo()
    }
  }
  
  @objc func decreaseBase(_ sender: Any) {
    if let selectedWave = selectedWave {
      selectedWave.baseHeightPercent = selectedWave.baseHeightPercent - CGFloat(0.01)
      updateInfo()
    }
  }
  
  @objc func increaseSpeed(_ sender: Any) {
    if let selectedWave = selectedWave {
      selectedWave.waveSpeed = selectedWave.waveSpeed + CGFloat(0.05)
      updateInfo()
    }
  }
  
  @objc func decreaseSpeed(_ sender: Any) {
    if let selectedWave = selectedWave {
      selectedWave.waveSpeed = selectedWave.waveSpeed - CGFloat(0.05)
      updateInfo()
    }
  }
  
  private func updateInfo() {
    if let topWave = topWave {
      topInfoLabel.text = "Curve: \(topWave.waveCurvature). Height %: \(topWave.waveHeightPercentage). Base Height %: \(topWave.baseHeightPercent). Speed: \(topWave.waveSpeed)"
    }
    if let bottomWave = bottomWave {
      bottomInfoLabel.text = "Curve: \(bottomWave.waveCurvature). Height %: \(bottomWave.waveHeightPercentage). Base Height %: \(bottomWave.baseHeightPercent). Speed: \(bottomWave.waveSpeed)"
    }
  }
}

