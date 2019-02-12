import UIKit

@IBDesignable
class RoundButton: UIButton {
    
    @IBInspectable var cornerRadious: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadious
        }
    }
    
    @IBInspectable var borderWith: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWith
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var background: UIColor = UIColor.clear {
        didSet {
            self.layer.backgroundColor = UIColor.init(hex: 0x8e5583).cgColor
        }
    }
    
}
