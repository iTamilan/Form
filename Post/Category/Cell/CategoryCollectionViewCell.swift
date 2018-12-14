import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CategoryCollectionViewCell"
    
    // MARK: -
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    private func layoutAllViews() {
        
    }
}
