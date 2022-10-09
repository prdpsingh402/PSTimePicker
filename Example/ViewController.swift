//
//  ViewController.swift
//  PSTimePicker
//
//  Created by Pradeep Singh on 9/10/22.
//

import UIKit
import PSTimePicker

class ViewController: UIViewController {
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnTimePicker: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func timePickerBtnAction(_ sender: UIButton) {
        
        let datePickerSize = CGSize(width: 320, height: 216)
        let datePicker = PSTimePicker(frame: CGRect(x: 15,
                                                    y: 0,
                                                    width: datePickerSize.width,
                                                    height: datePickerSize.height))
        datePicker.completion = { (timeInterval) in
            debugPrint("Time Intervel : ", timeInterval)
            self.lblTime.text = self.stringTime(interval: timeInterval)
        }
        
        let popoverViewController = UIViewController()
        popoverViewController.view.addSubview(datePicker)
        popoverViewController.view.frame = CGRect(x: 0,
                                                  y: 0,
                                                  width: datePickerSize.width,
                                                  height: datePickerSize.height)
        popoverViewController.modalPresentationStyle = .popover
        popoverViewController.preferredContentSize = datePicker.frame.size
        popoverViewController.popoverPresentationController?.sourceView = sender
        popoverViewController.popoverPresentationController?.permittedArrowDirections = .any
        popoverViewController.popoverPresentationController?.sourceRect = sender.bounds
        popoverViewController.popoverPresentationController?.delegate = self
        self.present(popoverViewController, animated: true, completion: nil)
    }
    
    func stringTime(interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .full
        return formatter.string(from: interval)!
    }
}

extension ViewController : UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}
