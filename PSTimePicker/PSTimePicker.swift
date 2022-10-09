//
//  PSTimePicker.swift
//  PSTimePicker
//
//  Created by Pradeep Singh on 9/10/22.
//

import UIKit

class PSTimePicker: UIView {
    
    private let kComponentViewHeight: CGFloat = 35.0
    
    private var minutes: Int = 0
    private var pickerView: UIPickerView!
    private var lblHours: UILabel!
    private var lblMin: UILabel!
    
    typealias Completion = (TimeInterval) -> Void
    
    private enum Component: Int {
        case hours = 0
        case minutes = 1
    }
    
    var completion: Completion?
    
    // By default for 24 hours ( 24 * 60 == 1440)
    var maxMinutes: Int = 1440 {
        didSet {
            self.hours = 0
            self.minutes = 0
            self.pickerView?.reloadAllComponents()
            self.updateStaticLabelsPositions()
        }
    }
    
    private var maxHours: Int {
        return self.maxMinutes <= 60 ? 0 : self.maxMinutes / 60
    }
    
    private var hours: Int = 0 {
        didSet {
            if self.maxHours == self.hours { self.minutes = 0 }
            
            let minutes: Component = .minutes
            self.pickerView?.reloadComponent(minutes.rawValue)
        }
    }
    
    var hourSuffix = "hr" {
        didSet {
            self.lblHours.text = hourSuffix
        }
    }
    var minuteSuffix = "min" {
        didSet {
            self.lblMin.text = minuteSuffix
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize(frame: CGRect) {
        self.frame = frame
        self.pickerView = UIPickerView(frame: CGRect(x: 0, y: 10, width: frame.size.width-30, height: frame.size.height))
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.addSubview(pickerView)
        
        self.lblHours = self.newStaticLabelWithText(text: hourSuffix)
        self.addSubview(lblHours)
        
        self.lblMin = self.newStaticLabelWithText(text: minuteSuffix)
        self.addSubview(lblMin)
        
        self.updateStaticLabelsPositions()
    }
    
    override internal func layoutSubviews() {
        self.updateStaticLabelsPositions()
    }
    
    private func newStaticLabelWithText(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        return label
    }
    
    private func updateStaticLabelsPositions() {
        // Position the static labels
        let y = ((self.frame.height / 2) - 8)
        
        if self.maxHours > 0 {
            let viewWidth = self.frame.width
            let x1 = (viewWidth / 2) - 60
            let x2 = (viewWidth / 2) + 65
            self.lblHours.frame = CGRect(x: x1, y: y, width: 75, height: kComponentViewHeight)
            self.lblMin.frame =  CGRect(x: x2, y: y, width: 75, height: kComponentViewHeight)
            
        } else {
            self.lblHours.isHidden = true
            let viewWidth = self.frame.width
            let x2 = (viewWidth / 2) + 5
            self.lblMin.frame =  CGRect(x: x2, y: y, width: 75, height: kComponentViewHeight)
        }
    }
}

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension PSTimePicker: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.maxHours > 0 ? 2 : 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let comp = self.maxHours > 0 ? component : 1
        switch Component(rawValue: comp) {
        case .hours:
            return self.maxHours + 1
        case .minutes:
            if self.maxMinutes == 60 {
                return 61
            }
            
            if self.hours == self.maxHours {
                return (self.maxMinutes % 60) + 1
            }
            return self.maxHours > 0 ? 60 : self.maxMinutes + 1
        case .none:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let comp = self.maxHours > 0 ? component : 1
        switch Component(rawValue: comp) {
        case .hours:
            self.hours = row
        case .minutes:
            self.minutes = row
        case .none:
            break
        }
        self.done()
    }
    
    @objc private func done() {
        let hours: Int = self.hours
        let minutes: Int = self.minutes
        let seconds: Int = hours * 3600 + minutes * 60
        self.completion?(TimeInterval(seconds))
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 120
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return kComponentViewHeight
    }
    
}
