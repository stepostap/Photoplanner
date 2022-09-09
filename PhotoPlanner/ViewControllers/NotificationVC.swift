
import UIKit

extension UITextField {
    func addBottomBorder(){
        let bottomLine = UIView()
        self.addSubview(bottomLine)
        bottomLine.backgroundColor = .systemGray
        bottomLine.pinBottom(to: self.bottomAnchor)
        bottomLine.pinWidth(to: self.widthAnchor, mult: 1)
        bottomLine.setHeight(to: 1)
        
    }
}

protocol cellSwitchDelegate {
    func toggleCell(index: Int, value: Bool)
}

class NotificationVC: UIViewController, UITextFieldDelegate, cellSwitchDelegate {
    
    func toggleCell(index: Int, value: Bool) {
        notifications[index] = value
    }
    
    var notificationTableview = UITableView()
    
    var notifications = Array(repeating: false, count: 8)
    var delegate: notificationDelegate?
    let notifDates = ["Один час", "Два часа", "Три часа", "Пять часов", "Один день", "Два дня", "Три дня",  "Одну неделю"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor(named: "mainBackground")
        let label = UILabel()
        label.text = "Получить уведомления за..."
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        view.addSubview(label)
        label.pinTop(to: view.safeAreaLayoutGuide.topAnchor, const: 15)
        label.pinLeft(to: view, const: 15)
        label.pinWidth(to: view.widthAnchor, mult: 0.7)
        label.setHeight(to: 30)
        
        notificationTableview.delegate = self
        notificationTableview.dataSource = self
        notificationTableview.register(NotificationCell.self, forCellReuseIdentifier: "NotifCell")
        notificationTableview.allowsSelection = false
        view.backgroundColor = .white
        
        view.addSubview(notificationTableview)
        notificationTableview.pinTop(to: label.bottomAnchor, const: 15)
        notificationTableview.pinLeft(to: view, const: 7)
        notificationTableview.pinRight(to: view, const: 7)
        notificationTableview.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, const: 15)
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.setNotificationDates(dates: notifications)
        self.dismiss(animated: true, completion: nil)
    }
}

extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotifCell", for: indexPath) as! NotificationCell
        
        cell.cellProtocol = self
        cell.index = indexPath.item
        cell.notTime = notifDates[indexPath.item]
        cell.value = notifications[indexPath.item]
        
        return cell
    }
}

