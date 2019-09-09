

import UIKit

enum TimeType {
    case month, year
}

class ViewController: UIViewController {
    
    var timeType: TimeType = .month {
        didSet {
            if timeType == .month {
                timeTypeButton.setTitle(NSLocalizedString("months", comment: ""), for: .normal)
            } else {
                timeTypeButton.setTitle(NSLocalizedString("years", comment: ""), for: .normal)
            }
        }
    }
    
    var device: IPhones!
    let shadowView = UIView()
    
    var differPopup: DifferPopupView!
    var annuitPopup: AnnuitPopupView!
    
    @IBOutlet var infoPopupView: UIView!
    
    @IBOutlet weak var paymentTypeTitle: UILabel!
    @IBOutlet weak var paymentTypeInfoButton: UIButton!
    
    @IBOutlet weak var timeTypeButton: UIButton!
    
    
    @IBOutlet weak var mainLine: UIView!
    @IBOutlet weak var mainTitleHeight: NSLayoutConstraint!
    @IBOutlet weak var mainTitleBottom: NSLayoutConstraint!
    @IBOutlet weak var buttonsHeight: NSLayoutConstraint!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var leftSpace: NSLayoutConstraint!
    @IBOutlet weak var rightSpace: NSLayoutConstraint!
    
    @IBOutlet weak var sumField: UITextField!
    @IBOutlet weak var percentField: UITextField!
    @IBOutlet weak var monthsField: UITextField!
    
    @IBOutlet weak var paymentType: UISegmentedControl!
    
    @objc func openShadow() {
        shadowView.backgroundColor = UIColor.black
        shadowView.alpha = 0
        shadowView.frame.size = self.view.frame.size
        shadowView.center.x = self.view.frame.width/2
        shadowView.center.y = self.view.frame.height/2
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapShadowHandler))
        shadowView.addGestureRecognizer(gesture)
        
        
        self.view.addSubview(shadowView)
        UIView.animate(withDuration: 0.25, animations: {
            self.shadowView.alpha = 0.7
        })
    }
    
    @objc func closeShadow() {
        UIView.animate(withDuration: 0.25, animations: {
            self.shadowView.alpha = 0
        }, completion: { _ in
            self.shadowView.removeFromSuperview()
        })
    }
    
    
    func showDifferPopup() {
        print("show")
        var months = Int(monthsField.text ?? "0") ?? 0
        if timeType == .year {
            months = months*12
        }
        let percent = NumberFormatter().number(from: percentField.text ?? "0") ?? 0
        let sum = Int(sumField.text?.stringByRemovingWhitespaces ?? "0") ?? 0
        
        DispatchQueue.main.async {
            self.differPopup = DifferPopupView.createPopup(months: months, percent: CGFloat(truncating: percent), sum: sum, rootVC: self)
            self.view.addSubview(self.differPopup)
        }
    }
    

    func showAnnuitPopup() {
        var months = Int(monthsField.text ?? "0") ?? 0
        
        if timeType == .year {
            months = months*12
        }
        
        let percent = NumberFormatter().number(from: percentField.text?.replacingOccurrences(of: ".", with: ",") ?? "0") ?? 0
        print("percent", percent)
        let sum = Int(sumField.text?.stringByRemovingWhitespaces ?? "0") ?? 0
        
        DispatchQueue.main.async {
            self.annuitPopup = AnnuitPopupView.createPopup(months: months, percent: CGFloat(truncating: percent), sum: sum, rootVC: self)
            self.view.addSubview(self.annuitPopup)
        }
    }
    
    
    func closeAnnuitPopup() {
        annuitPopup.closePopup()
    }
    
    func checkFields() -> Bool {
        var isOk = true
        if sumField.text == "" || sumField.text == "0" {
            isOk = false
            sumField.shake()
        }
        
        if percentField.text == "" || percentField.text == "0" {
            isOk = false
            percentField.shake()
        }
        
        if monthsField.text == "" || monthsField.text == "0" {
            isOk = false
            monthsField.shake()
        }
        return isOk
    }
    

    @objc func tapShadowHandler() {
        differPopup?.closePopup()
        annuitPopup?.closePopup()
    }

    @IBAction func timeTypeAction(_ sender: Any) {
        if timeType == .month {
            timeType = .year
        } else {
            timeType = .month
        }
    }
    
    
    @IBAction func completeAction(_ sender: Any) {
        
        if #available(iOS 10.0, *) {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(UINotificationFeedbackType.success)
        } else {
            // Fallback on earlier versions
        }
        
        if checkFields() {
            if paymentType.selectedSegmentIndex == 0 {
                showAnnuitPopup()
            } else {
                showDifferPopup()
            }
            
        }
        
    }

    
    @IBAction func closeInfoPopupAction(_ sender: Any) {
        closeShadow()
        UIView.animate(withDuration: 0.2, animations: {
            self.infoPopupView.alpha = 0
        }, completion: { _ in
            self.infoPopupView.removeFromSuperview()
        })
    }
    
    
    @IBAction func infoAction(_ sender: Any) {
        infoPopupView.frame.size = self.view.frame.size
        infoPopupView.center = self.view.center
        infoPopupView.alpha = 0
        openShadow()
        self.view.addSubview(infoPopupView)
        UIView.animate(withDuration: 0.2, animations: {
            self.infoPopupView.alpha = 0.9
        })
    }
    
    
    @IBAction func cleanAllAction(_ sender: Any) {
        
        if #available(iOS 10.0, *) {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(UINotificationFeedbackType.success)
        } else {
            // Fallback on earlier versions
        }
        
        print("clean")
        if sumField.text != "" {
            UIView.transition(with: sumField, duration: 0.4, options: .transitionFlipFromLeft, animations: {
                self.sumField.text = ""
            }, completion: nil)
        }
        if percentField.text != "" {
            UIView.transition(with: percentField, duration: 0.4, options: .transitionFlipFromLeft, animations: {
                self.percentField.text = ""
            }, completion: nil)
        }
        if monthsField.text != "" {
            UIView.transition(with: monthsField, duration: 0.4, options: .transitionFlipFromLeft, animations: {
                self.monthsField.text = ""
            }, completion: nil)
        }
        
    }
    
    func setForCurrentDevice() {
        device = DeviceChecker.checkDevice()
        switch device {
        case .se?:
            leftSpace.constant = 18
            rightSpace.constant = 18
            buttonsHeight.constant = 48
            mainTitleBottom.constant = 12
            mainTitleHeight.constant = 63
            mainTitle.font = UIFont.systemFont(ofSize: 26, weight: .heavy)
            paymentType.setTitle("Дифференцир...", forSegmentAt: 1)
        case .plus?:
            mainTitle.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
            mainTitleHeight.constant = 72
        default:
            print("error")
        }
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if device == .se {
            
            if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                mainTitleHeight.constant = 4
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                    let oldFrame = self.mainTitle.frame
                    self.mainTitle.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                    self.mainTitle.frame.origin = oldFrame.origin
                    self.mainTitle.alpha = 0
                    self.mainLine.alpha = 0
                })
            }
            
        } else if device == .six {
            UIView.animate(withDuration: 0.2, animations: {
                self.paymentTypeTitle.alpha = 0
                self.paymentType.alpha = 0
                self.paymentTypeInfoButton.alpha = 0
            })
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        if device == .se {
            mainTitleHeight.constant = 63
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
                self.mainTitle.transform = CGAffineTransform.identity
                self.mainTitle.alpha = 1
                self.mainLine.alpha = 0.5
                
            })
        } else if device == .six {
            UIView.animate(withDuration: 0.2, animations: {
                self.paymentTypeTitle.alpha = 1
                self.paymentType.alpha = 1
                self.paymentTypeInfoButton.alpha = 1
            })
        }
    }
    
    @IBAction func endTyping(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @objc func formatNumber() {
        print("change")
        if sumField.text?.count ?? 0 < 3 {
            return
        }
        let number = NSNumber(value: Int(sumField.text?.stringByRemovingWhitespaces ?? "") ?? 0)
        print(number)
        let formater = NumberFormatter()
        formater.groupingSeparator = " "
        formater.numberStyle = .decimal
        let formattedNumber = formater.string(from: number)
        sumField.text = formattedNumber
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setForCurrentDevice()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(openShadow), name: NSNotification.Name("OpenShadow"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closeShadow), name: NSNotification.Name("CloseShadow"), object: nil)
        
        sumField.delegate = self
        monthsField.delegate = self
        percentField.delegate = self
        
        sumField.addTarget(self, action: #selector(formatNumber), for: .editingChanged)
    }



}


extension String {
    var stringByRemovingWhitespaces: String {
        let componentss = components(separatedBy: .whitespaces)
        return componentss.joined(separator: "")
    }
    
    var stringByNumberWithSeparators: String {
            print("change")
            if self.count < 3 {
                return self
            }
            let number = NSNumber(value: Int(self.stringByRemovingWhitespaces) ?? 0)
            print(number)
            let formater = NumberFormatter()
            formater.groupingSeparator = " "
            formater.numberStyle = .decimal
            let formattedNumber = formater.string(from: number)
            return formattedNumber ?? self
    }
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text == "0" && string != "" || textField.text?.count ?? 0 > 18 && string != "" {
            return false
        }
        return true
    }
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.4
        animation.values = [-10.0, 10.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}

