
import UIKit

enum IPhones {
    case se, six, plus, ten
}

class DeviceChecker {
    
    static func checkDevice() -> IPhones {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                return .se
            case 1334:
                print("iPhone 6/6S/7/8")
                return .six
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                return .plus
            case 2436:
                print("iPhone X")
                return .ten
            default:
                print("unknown")
                return .ten
            }
        }
        return .ten
    }
}
