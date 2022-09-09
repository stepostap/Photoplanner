
import UIKit

class MoodboardCell: UICollectionViewCell {
    
    var image = UIImageView()
    
    override init(frame: CGRect) {
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        super.init(frame:frame)
        contentView.addSubview(image)
        image.pin(to: self.contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("error")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
