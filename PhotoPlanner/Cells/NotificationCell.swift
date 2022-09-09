
import UIKit

class NotificationCell: UITableViewCell  {
    
    var notTime: String? {
        didSet {
            label.text = notTime
        }
    }
    
    var value: Bool?  {
        didSet {
            notificationSwitch.isOn = value!
        }
    }
    var cellProtocol: cellSwitchDelegate?
    var index: Int = 0
    var label = UILabel()
    var notificationSwitch = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(label)
        contentView.addSubview(notificationSwitch)
        
        label.pinLeft(to: contentView.safeAreaLayoutGuide.leadingAnchor, const: 15)
        label.pinTop(to: contentView.safeAreaLayoutGuide.topAnchor, const: 5)
        label.pinWidth(to: contentView.widthAnchor, mult: 0.7)
        label.setHeight(to: 30)
        
        notificationSwitch.pinRight(to: contentView.safeAreaLayoutGuide.trailingAnchor, const: 15)
        notificationSwitch.pinTop(to: contentView.safeAreaLayoutGuide.topAnchor, const: 5)
        notificationSwitch.pinLeft(to: label.trailingAnchor, const: 10)
        notificationSwitch.pinBottom(to: contentView.bottomAnchor, const: 10)
        notificationSwitch.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }
    
    @objc func valueChanged(){
        cellProtocol?.toggleCell(index: index, value: notificationSwitch.isOn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("error")
    }

}
