
import UIKit

class CalendarCell: UICollectionViewCell {
    
    @IBOutlet weak var dayOfMonth: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dayOfMonth.layer.borderWidth = 0
        dayOfMonth.textColor = .black
    }
}
