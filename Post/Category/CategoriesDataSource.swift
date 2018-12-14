import UIKit

protocol CategoriesDataSourceDelegate: class {
    
}

class CategoriesDataSource: NSObject {
    
    weak var delegate: CategoriesDataSourceDelegate?
    
    lazy var allCategories: [Category] = {
        var categories = [Category]()
        let images: [UIImage] = [#imageLiteral(resourceName: "image1.jpg"), #imageLiteral(resourceName: "image2.jpg"), #imageLiteral(resourceName: "image3.jpg"), #imageLiteral(resourceName: "image4.jpg"), #imageLiteral(resourceName: "image5.jpg"), #imageLiteral(resourceName: "image6.jpg")]
        for index in 0...35 {
            let image = images[index % images.count]
            let category = Category(name: "C \(index)", image:image)
        }
        return categories
    }()
        
    weak var collectionView: UICollectionView? {
        didSet {
            configureCollectionView()
        }
    }
    
    private func configureCollectionView() {
        
    }
}

extension CategoriesDataSource: UICollectionViewDelegate {
    
}

extension CategoriesDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    }
}
