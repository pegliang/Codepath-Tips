//
//  ViewController.swift
//  TipCalculator
//
//  Created by John Jakobsen on 9/3/20.
//  Copyright © 2020 Peggie Liang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var billAmountField: UITextField!
    @IBOutlet weak var tipPercentageLabel: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var tipSlider: UISlider!
    var tipSliderHidden: Bool! = false
    var symbol: String!
    let currencies = [
        "$", "лв","₾", "₽", "₦", "R", "€", "¥", "元", "₹", "₩", "฿", "₫",
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        billAmountField.becomeFirstResponder()
        if UserDefaults.standard.object(forKey: "showTipSlider") != nil {
            tipSliderHidden = !UserDefaults.standard.bool(forKey: "showTipSlider")
        }
        // Resets after 5 minutes
        if UserDefaults.standard.object(forKey: "lastSaved") != nil && (UserDefaults.standard.object(forKey: "lastSaved") as! Date).distance(to: Date()) < 300 {
            billAmountField.text =  UserDefaults.standard.string(forKey: "billAmount") ?? ""
            tipSlider.value = UserDefaults.standard.float(forKey: "tip")
            tipSlider.isHidden = !UserDefaults.standard.bool(forKey: "showTipSlider")
            tipSliderHidden = tipSlider.isHidden
            if UserDefaults.standard.object(forKey: "DefaultTip") != nil {
                tipSlider.value = UserDefaults.standard.float(forKey: "DefaultTip")
            } else {
                tipSlider.value = UserDefaults.standard.float(forKey: "tip")
            }
            billAmountChanged()
        } else {
            UserDefaults.standard.set("", forKey: "billAmount")
            UserDefaults.standard.set(0.0, forKey: "tip")
        }
        if UserDefaults.standard.object(forKey: "DefaultTip") != nil {
            tipSlider.value = UserDefaults.standard.float(forKey: "DefaultTip")
        }
        symbol = currencies[UserDefaults.standard.integer(forKey: "currRow") ?? 0]
        tipSliderChanged(tipSlider)
        totalAmount.text = symbol + String(totalAmount.text!.suffix(totalAmount.text!.count - 1))
        UserDefaults.standard.set(Date(), forKey: "lastSaved")
    }

    
    @IBAction func tipSliderChanged(_ sender: Any) {
        tipSlider.value = round(tipSlider.value * 100) / 100
        tipPercentageLabel.text = String(format: "%d %%", Int(round(tipSlider.value * 100)))
        billAmountChanged()
    }
    

    @IBAction func billAmountChanged(_ sender: Any) {
        UserDefaults.standard.set(billAmountField.text ?? 0, forKey: "billAmount")
        UserDefaults.standard.set(tipSlider.value, forKey: "tip")
        UserDefaults.standard.set(Date(), forKey: "lastSaved")
        billAmountChanged()
    }
    func billAmountChanged() {
        let billAmount: Float = Float(billAmountField.text!) ?? 0
        totalAmount.text = String(format: "%@ %.2f",symbol ?? "$" ,billAmount * (tipSlider.value + 1.0))
    }
    func setTip(tip: Float) {
        tipSlider.value = tip
        tipSliderChanged(tipSlider)
    }
    func tipVisibility(shown: Bool) {
        tipSlider.isHidden = !shown
        tipSliderHidden = !shown
    }
    func setCurr(sym: String) {
        symbol = sym
        totalAmount.text = symbol + String(totalAmount.text!.suffix(totalAmount.text!.count - 1))
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let settings = segue.destination as! SettingsViewController
        settings.mainController = self
        settings.tipSliderOn = !tipSliderHidden
    }
}

