import UIKit

extension UIView{
    var globalPoint: CGPoint? {
        return self.superview?.convert(self.frame.origin, to: nil)
    }
    
    var globalFrame: CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
    
    func pointTo(view: UIView) -> CGPoint? {
        return self.superview?.convert(self.frame.origin, to: view)
    }
    
    func frameTo(view: UIView) -> CGRect? {
        return self.superview?.convert(self.frame, to: view)
    }
}
