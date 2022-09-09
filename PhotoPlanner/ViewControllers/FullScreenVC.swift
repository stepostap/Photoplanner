
import UIKit

class FullScreenVC: UIViewController {
    
    
    var images : [UIImage] = []
    var collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    var startIndex: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.backgroundColor = UIColor(named: "mainBackground")
        self.tabBarController?.tabBar.isHidden = true
    
        collection.delegate = self
        collection.dataSource = self
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        collection.setCollectionViewLayout(layout, animated: false)
        collection.showsHorizontalScrollIndicator = false
        
        collection.isPagingEnabled = true
        view.addSubview(collection)
        collection.pin(to: view)
        collection.register(MoodboardCell.self, forCellWithReuseIdentifier: "cell")
        
        DispatchQueue.main.async {
            self.collection.scrollToItem(at: self.startIndex, at: .centeredHorizontally, animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension FullScreenVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MoodboardCell
        cell.image.image = images[indexPath.row]
        cell.image.contentMode = .scaleAspectFit
        cell.backgroundColor = UIColor(named: "mainBackground")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 100)
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

