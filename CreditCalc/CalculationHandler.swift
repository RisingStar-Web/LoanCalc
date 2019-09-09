
import UIKit

class CalculationHandler {
    
    static let shared = CalculationHandler()
    
    func countDifferByMonth(sum: Int, percent: CGFloat, months: Int, currentMonth: Int) -> CGFloat {
        
        let generalPayment = sum/months
        let x = (sum - (generalPayment*currentMonth-1))
        let currentPayment = CGFloat(generalPayment) + CGFloat(x)*(percent/100)/12
        return currentPayment
        
    }
    
    func countAnnuitet(sum: Int, percent: CGFloat, months: Int) -> CGFloat {
        let i = CGFloat(sum)*(percent/100/12)
        let x = (1-1/pow((1+percent/100/12), CGFloat(months)))
        print("pow", pow(2, 3))
        return i/x
    }
    
    func countGeneralSumByMonths(sum: Int, percent: CGFloat, months: Int) -> CGFloat {
        
        var allPayments: CGFloat = 0
        for i in 1...months {
            allPayments += countDifferByMonth(sum: sum, percent: percent, months: months, currentMonth: i)
        }
        return allPayments
        
    }
    
}
