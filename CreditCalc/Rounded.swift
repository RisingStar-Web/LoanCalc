import UIKit

@IBDesignable
class Rounded: UIButton {

    @IBInspectable var leftInset: CGFloat = 7.0{
        didSet{
            self.contentEdgeInsets = UIEdgeInsets(top: 5, left: leftInset, bottom: 5, right: leftInset)
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}

