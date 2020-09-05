//
//  SettingsViewController.swift
//  TipCalculator
//
//  Created by John Jakobsen on 9/3/20.
//  Copyright © 2020 Peggie Liang. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var mainController: ViewController!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var backgroundSlider: UISlider!
    var tipSliderOn: Bool = true
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var tipAmount: UILabel!
    @IBOutlet weak var showTipSlider: UISwitch!
    var selectedRow = 0
    let currencies = [
        "$", "лв","₾", "₽", "₦", "R", "€", "¥", "元", "₹", "₩", "฿", "₫",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currencyPicker.delegate = self
        self.currencyPicker.dataSource = self
        showTipSlider.isOn = tipSliderOn
        if UserDefaults.standard.object(forKey: "DefaultTip") != nil {
            tipSlider.value = UserDefaults.standard.float(forKey: "DefaultTip")
            didChangeTipSlider(tipSlider)
        }
        selectedRow = UserDefaults.standard.integer(forKey: "currRow") ?? 0
        currencyPicker.selectRow(selectedRow, inComponent: 0, animated: false)
        print(currencies.count)
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
    
    @IBAction func backgroundSliderChanged(_ sender: Any) {
        let currentValue = backgroundSlider.value
        var green = CGFloat(-7 * (currentValue - 2) * (currentValue - 2) + 2) * 128
        if green < 0 {
            green = 0
        }
        print(currentValue)
        print("red", (cos(CGFloat(currentValue)) + 1) * 128)
        print("blue", (-1 * cos(CGFloat(currentValue)) + 1) * 128)
        print("green", green)
        let backgroundColor = UIColor(
            red: (cos(CGFloat(currentValue)) + 1) * 128,
            green: green,
            blue: (-1 * cos(CGFloat(currentValue)) + 1) * 128,
            alpha: 1.0
        )
        backgroundSlider.thumbTintColor = backgroundColor
        mainController.view.backgroundColor = backgroundColor
    }
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        mainController.tipVisibility(shown: showTipSlider.isOn)
        if !showTipSlider.isOn {
            mainController.setTip(tip: tipSlider.value)
        }
        UserDefaults.standard.set( selectedRow,forKey: "currRow")
        UserDefaults.standard.set(tipSlider.value, forKey: "DefaultTip")
        UserDefaults.standard.set(showTipSlider.isOn, forKey: "showTipSlider")
        mainController.setCurr(sym: currencies[selectedRow])
        dismiss(animated: true)
    }
    @IBAction func didChangeTipSlider(_ sender: Any) {
        tipSlider.value = round(tipSlider.value * 100) / 100
        tipAmount.text = String(format: "%d %%", Int(round(tipSlider.value * 100)))
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
