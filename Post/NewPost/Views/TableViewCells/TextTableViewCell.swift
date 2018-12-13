import UIKit
class TextTableViewCell: UITableViewCell {
    
    let textField = LabeledTextField()
    
    // MARK: - View Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layoutAllViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func layoutAllViews() {
        layoutViewHierarchy()
        layoutTextField()
    }
    
    private func layoutViewHierarchy() {
        addSubviewForConstraints(textField)
    }
    
    private func layoutTextField() {
        textField.addConstraintsPinningAllSidesToSuperview()
    }
    
    // MARK: - Configure
    
    private func configureView() {
        backgroundColor = UIColor.clear
    }
}
