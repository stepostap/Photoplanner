
import UIKit

class PhotoshootCell: UITableViewCell {

    var modelName : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    var modelImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.contentMode = .scaleAspectFit
        image.layer.borderWidth = 0
        return image
    }()
    
    var dateLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.text = "Дата: "
        label.textColor = .black
        return label
    }()
    
    var studioLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    var rentDurationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.text = "Длительность: "
        label.textColor = .black
        return label
    }()
    
    var circle = UIView()
    
    var photoShootData: PhotoshootInfo? {
        didSet {
            modelImage.image = UIImage(data: (photoShootData?.modelImage)!)
            modelName.text = "Модель: " + (photoShootData?.modelName)!
            
            if photoShootData?.status != PhotoshootInfo.St.idea && photoShootData?.date != nil {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM HH:mm"
                dateLabel.text = "Дата: " + formatter.string(from: (photoShootData?.date)!)
            } else {
                dateLabel.text = "Дата: "
            }
            
            if photoShootData?.studioName != nil {
                
                studioLabel.text =  "Студия: " + (photoShootData?.studioName)!
            }
            
            if photoShootData?.rentDuration != nil {
                
                rentDurationLabel.text =  "Длительность: " + (photoShootData?.rentDuration)!
            }
            
            circle.setWidth(to: 14)
            circle.setHeight(to: 14)
            circle.layer.borderWidth = 0.2
            circle.layer.cornerRadius = 7
            
            switch photoShootData?.status {
            case .done:
                circle.backgroundColor = .systemRed
            case .idea:
                circle.backgroundColor = .systemTeal
            default:
                circle.backgroundColor = .systemGreen
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let cellView = UIView()
        
        contentView.addSubview(cellView)
        cellView.pinTop(to: contentView.safeAreaLayoutGuide.topAnchor, const: 3)
        cellView.pinBottom(to: contentView.safeAreaLayoutGuide.bottomAnchor, const: 13)
        cellView.pinLeft(to: contentView, const: 5)
        cellView.pinRight(to: contentView, const: 5)
        cellView.backgroundColor = UIColor(named: "viewBackground")
        cellView.layer.cornerRadius = 7
        cellView.layer.shadowRadius = 5
        cellView.layer.shadowOpacity = 0.8
        cellView.layer.shadowOffset = CGSize(width: 0, height: 10)
        cellView.layer.shadowColor = UIColor.systemGray.cgColor
        
        cellView.addSubview(modelName)
        cellView.addSubview(modelImage)
        cellView.addSubview(dateLabel)
        cellView.addSubview(studioLabel)
        cellView.addSubview(rentDurationLabel)
        cellView.addSubview(circle)
        
        modelName.translatesAutoresizingMaskIntoConstraints = false
        modelImage.translatesAutoresizingMaskIntoConstraints = false
        
        modelName.pinTop(to: cellView.safeAreaLayoutGuide.topAnchor, const: 5)
        modelName.pinLeft(to: cellView.safeAreaLayoutGuide.leadingAnchor, const: 10)
        modelName.pinWidth(to: cellView.widthAnchor, mult: 0.5)
        modelName.setHeight(to: 30)
        
        modelImage.pinRight(to: cellView.safeAreaLayoutGuide.trailingAnchor, const: 5)
        modelImage.pinTop(to: cellView, const: 15)
        modelImage.pinBottom(to: cellView, const: 15)
        modelImage.pinWidth(to: cellView.heightAnchor, mult: 1)
        
        studioLabel.pinTop(to: modelName.bottomAnchor, const: 5)
        studioLabel.pinLeft(to: cellView.safeAreaLayoutGuide.leadingAnchor, const: 10)
        studioLabel.pinWidth(to: cellView.widthAnchor, mult: 0.5)
        studioLabel.setHeight(to: 30)
        
        rentDurationLabel.pinTop(to: studioLabel.bottomAnchor, const: 5)
        rentDurationLabel.pinLeft(to: cellView.safeAreaLayoutGuide.leadingAnchor, const: 10)
        rentDurationLabel.pinWidth(to: cellView.widthAnchor, mult: 0.5)
        rentDurationLabel.setHeight(to: 30)
        
        dateLabel.pinTop(to: rentDurationLabel.bottomAnchor, const: 5)
        dateLabel.pinLeft(to: circle.trailingAnchor, const: 6)
        dateLabel.pinWidth(to: cellView.widthAnchor, mult: 0.5)
        dateLabel.setHeight(to: 30)
        
        circle.pinLeft(to: cellView.safeAreaLayoutGuide.leadingAnchor, const: 4)
        circle.pinTop(to: rentDurationLabel.bottomAnchor, const: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("error")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
    }
}
