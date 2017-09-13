//
//  ViewController.swift
//  India Helper
//
//  Created by Raphael Arce on 22.06.17.
//  Copyright © 2017 Raphael Arce. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate  {
    
    
    //TODO Create new Picker on the Right, modify the one on the left so both are independent -> ALMOST DONE
        //-> make a better architecture for currency exchange rates
    //TODO Make currency unit reappear when changing from custom to other currency
    //TODO Use new API, modify parsing of JSON
    //TODO Make Customizable rates (make text fields appear and disappear and so on)
    //TODO Algorithm for proper separation (indian model and occidental model)
    //TODO Try other colors
    //TODO Make all elements dependent on size of screen
    //TODO make all changements on the elements asynchronous through dispatchQueue.main.async {}
    
    @IBOutlet weak var lakhField: UITextField!

    @IBOutlet weak var thousandField: UITextField!
    
    @IBOutlet weak var croreField: UITextField!
    
    @IBOutlet weak var millionField: UITextField!
    
    @IBOutlet weak var lakhCroreField: UITextField!
    
    @IBOutlet weak var billionField: UITextField!
    
    @IBOutlet weak var rightCustomExchangeRate: UITextField!
    
    @IBOutlet weak var leftCustomExchangeRate: UITextField!
    
    @IBOutlet weak var leftCurrencyPicker: UIPickerView!
    
    @IBOutlet weak var rightCurrencyPicker: UIPickerView!
    
    @IBOutlet weak var exchangeRateLabel: UILabel!
    
    @IBOutlet weak var updateButton: UIButton!
    
    @IBOutlet weak var infoButton: UIButton!
    
    @IBOutlet weak var thousandCurrencyLabel: UILabel!
    
    @IBOutlet weak var millionCurrencyLabel: UILabel!
    
    @IBOutlet weak var billionCurrencyLabel: UILabel!
    
    @IBOutlet weak var lakhCurrencyLabel: UILabel!
    
    @IBOutlet weak var croreCurrencyLabel: UILabel!
    
    @IBOutlet weak var lakhCroreCurrencyLabel: UILabel!
    
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var lastInput: String = "Thousand"
    
    var EURToINR: Double = 0
    var EURToLKR: Double = 0
    var EURToBDT: Double = 0
    
    var USDToINR: Double = 0
    var USDToLKR: Double = 0
    var USDToBDT: Double = 0
    
    var currentlySelectedExchangeRate: Double = 1
    
    var currentlySelectedLeftCurrency: String = "EUR"
    var currentlySelectedLeftRow: Int = 0

    var currentlySelectedRightCurrency: String = "INR"
    
    var currentExchangeRates: [String : Any] = [:]
    
//    class CurrencyPickerSource: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
        let leftCurrencies = ["EUR", "USD", "Custom"]
        let rightCurrencies = ["INR", "NPR", "LKR", "BDT"]
    
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if(pickerView == leftCurrencyPicker) {
                return leftCurrencies.count
            } else {
                return rightCurrencies.count
            }
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if(pickerView == leftCurrencyPicker) {
                return leftCurrencies[row]
            } else {
                return rightCurrencies[row]
            }
        }
    
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
        {
            if(pickerView == leftCurrencyPicker) {
                currentlySelectedLeftCurrency = leftCurrencies[row]
                currentlySelectedLeftRow = row
                if(row == 0)
                {
                    currentlySelectedExchangeRate = getExchangeRateFromCurrencies(from: "EUR", to: currentlySelectedRightCurrency)
                    print("currentlySelectedExchangeRate:" + String(currentlySelectedExchangeRate))
                    
                    DispatchQueue.main.async {
                        
                        self.updateButton.isEnabled = true
                        self.lastUpdateLabel.isHidden = false
                        
                        self.lakhCurrencyLabel.isHidden = false
                        self.croreCurrencyLabel.isHidden = false
                        self.lakhCroreCurrencyLabel.isHidden = false
                        
                        self.rightCustomExchangeRate.isHidden = true
                        self.leftCustomExchangeRate.isHidden = true
                        self.rightCurrencyPicker.isUserInteractionEnabled = true
                        
                        self.rightCurrencyPicker.alpha = 1
                        
                        self.thousandCurrencyLabel.text = "€"
                        self.millionCurrencyLabel.text = "€"
                        self.billionCurrencyLabel.text = "€"
                        
                        self.updateCurrentlySelectedTextfield()
                        if(self.currentExchangeRates.isEmpty) {
                            self.exchangeRateLabel.text = "..."
                        } else {
                            self.infoButton.isHidden = false
                            self.exchangeRateLabel.text = "1€ = " + String(format: "%.2f", self.currentlySelectedExchangeRate) + self.lakhCurrencyLabel.text!
                        }
                    }
                    
                }
                else if(row == 1)
                {
                    currentlySelectedExchangeRate = getExchangeRateFromCurrencies(from: "USD", to: currentlySelectedRightCurrency)
                    print("currentlySelectedExchangeRate:" + String(currentlySelectedExchangeRate))
                    
                    DispatchQueue.main.async {
                        
                        self.thousandCurrencyLabel.text = "$"
                        self.millionCurrencyLabel.text = "$"
                        self.billionCurrencyLabel.text = "$"
                        
                        self.updateButton.isEnabled = true
                        self.lastUpdateLabel.isHidden = false
                        
                        self.lakhCurrencyLabel.isHidden = false
                        self.croreCurrencyLabel.isHidden = false
                        self.lakhCroreCurrencyLabel.isHidden = false
                        
                        self.rightCustomExchangeRate.isHidden = true
                        self.leftCustomExchangeRate.isHidden = true
                        self.rightCurrencyPicker.isUserInteractionEnabled = true
                        self.rightCurrencyPicker.alpha = 1
                        
                        if(self.currentExchangeRates.isEmpty) {
                            self.exchangeRateLabel.text = "..."
                        } else {
                            self.infoButton.isHidden = true
                            self.exchangeRateLabel.text = "1$ = " + String(format: "%.2f", self.currentlySelectedExchangeRate) + self.lakhCurrencyLabel.text!
                        }
                        
                        self.updateCurrentlySelectedTextfield()
                    }
                    
                    
                }
                else if(row == 2)
                {
                    DispatchQueue.main.async {
                        if let rightCustomValue = Double(self.leftCustomExchangeRate.text!) {
                            if let leftCustomValue = Double(self.leftCustomExchangeRate.text!) {
                                self.currentlySelectedExchangeRate = rightCustomValue/leftCustomValue
                                self.updateCurrentlySelectedTextfield()
                            } else {
                                print("left custom value error")
                            }
                        } else {
                            print("right custom value error")
                        }
                        
                        self.updateButton.isEnabled = false
                        self.lastUpdateLabel.isHidden = true
                        self.infoButton.isHidden = true
                        
                        self.thousandCurrencyLabel.text = ""
                        self.millionCurrencyLabel.text = ""
                        self.billionCurrencyLabel.text = ""
                        
                        self.lakhCurrencyLabel.isHidden = true
                        self.croreCurrencyLabel.isHidden = true
                        self.lakhCroreCurrencyLabel.isHidden = true
                        
                        self.exchangeRateLabel.text = ":"
                        self.rightCustomExchangeRate.isHidden = false
                        self.leftCustomExchangeRate.isHidden = false
                        self.rightCurrencyPicker.isUserInteractionEnabled = false
                        
                        self.rightCurrencyPicker.alpha = 0.3
                    }
                }
            } else {
                currentlySelectedRightCurrency = rightCurrencies[row]
                if(row==0) {
                    DispatchQueue.main.async {
                        self.currentlySelectedRightCurrency = "INR"
                        
                        self.currentlySelectedExchangeRate = self.getExchangeRateFromCurrencies(from: self.currentlySelectedLeftCurrency, to: self.currentlySelectedRightCurrency)
                        
                        self.lakhCurrencyLabel.text = "₹"
                        self.croreCurrencyLabel.text = "₹"
                        self.lakhCroreCurrencyLabel.text = "₹"
                        
                        self.updateCurrentlySelectedTextfield()
                        
                        if(self.currentExchangeRates.isEmpty) {
                            self.exchangeRateLabel.text = "..."
                        } else {
                            self.exchangeRateLabel.text = "1" + self.thousandCurrencyLabel.text! + " = " + String(format: "%.2f", self.currentlySelectedExchangeRate) + self.lakhCurrencyLabel.text!
                        }
                    }

                } else if (row == 1) {
                    DispatchQueue.main.async {
                        self.currentlySelectedRightCurrency = "NPR"
                        
                        self.currentlySelectedExchangeRate = self.getExchangeRateFromCurrencies(from: self.currentlySelectedLeftCurrency, to: self.currentlySelectedRightCurrency)
                        
                        self.lakhCurrencyLabel.text = "रु"
                        self.croreCurrencyLabel.text = "रु"
                        self.lakhCroreCurrencyLabel.text = "रु"
                        
                        self.updateCurrentlySelectedTextfield()
                        
                        if(self.currentExchangeRates.isEmpty) {
                            self.exchangeRateLabel.text = "..."
                        } else {
                            self.exchangeRateLabel.text = "1" + self.thousandCurrencyLabel.text! + " = " + String(format: "%.2f", self.currentlySelectedExchangeRate) + self.lakhCurrencyLabel.text!
                        }
                    }

                    
                } else if (row == 2) {
                    DispatchQueue.main.async {
                        self.currentlySelectedRightCurrency = "LKR"
                        
                        self.currentlySelectedExchangeRate = self.getExchangeRateFromCurrencies(from: self.currentlySelectedLeftCurrency, to: self.currentlySelectedRightCurrency)
                        
                        self.lakhCurrencyLabel.text = "රු"
                        self.croreCurrencyLabel.text = "රු"
                        self.lakhCroreCurrencyLabel.text = "රු"
                        
                        self.updateCurrentlySelectedTextfield()
                        
                        if(self.currentExchangeRates.isEmpty) {
                            self.exchangeRateLabel.text = "..."
                        } else {
                            self.exchangeRateLabel.text = "1" + self.thousandCurrencyLabel.text! + " = " + String(format: "%.2f", self.currentlySelectedExchangeRate) + self.lakhCurrencyLabel.text!
                        }
                    }
                } else if (row == 3) {
                    DispatchQueue.main.async {
                        self.currentlySelectedRightCurrency = "BDT"
                        
                        self.currentlySelectedExchangeRate = self.getExchangeRateFromCurrencies(from: self.currentlySelectedLeftCurrency, to: self.currentlySelectedRightCurrency)
                        
                        self.lakhCurrencyLabel.text = "৳"
                        self.croreCurrencyLabel.text = "৳"
                        self.lakhCroreCurrencyLabel.text = "৳"
                        
                        self.updateCurrentlySelectedTextfield()
                        
                        if(self.currentExchangeRates.isEmpty) {
                            self.exchangeRateLabel.text = "..."
                        } else {
                            self.exchangeRateLabel.text = "1" + self.thousandCurrencyLabel.text! + " = " + String(format: "%.2f", self.currentlySelectedExchangeRate) + self.lakhCurrencyLabel.text!
                        }
                    }
                }
            }
        }
 
    
    func updateCurrentlySelectedTextfield() {
        if(lastInput == "Thousand") {
            fromThousand(value: thousandField.text!)
        } else if (lastInput == "Lakh") {
            fromLakh(value: lakhField.text!)
        } else if (lastInput == "Million") {
            fromMillion(value: lakhField.text!)
        } else if (lastInput == "Crore") {
            fromCrore(value: croreField.text!)
        } else if (lastInput == "Billion") {
            fromBillion(value: billionField.text!)
        } else if (lastInput == "LakhCrore") {
            fromLakhCrore(value: lakhCroreField.text!)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        //

        self.leftCurrencyPicker.dataSource = self
        self.leftCurrencyPicker.delegate = self
        self.leftCurrencyPicker.selectedRow(inComponent: 0)
        
        self.rightCurrencyPicker.dataSource = self
        self.rightCurrencyPicker.delegate = self
        self.rightCurrencyPicker.selectedRow(inComponent: 0)
        
        //self.leftCustomExchangeRate
        
        //getExchangeRatesFromAPI(currency: "EUR")
        getExchangeRatesFromAPI()
        
        self.scrollView.isScrollEnabled = false
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        scrollBack()
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
        {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardY = keyboardRectangle.minY
            if(!leftCustomExchangeRate.isEditing && !rightCustomExchangeRate.isEditing) {
                let scrollAmount = billionField.frame.maxY - keyboardY + 20
                if(scrollAmount > 0) {
                    DispatchQueue.main.async {
                        self.scrollView.setContentOffset(CGPoint(x: 0, y: scrollAmount), animated: true)
                    }
                }
                
            }
        }
    }
    
    func scrollBack() {
        DispatchQueue.main.async {
            self.scrollView.setContentOffset(CGPoint(x: 0, y:0), animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setCustomRateTextFieldsIsHidden(isHidden: Bool) {
        leftCustomExchangeRate.isHidden = isHidden
        rightCustomExchangeRate.isHidden = isHidden
    }
    
    func getExchangeRateFromCurrencies(from: String, to: String) -> Double {
        if(currentExchangeRates.isEmpty) {
            return 1
        } else {
            if let _from = currentExchangeRates[from] as? Double {
                if let _to = currentExchangeRates[to] as? Double {
                    return _to/_from
                } else {
                    return 1
                }
            } else {
                return 1
            }
        }
    }
    
    func getExchangeRatesFromAPI() {
        let url = URL(string: "https://openexchangerates.org/api/latest.json?app_id=8395ca05d1da40fc8769e1a17142c864")
        
        lockUpdateButton()
//        _ = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(unlockUpdateButton), userInfo: nil, repeats: false)
        
        print("calling " + (url?.absoluteString)!)
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            
            guard error == nil else {
                print(error!)
                DispatchQueue.main.async {
                    self.unlockUpdateButton(wasSuccessfull: false)
                }
                return
            }
            guard let data = data else {
                print("Data is empty")
                DispatchQueue.main.async {
                    self.unlockUpdateButton(wasSuccessfull: false)
                }
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            //print(json)
            
            if let dictionary = json as? [String: Any] {
                print("RESULT")
                print(dictionary)
                if let rates = dictionary["rates"] as? [String : Any] {
                    print(rates)
                    print(rates["INR"]!)
                    self.currentExchangeRates = rates
                    if let timestamp = dictionary["timestamp"] as? Double {
                        print(timestamp)
                        let date = Date(timeIntervalSince1970: timestamp)
                        let dayTimePeriodFormatter = DateFormatter()
                        dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
                        DispatchQueue.main.async {
                            if let from = rates[self.currentlySelectedLeftCurrency] as? Double {
                                if let to = rates[self.currentlySelectedRightCurrency] as? Double {
                                    self.exchangeRateLabel.text = "1" + self.thousandCurrencyLabel.text! + " = " + String(format: "%.2f", to/from) + self.lakhCurrencyLabel.text!
                                    self.currentlySelectedExchangeRate = self.getExchangeRateFromCurrencies(from: self.currentlySelectedLeftCurrency, to: self.currentlySelectedRightCurrency)
                                }
                            }
                            self.infoButton.isHidden = false
                            self.lastUpdateLabel.text = "(" + dayTimePeriodFormatter.string(from: date) + ")"
                        }
                    }
                    DispatchQueue.main.async {
                        self.unlockUpdateButton(wasSuccessfull: true)
                        //self.leftCurrencyPicker.selectedRow(inComponent: self.currentlySelectedLeftRow)
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.unlockUpdateButton(wasSuccessfull: false)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.unlockUpdateButton(wasSuccessfull: false)
                }
            }
        }
        task.resume()
    }
    
    @IBAction func updateButtonOnClicked(_ sender: Any) {
        getExchangeRatesFromAPI()
        //getExchangeRatesFromAPI(currency: "USD")
    }
    
    @IBAction func infoButtonOnClicked(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "EUR rates are calculated with USD base. \nRates from the ECB might be different.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func unlockUpdateButton(wasSuccessfull: Bool) {
        
        if(!wasSuccessfull) {
            let alert = UIAlertController(title: "Could not load newest exchange rates", message: "Please check your internet connection and try again.\nIf it works and the problem persists, please use the custom rates.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        if(currentlySelectedRightCurrency == "EUR") {
            print("changing the exchange rate label")
            self.exchangeRateLabel.text = "1€ = " + String(currentlySelectedExchangeRate) + lakhCurrencyLabel.text!
            self.currentlySelectedExchangeRate = self.EURToINR
        } else if (currentlySelectedRightCurrency == "USD") {
            print("changing the exchange rate label")
            self.exchangeRateLabel.text = "1$ = " + String(currentlySelectedExchangeRate) + lakhCurrencyLabel.text!
            self.currentlySelectedExchangeRate = self.USDToINR
        } else if(currentlySelectedRightCurrency == "custom") {
            print("changing the exchange rate label")
            self.exchangeRateLabel.text = ":"
            if let rightCustomValue = Double(leftCustomExchangeRate.text!) {
                if let leftCustomValue = Double(leftCustomExchangeRate.text!) {
                    currentlySelectedExchangeRate = rightCustomValue/leftCustomValue
                    updateCurrentlySelectedTextfield()
                } else {
                    print("left custom value error")
                }
            } else {
                print("right custom value error")
            }
        }
        print("reenable the button")
        updateCurrentlySelectedTextfield()
        self.updateButton.isEnabled = true
    }
    
    func lockUpdateButton() {
        self.exchangeRateLabel.text = "..."
        self.lastUpdateLabel.text = ""
        updateButton.isEnabled = false
    }
    
    @IBAction func thousandOnValueChanged(_ sender: UITextField, forEvent event: UIEvent) {
        lastInput = "Thousand"
        fromThousand(value: sender.text!)
        //setThousand(value: sender.text!)
    }
    
    @IBAction func lakhOnValueChanged(_ sender: UITextField,forEvent event: UIEvent) {
        lastInput = "Lakh"
        fromLakh(value: sender.text!)
        //setLakh(value: sender.text!)
    }
    
    @IBAction func millionOnValueChanged(_ sender: UITextField, forEvent event: UIEvent) {
        lastInput = "Million"
        fromMillion(value: sender.text!)
        //setMillion(value: sender.text!)
    }
    
    @IBAction func croreOnValueChanged(_ sender: UITextField, forEvent event: UIEvent) {
        lastInput = "Crore"
        fromCrore(value: sender.text!)
        //setCrore(value: sender.text!)
    }
    
    @IBAction func billionOnValueChanged(_ sender: UITextField, forEvent event: UIEvent) {
        lastInput = "Billion"
        fromBillion(value: sender.text!)
        //setBillion(value: sender.text!)
    }
    
    @IBAction func lakhCroreOnValueChanged(_ sender: UITextField, forEvent event: UIEvent) {
        lastInput = "LakhCrore"
        fromLakhCrore(value: sender.text!)
        //setLakhCrore(value: sender.text!)
    }

    @IBAction func leftCustomOnValueChanged(_ sender: UITextField, forEvent event: UIEvent) {
        if let value = sender.text {
            if(!value.isEmpty) {
                if let leftCustomValue = Double(value) {
                    if let rightCustomValue = Double(rightCustomExchangeRate.text!) {
                        currentlySelectedExchangeRate = rightCustomValue/leftCustomValue
                        print("currentlySelectedExchangeRate:" + String(currentlySelectedExchangeRate))
                        updateCurrentlySelectedTextfield()
                    } else {
                        print("right custom value error")
                    }
                } else {
                    print("left custom value error")
                }
            }
        }
    }
    
    
    @IBAction func rightCustomOnValueChanged(_ sender: UITextField, forEvent event: UIEvent) {
        if let value = sender.text {
            if(!value.isEmpty) {
                if let rightCustomValue = Double(value) {
                    if let leftCustomValue = Double(leftCustomExchangeRate.text!) {
                        currentlySelectedExchangeRate = rightCustomValue/leftCustomValue
                        print("currentlySelectedExchangeRate:" + String(currentlySelectedExchangeRate))
                        updateCurrentlySelectedTextfield()
                    } else {
                        print("left custom value error")
                    }
                } else {
                    print("right custom value error")
                }
            }
        }
    }
    
    func convertToIndian(value: String) -> String {
        print("pre conversion: " + value)
        var indian = ""
        if(value.contains(".")) {
            let arr = value.replacingOccurrences(of: ",", with: "").components(separatedBy: ".")
            let newValue = arr[0]
            var i = newValue.characters.count - 1
            var u = 1
            while (i > -1) {
                indian.insert(newValue[newValue.index(newValue.startIndex, offsetBy: i)], at: newValue.startIndex)
                if(u % 2 == 0) && (u != newValue.characters.count) {
                    indian.insert(",", at: value.startIndex)
                }
                u += 1
                i -= 1
            }
            indian.append("." + arr[1])
        } else {
            var i = value.replacingOccurrences(of: ",", with: "").characters.count - 1
            var u = 1
            while (i > -1) {
                indian.insert(value[value.index(value.startIndex, offsetBy: i)], at: value.startIndex)
                if(u % 2 == 0) && (u != value.characters.count) {
                    indian.insert(",", at: value.startIndex)
                }
                u += 1
                i -= 1
            }
        }
        print("indian: " + indian)
        return indian
        //return value
    }
    
    func convertToMetric(value: String) -> String {
        print("pre conversion: " + value)
        var metric = ""
        if(value.contains(".")) {
            let arr = value.replacingOccurrences(of: ",", with: "").components(separatedBy: ".")
            let newValue = arr[0]
            var i = newValue.characters.count - 1
            var u = 1
            while (i > -1) {
                metric.insert(newValue[newValue.index(newValue.startIndex, offsetBy: i)], at: newValue.startIndex)
                if(u % 3 == 0) && (u != newValue.characters.count) {
                    metric.insert(",", at: value.startIndex)
                }
                u += 1
                i -= 1
            }
            metric.append("." + arr[1])
        } else {
            var i = value.replacingOccurrences(of: ",", with: "").characters.count - 1
            var u = 1
            while (i > -1) {
                metric.insert(value[value.index(value.startIndex, offsetBy: i)], at: value.startIndex)
                if(u % 3 == 0) && (u != value.characters.count) {
                    metric.insert(",", at: value.startIndex)
                }
                u += 1
                i -= 1
            }
        }
        print("metric: " + metric)
        return metric
        //return value
    }
    
    
    
    func reset() {
        lakhField.text = ""
        croreField.text = ""
        thousandField.text = ""
        millionField.text = ""
        billionField.text = ""
        lakhCroreField.text = ""
    }
    
    func fromThousand(value: String) {
        if(value.isEmpty) {
            reset()
        }
        else if let number = Double(stringNumberWithoutPunctuation(value: value)) {
            setThousandAsString(value: stringNumberWithoutPunctuation(value: value))
            
            let lakh: Double = (number * currentlySelectedExchangeRate) / 100
            setLakh(value: lakh)
            
            let million: Double = number / 1000
            setMillion(value: million)
            
            let crore: Double = (number * currentlySelectedExchangeRate) / 10000
            setCrore(value: crore)
            
            let billion: Double = (number) / 1000000
            setBillion(value: billion)
            
            let lakhCrore: Double = (number * currentlySelectedExchangeRate) / 10000000
            setLakhCrore(value: lakhCrore)
        }
    }
    
    func fromLakh(value: String) {
        if(value.isEmpty) {
            reset()
        }
        else if let number = Double(stringNumberWithoutPunctuation(value: value)) {
            let thousand: Double = (number / currentlySelectedExchangeRate) * 100
            setThousand(value: thousand)
            
            setLakhAsString(value: stringNumberWithoutPunctuation(value: value))
            
            let million: Double = (number / currentlySelectedExchangeRate) / 10
            setMillion(value: million)
            
            let crore: Double = number / 100
            setCrore(value: crore)
            
            let billion: Double = (number / currentlySelectedExchangeRate) / 10000
            setBillion(value: billion)
            
            let lakhCrore: Double = (number) / 10000000
            setLakhCrore(value: lakhCrore)
        }
    }
    
    func fromMillion(value: String) {
        if(value.isEmpty) {
            reset()
        }
        else if let number = Double(stringNumberWithoutPunctuation(value: value)) {
            
            let thousand: Double = number * 1000
            setThousand(value: thousand)
            
            let lakh: Double = (number * currentlySelectedExchangeRate) * 100
            setLakh(value: lakh)
            
            setMillionAsString(value: stringNumberWithoutPunctuation(value: value))
            
            let crore: Double = (number * currentlySelectedExchangeRate) / 10
            setCrore(value: crore)
            
            let billion: Double = (number) / 1000
            setBillion(value: billion)
            
            let lakhCrore: Double = (number * currentlySelectedExchangeRate) / 1000000
            setLakhCrore(value: lakhCrore)
        }
    }
    
    func fromCrore(value: String) {
        if(value.isEmpty) {
            reset()
        }
        else if let number = Double(stringNumberWithoutPunctuation(value: value)) {
            let thousand: Double = (number / currentlySelectedExchangeRate) * 10000
            setThousand(value: thousand)
            
            let lakh: Double = number  * 100
            setLakh(value: lakh)
            
            let million: Double = (number / currentlySelectedExchangeRate) * 10
            setMillion(value: million)
            
            setCroreAsString(value: stringNumberWithoutPunctuation(value: value))
            
            let billion: Double = (number / currentlySelectedExchangeRate) * 10000000
            setBillion(value: billion)
            
            let lakhCrore: Double = (number) * 10000000
            setLakhCrore(value: lakhCrore)
        }
    }
    
    func fromBillion(value: String) {
        if(value.isEmpty) {
            reset()
        }
        else if let number = Double(stringNumberWithoutPunctuation(value: value)) {
            let thousand: Double = (number) * 1000000
            setThousand(value: (thousand))
            
            let lakh: Double = number * currentlySelectedExchangeRate * 10000
            setLakh(value: lakh)
            
            let million: Double = (number) * 1000
            setMillion(value: million)
            
            let crore: Double = (number * currentlySelectedExchangeRate) / 10
            setCrore(value: crore)
            
            setBillionAsString(value: stringNumberWithoutPunctuation(value: value))
            
            let lakhCrore: Double = (number * currentlySelectedExchangeRate) / 1000
            setLakhCrore(value: lakhCrore)
        }
    }
    
    func fromLakhCrore(value: String) {
        if(value.isEmpty) {
            reset()
        }
        else if let number = Double(stringNumberWithoutPunctuation(value: value)) {
            let thousand: Double = (number / currentlySelectedExchangeRate) * 1000000000
            setThousand(value: thousand)
            
            let lakh: Double = (number) * 10000000
            setLakh(value: lakh)
            
            let million: Double = (number / currentlySelectedExchangeRate) * 1000000
            setMillion(value: million)
            
            let crore: Double = (number) * 100000
            setCrore(value: crore)
            
            let billion: Double = (number / currentlySelectedExchangeRate) * 1000
            setBillion(value: billion)
            
            setLakhCroreAsString(value: stringNumberWithoutPunctuation(value: value))
        }
        
    }
    
    func setThousand(value: Double) {
        print("setting thousand")
        DispatchQueue.main.async {
            if(floor(value) == value) {
                self.thousandField.text = self.convertToMetric(value: String(Int(value)))
            } else {
                self.thousandField.text = self.convertToMetric(value: String(format: "%.2f", value))
            }
        }
    }
    
    func setThousandAsString(value: String) {
        print("setting thousand as string")
        DispatchQueue.main.async {
            self.thousandField.text = self.convertToMetric(value: value)
        }
    }
    
    func setLakh(value: Double) {
        print("setting lakh")
        DispatchQueue.main.async {
            if(floor(value) == value) {
                self.lakhField.text = self.convertToIndian(value: String(Int(value)))
            } else {
                self.lakhField.text = self.convertToIndian(value: String(format: "%.2f", value))
            }
        }
    }
    
    func setLakhAsString(value: String) {
        print("setting lakh as string")
        DispatchQueue.main.async {
            self.lakhField.text = self.convertToIndian(value: value)
        }
    }
    
    func setMillion(value: Double) {
        print("setting million")
        DispatchQueue.main.async {
            if(floor(value) == value) {
                self.millionField.text = self.convertToMetric(value: String(Int(value)))
            } else {
                self.millionField.text = self.convertToMetric(value: String(format: "%.2f", value))
            }
        }
    }
    
    func setMillionAsString(value: String) {
        print("setting thousand as string")
        DispatchQueue.main.async {
            self.millionField.text = self.convertToMetric(value: value)
        }
    }
    
    func setCrore(value: Double) {
        print("setting crore")
        DispatchQueue.main.async {
            if(floor(value) == value) {
                self.croreField.text = self.convertToIndian(value: String(Int(value)))
            } else {
                self.croreField.text = self.convertToIndian(value: String(format: "%.2f", value))
            }
        }
    }

    func setCroreAsString(value: String) {
        print("setting lakh as string")
        DispatchQueue.main.async {
            self.croreField.text = self.convertToIndian(value: value)
        }
    }
    
    
    func setBillion(value: Double) {
        print("setting billion")
        DispatchQueue.main.async {
            if(floor(value) == value) {
                self.billionField.text = self.convertToMetric(value: String(Int(value)))
            } else {
                self.billionField.text = self.convertToMetric(value: String(format: "%.2f", value))
            }
        }
    }
    
    func setBillionAsString(value: String) {
        print("setting thousand as string")
        DispatchQueue.main.async {
            self.billionField.text = self.convertToMetric(value: value)
        }
    }
    
    func setLakhCrore(value: Double) {
        print("setting lakhCrore")
        DispatchQueue.main.async {
            if(floor(value) == value) {
                self.lakhCroreField.text = self.convertToIndian(value: String(Int(value)))
            } else {
                self.lakhCroreField.text = self.convertToIndian(value: String(format: "%.2f", value))
            }
        }
    }
    
    func setLakhCroreAsString(value: String) {
        print("setting lakh as string")
        DispatchQueue.main.async {
            self.lakhCroreField.text = self.convertToIndian(value: value)
        }
    }
    
    
    func stringNumberWithoutPunctuation(value: String) -> String {
        return value.replacingOccurrences(of: ",", with: "")
    }
}
