import UIKit

struct ViewSides: OptionSet {
    let rawValue: Int
    static let top = ViewSides(rawValue: 1 << 0)
    static let right = ViewSides(rawValue: 1 << 1)
    static let bottom = ViewSides(rawValue: 1 << 2)
    static let left = ViewSides(rawValue: 1 << 3)
    static let leading = ViewSides(rawValue: 1 << 4)
    static let trailing = ViewSides(rawValue: 1 << 5)
    static let width = ViewSides(rawValue: 1 << 6)
    static let height = ViewSides(rawValue: 1 << 7)
    static let centerX = ViewSides(rawValue: 1 << 8)
    static let centerY = ViewSides(rawValue: 1 << 9)
}

extension UIView {
    func addSubviewForConstraints(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
    }
    
    func addSubviewsForConstraints(_ subviews: [UIView]) {
        subviews.forEach(addSubviewForConstraints(_:))
    }
    
    func addConstraintsPinningAllSidesToSuperview(constant: CGFloat = 0,
                                                  useSafeArea: Bool = false) {
        addConstraintsPinningSidesToSuperview([.top, .trailing, .bottom, .leading],
                                              constant: constant,
                                              useSafeArea: useSafeArea)
    }
    
    func addConstraintsPinningSidesToSuperview(_ sides: ViewSides,
                                               constant: CGFloat = 0,
                                               useSafeArea: Bool = false) {
        guard let superview = self.superview else {
            print("No superview to constrain to")
            return
        }
        
        var constraints = [NSLayoutConstraint]()
        
        if sides.contains(.top) {
            let superViewAnchor = useSafeArea ? superview.safeAreaLayoutGuide.topAnchor : superview.topAnchor
            let constraint = topAnchor.constraint(equalTo: superViewAnchor, constant: constant)
            constraints.append(constraint)
        }
        
        if sides.contains(.right) {
            let superViewAnchor = useSafeArea ? superview.safeAreaLayoutGuide.rightAnchor : superview.rightAnchor
            let constraint = rightAnchor.constraint(equalTo: superViewAnchor, constant: -constant)
            constraints.append(constraint)
        }
        
        if sides.contains(.bottom) {
            let superViewAnchor = useSafeArea ? superview.safeAreaLayoutGuide.bottomAnchor : superview.bottomAnchor
            let constraint = bottomAnchor.constraint(equalTo: superViewAnchor, constant: -constant)
            constraints.append(constraint)
        }
        
        if sides.contains(.left) {
            let superViewAnchor = useSafeArea ? superview.safeAreaLayoutGuide.leftAnchor : superview.leftAnchor
            let constraint = leftAnchor.constraint(equalTo: superViewAnchor, constant: constant)
            constraints.append(constraint)
        }
        
        if sides.contains(.leading) {
            let superViewAnchor = useSafeArea ? superview.safeAreaLayoutGuide.leadingAnchor : superview.leadingAnchor
            let constraint = leadingAnchor.constraint(equalTo: superViewAnchor, constant: constant)
            constraints.append(constraint)
        }
        
        if sides.contains(.trailing) {
            let superViewAnchor = useSafeArea ? superview.safeAreaLayoutGuide.trailingAnchor : superview.trailingAnchor
            let constraint = trailingAnchor.constraint(equalTo: superViewAnchor, constant: -constant)
            constraints.append(constraint)
        }
        
        if sides.contains(.width) {
            let superViewAnchor = useSafeArea ? superview.safeAreaLayoutGuide.widthAnchor : superview.widthAnchor
            let constraint = widthAnchor.constraint(equalTo: superViewAnchor, constant: constant)
            constraints.append(constraint)
        }
        
        if sides.contains(.height) {
            let superViewAnchor = useSafeArea ? superview.safeAreaLayoutGuide.heightAnchor : superview.heightAnchor
            let constraint = heightAnchor.constraint(equalTo: superViewAnchor, constant: constant)
            constraints.append(constraint)
        }
        
        if sides.contains(.centerX) {
            let superViewAnchor = useSafeArea ? superview.safeAreaLayoutGuide.centerXAnchor : superview.centerXAnchor
            let constraint = centerXAnchor.constraint(equalTo: superViewAnchor, constant: constant)
            constraints.append(constraint)
        }
        
        if sides.contains(.centerY) {
            let superViewAnchor = useSafeArea ? superview.safeAreaLayoutGuide.centerYAnchor : superview.centerYAnchor
            let constraint = centerYAnchor.constraint(equalTo: superViewAnchor, constant: constant)
            constraints.append(constraint)
        }
        NSLayoutConstraint.activate(constraints)
    }
}
