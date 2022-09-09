
import CoreData
import UIKit

class TableVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate {
    
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredPhotoshoots = [PhotoshootInfo]()

    let photoshootsTableView = UITableView()
    var segmentedController = UISegmentedControl()
    
    var isFiltering: Bool {
        return searchController.isActive
    }
    
    func photoshoot() -> [PhotoshootInfo]   {
        if segmentedController.selectedSegmentIndex == 0 {
            return Photoshoots.sharedInstance.plannedPhotoshoots
        } else if segmentedController.selectedSegmentIndex == 1 {
            return Photoshoots.sharedInstance.ideaPhotoshoots
        } else {
            return Photoshoots.sharedInstance.archivePhotoshoots
        }
    }
    
    override func viewDidLoad() {
        
        UNUserNotificationCenter.current().delegate = self
        
        super.viewDidLoad()
        Photoshoots.sharedInstance.getAllItems()
        photoshootsTableView.reloadData()
        
        view.addSubview(photoshootsTableView)
        photoshootsTableView.backgroundColor = UIColor(named: "mainBackground")
        navigationController?.navigationBar.barTintColor = UIColor(named: "header")
        searchController.searchBar.barTintColor = UIColor(named: "mainBackground")
        searchController.searchBar.searchTextField.backgroundColor = UIColor(named: "header")
        
        self.tabBarController?.tabBar.barTintColor = UIColor(named: "mainBackground")
        
        title = "Фотосъемки"
        
        searchController.searchBar.sizeToFit()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Искать фотосъемки..."
        searchController.delegate = self
        //photoshootsTableView.tableHeaderView = searchController.searchBar
        navigationItem.searchController = searchController
        
        photoshootsTableView.delegate = self
        photoshootsTableView.dataSource = self
        photoshootsTableView.frame = view.bounds
        photoshootsTableView.register(PhotoshootCell.self, forCellReuseIdentifier: "cell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToPhotoshootVC))
        
        let items = ["Планы", "Идеи", "Архив"]
        segmentedController = UISegmentedControl(items: items)
        segmentedController.selectedSegmentIndex = 0
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.black], for: .selected)
        navigationItem.titleView = segmentedController
        segmentedController.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    @objc func segmentChanged(){
        photoshootsTableView.reloadData()
    }
    
    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        
        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = longPressGestureRecognizer.location(in: self.photoshootsTableView)
            if let indexPath = photoshootsTableView.indexPathForRow(at: touchPoint) {
                let item = photoshoot()[indexPath.item]
                shareAlert(item: item)
            }
        }
    }
    
    func shareAlert(item: PhotoshootInfo) {
        let sheet = UIAlertController(title: "Опции", message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        sheet.addAction(UIAlertAction(title: "Поделиться", style: .default, handler:{ [weak self] _ in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM HH:mm"
            var sharedInfo = "Фотоотосъемка с \(item.modelName!) \nФотостудия: \(item.studioName!)" +
                " \nСсылка на студию: \(item.link ?? "") \n"
            if item.date != nil {
                sharedInfo += "Время: \(formatter.string(from: item.date!))\n"
            }
            if item.comment != nil {
                sharedInfo += item.comment!
            }
            var shareObjects = [sharedInfo] as [Any]
            let imagesURL = item.imageKeys?.split{$0 == "*"}.map(String.init)
            
            if (imagesURL?.count != 0) {
                
                let shareImagesAlert = UIAlertController(title: "Мудборд", message: "Прикрепить первый три фотографии мудборда?", preferredStyle: .alert)
                
                shareImagesAlert.addAction(UIAlertAction(title: "Нет", style: .default, handler:{  _ in
                    let activityVC = UIActivityViewController(activityItems: shareObjects, applicationActivities: nil)
                    activityVC.popoverPresentationController?.sourceView = self!.view
                    self!.present(activityVC, animated: true, completion: nil)
                }))
                
                shareImagesAlert.addAction(UIAlertAction(title: "Да", style: .default, handler:{  _ in
                    var imagesCount = 0
                    while imagesCount < 3 && imagesCount < imagesURL!.count {
                        let image = ImageSaver().getImage(Key: imagesURL![imagesCount])
                        shareObjects.append(image as Any)
                        imagesCount += 1
                    }
                    let activityVC = UIActivityViewController(activityItems: shareObjects, applicationActivities: nil)
                    activityVC.popoverPresentationController?.sourceView = self!.view
                    self!.present(activityVC, animated: true, completion: nil)
                }))
                
                self!.present(shareImagesAlert, animated: true)
            }
            
            let activityVC = UIActivityViewController(activityItems: shareObjects, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self?.view
            self?.present(activityVC, animated: true, completion: nil)
        }))
        
        if item.status != PhotoshootInfo.St.idea {
            sheet.addAction(UIAlertAction(title: "Переместить в Идеи", style: .default, handler:{ [weak self] _ in
                item.date = nil
                item.status = PhotoshootInfo.St.idea
                Photoshoots.sharedInstance.getAllItems()
                do{
                    try Photoshoots.sharedInstance.context.save()
                }
                catch{
                    
                }
                self?.photoshootsTableView.reloadData()
            }))
        }
        
        present(sheet, animated: true)
        
    }
    
    @objc func goToPhotoshootVC(){
        
        let vc = storyboard?.instantiateViewController(identifier: "addPhotoshoot") as! PhotoshootVC
        vc.modelImage.image = UIImage(named: "unknown_user")
        vc.title = "Новая съемка"
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering{
            return filteredPhotoshoots.count
        } else {
            return photoshoot().count
            
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model: PhotoshootInfo
        if isFiltering {
            model = filteredPhotoshoots[indexPath.row]
        }
        else {
            model = photoshoot()[indexPath.row]
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PhotoshootCell
        cell.photoShootData = model
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        cell.addGestureRecognizer(longPressRecognizer)
        cell.backgroundColor = UIColor(named: "mainBackground")
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM"
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = self.storyboard?.instantiateViewController(identifier: "addPhotoshoot") as! PhotoshootVC
        var item: PhotoshootInfo
        
        if isFiltering {
            item = filteredPhotoshoots[indexPath.row]
        }
        else {
            item = photoshoot()[indexPath.row]
        }
        
        vc.title = item.modelName
        if item.date != nil {
            vc.title! += " " + formatter.string(from: item.date!)
        }
        vc.photoShootData = item
        vc.setInfoForUI()
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if isFiltering {
            return false
        }
        return true
    }
        
    override func viewWillAppear(_ animated: Bool) {
        searchController.dismiss(animated: false, completion: nil)
        searchController.searchBar.text = ""
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle:   UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if isFiltering {
                let item = filteredPhotoshoots[indexPath.row]
                Photoshoots.sharedInstance.deleteItem(photoshoot: item)
            } else {
                let item = photoshoot()[indexPath.row]
                Photoshoots.sharedInstance.deleteItem(photoshoot: item)
            }
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableView.endUpdates()
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        
        filteredPhotoshoots = photoshoot().filter { (photoshoot: PhotoshootInfo) -> Bool in
            return photoshoot.getFilterInfo().lowercased().contains(searchText.lowercased())
        }
        photoshootsTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Photoshoots.sharedInstance.getAllItems()
        photoshootsTableView.reloadData()
    }
}

extension TableVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}

extension TableVC: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }

}


