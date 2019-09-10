

import UIKit


class AnnuitPopupView: UIView {

    var rootVC: UIViewController!
    
    static func createPopup(months: Int, percent: CGFloat, sum: Int, rootVC: UIViewController) -> AnnuitPopupView {
        print("months: \(months)\npersent: \(percent)\nsum: \(sum)")
        let popup = Bundle.main.loadNibNamed("AnnuitPopupView", owner: self, options: nil)![0] as! AnnuitPopupView
        NotificationCenter.default.post(name: NSNotification.Name("OpenShadow"), object: nil)
        popup.months = months
        popup.percent = percent
        popup.sum = sum
        popup.rootVC = rootVC
        popup.fillPopupData()
        return popup
    }
    
    let screen = UIScreen.main.bounds
    
    var months: Int!
    var percent: CGFloat!
    var sum: Int!
    var device = DeviceChecker.checkDevice()
    
    var selectedMonth = Int()
    var lastValue = CGFloat()
    
    var isSliderOpened = false
    
    @IBOutlet weak var hosterView: UIView!
    
    
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var paymentsSumLabel: UILabel!
    @IBOutlet weak var overpaymentLabel: UILabel!
    
    @IBOutlet weak var panGesture: UIPanGestureRecognizer!
    
    
    @IBAction func panGestureAction(_ sender: UIPanGestureRecognizer) {
        
        
        var startPoint = CGFloat()
        let normalYForPopup = screen.height/2-((screen.height-self.frame.height)/2)+6+UIApplication.shared.statusBarFrame.height
        
        if sender.state == .began {
            startPoint = sender.translation(in: self).y
        }
        UIView.animate(withDuration: 0.1, animations: {
            if normalYForPopup-(startPoint-sender.translation(in: self).y)>normalYForPopup {
                self.center.y = normalYForPopup-((startPoint-sender.translation(in: self).y)/5)
            } else {
                self.center.y = normalYForPopup-(startPoint-sender.translation(in: self).y)
            }
            
        })
        
        if sender.state == .ended {
            if startPoint - sender.translation(in: self).y > 40 {
                NotificationCenter.default.post(name: NSNotification.Name("CloseShadow"), object: nil)
                UIView.animate(withDuration: 0.25, animations: {
                    self.center.y = self.screen.height/2 - self.screen.height
                }, completion: { _ in
                    self.removeFromSuperview()
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.center.y = normalYForPopup
                })
            }
            
        }
        
    }
    
    
    func closePopup() {
        let normalYForPopup = screen.height/2-((screen.height-self.frame.height)/2)+6+UIApplication.shared.statusBarFrame.height
        NotificationCenter.default.post(name: NSNotification.Name("CloseShadow"), object: nil)
        UIView.animate(withDuration: 0.1, animations: {
            self.center.y = normalYForPopup+12
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.center.y = self.screen.height/2 - self.screen.height
            }, completion: { _ in
                self.removeFromSuperview()
            })
        })
    }


    func fillPopupData() {
        let payment = CalculationHandler.shared.countAnnuitet(sum: sum, percent: percent, months: months)
        paymentLabel.text = "\(Int(payment))".stringByNumberWithSeparators
        
        let allPayments = CalculationHandler.shared.countGeneralSumByMonths(sum: sum, percent: percent, months: months)
        overpaymentLabel.text = "\(Int(allPayments-CGFloat(sum)))".stringByNumberWithSeparators
        paymentsSumLabel.text = "\(Int(allPayments))".stringByNumberWithSeparators
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        copiedLabel.alpha = 0
        let width = UIScreen.main.bounds.width
        
        frame.size.width = width - 12
        self.center.x = screen.width/2
        self.center.y = screen.height/2 - screen.height
        
        let normalY = screen.height/2 - ((
            screen.height - frame.height)/2) + 6 + UIApplication.shared.statusBarFrame.height
        
        UIView.animate(withDuration: 0.25, animations: {
            self.center.y = normalY+12
        }, completion: { _ in
            UIView.animate(withDuration: 0.25, animations: {
                self.center.y = self.center.y-12
            })
        })

        
        hosterView.layer.cornerRadius = 12
        clipsToBounds = true
        
        
        if device == .six || device == .ten {
            frame.size.height = width+70
        } else if device == .plus {
            frame.size.height = width*0.9+70
        } else {
            frame.size.height = width*1.2+70
        }
        
    }
    
    @IBOutlet weak var copiedLabel: UILabel!
    
    func showCopiedLabel() {
        UIView.animate(withDuration: 0.2, animations: {
            self.copiedLabel.alpha = 0.9
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                UIView.animate(withDuration: 0.2, animations: {
                    self.copiedLabel.alpha = 0
                })
            })
        })
    }
    
    @IBAction func copyPayment(_ sender: Any) {
        UIPasteboard.general.string = paymentLabel.text
        showCopiedLabel()
    }
    
    @IBAction func copySum(_ sender: Any) {
        UIPasteboard.general.string = paymentsSumLabel.text
        showCopiedLabel()
    }
    
    @IBAction func copyOverpayment(_ sender: Any) {
        UIPasteboard.general.string = overpaymentLabel.text
        showCopiedLabel()
    }
    
    

  
}
