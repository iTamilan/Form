import UIKit
class DoubleTextTableViewCell: UITableViewCell {
    
    let leftTextField = LabeledTextField()
    let rightTextField = LabeledTextField()
    private let stackView = UIStackView()
    
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
        layoutStackView()
    }
    
    private func layoutViewHierarchy() {
        addSubviewForConstraints(stackView)
        stackView.addArrangedSubview(leftTextField)
        stackView.addArrangedSubview(rightTextField)
    }
    
    private func layoutStackView() {
        stackView.addConstraintsPinningAllSidesToSuperview()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 0
    }
    
    // MARK: - Configure
    
    private func configureView() {
        backgroundColor = UIColor.clear
    }
}
