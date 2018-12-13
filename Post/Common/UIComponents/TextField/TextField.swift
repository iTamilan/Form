import UIKit

enum ResponderStandardEditActions {
    case copy
    case cut
    case select
    case selectAll
    case paste
    
    var action: Selector {
        switch self {
        case .copy:
            return #selector(UIResponderStandardEditActions.copy)
        case .cut:
            return #selector(UIResponderStandardEditActions.cut)
        case .select:
            return #selector(UIResponderStandardEditActions.select)
        case .selectAll:
            return #selector(UIResponderStandardEditActions.selectAll)
        case .paste:
            return #selector(UIResponderStandardEditActions.paste)
        }
    }
}

class TextField: UITextField {
    
    var restrictEditActions = [ResponderStandardEditActions]()
    var restrictAllEditActions = false
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        guard restrictAllEditActions == false else {
            return false
        }
        
        for editActions in restrictEditActions where editActions.action == action {
            return false
        }
        return true
    }
}
