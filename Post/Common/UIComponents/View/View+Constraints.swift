import UIKit

extension UIView {
    func addSubviewForConstraints(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
    }
    
    func addSubviewsForConstraints(_ subviews: [UIView]) {
        subviews.forEach(addSubviewForConstraints(_:))
    }
}
