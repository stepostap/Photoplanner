import UIKit

class CalendarVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource
{
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarView: UICollectionView!
    
    var selectedDate: Date = Date()
    var totalSquares = [String]()
    var startingSpaces: Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "mainBackground")
        navigationController?.navigationBar.barTintColor = UIColor(named: "header")
        self.tabBarController?.tabBar.barTintColor = UIColor(named: "mainBackground")
        calendarView.backgroundColor = UIColor(named: "mainBackground")
        title = "Календарь съемок"
        //calendarView.backgroundColor = .white
        monthLabel.textColor = .black
        Photoshoots.sharedInstance.getAllItems()
        calendarView.isScrollEnabled = false
        setCellsView()
        setMonthView()
    }
    
    func setCellsView()
    {
        let width = UIScreen.main.bounds.width / 8
        let height = (UIScreen.main.bounds.height -
                        (self.navigationController?.navigationBar.bounds.height)! - 120) / 7
        
        let flowLayout = calendarView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    func setMonthView()
    {
        totalSquares.removeAll()
        
        let daysInMonth = CalendarHelper().daysInMonth(date: selectedDate)
        let firstDayOfMonth = CalendarHelper().firstOfMonth(date: selectedDate)
        startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth) - 1
        
        var count: Int = 1
        
        while(count <= 42)
        {
            if(count <= startingSpaces || count - startingSpaces > daysInMonth)
            {
                totalSquares.append("")
            }
            else
            {
                totalSquares.append(String(count - startingSpaces))
            }
            count += 1
        }
        
        monthLabel.text = CalendarHelper().monthString(date: selectedDate)
            + " " + CalendarHelper().yearString(date: selectedDate)
        calendarView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell
        cell.dayOfMonth.text = totalSquares[indexPath.row]
        
        var dateComponents = DateComponents()
        dateComponents.year = CalendarHelper().getYear(date: self.selectedDate)
        dateComponents.month = CalendarHelper().getMonth(date: self.selectedDate)
        dateComponents.day = indexPath.item - self.startingSpaces + 1
        let date = CalendarHelper().getDate(components: dateComponents)
        
        print(CalendarHelper().weekDay(date: date))
        if CalendarHelper().weekDay(date: date) == 6 || CalendarHelper().weekDay(date: date) == 0 {
            cell.dayOfMonth.textColor = .systemGray
        }
        
        for photoshoot in Photoshoots.sharedInstance.plannedPhotoshoots {
            if photoshoot.date != nil && CalendarHelper().isEqual(date1: date, date2: photoshoot.date!, toGranularity: .day) {
                cell.dayOfMonth.textColor = .systemBlue
            }
        }
        
        if CalendarHelper().isEqual(date1: date, date2: Date(), toGranularity: .day) {
            cell.dayOfMonth.textColor = .systemRed
            cell.dayOfMonth.layer.borderWidth = 2
            cell.dayOfMonth.layer.borderColor = UIColor.systemRed.cgColor
            cell.dayOfMonth.layer.cornerRadius = 2
        }
        
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let sheet = UIAlertController(title: "Съемки", message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        sheet.addAction(UIAlertAction(title: "Создать новую съемку", style: .default, handler: {_ in
            let vc = self.storyboard?.instantiateViewController(identifier: "addPhotoshoot") as! PhotoshootVC
            vc.title = "Новая съемка"
            
            vc.modelImage.image = UIImage(named: "unknown_user")
            var dateComponents = DateComponents()
            dateComponents.year = CalendarHelper().getYear(date: self.selectedDate)
            dateComponents.month = CalendarHelper().getMonth(date: self.selectedDate)
            dateComponents.day = indexPath.item - self.startingSpaces + 1
            vc.datePicker.setDate(CalendarHelper().getDate(components: dateComponents), animated: false)
            vc.date = CalendarHelper().getDate(components: dateComponents)
           
            self.navigationController?.pushViewController(vc, animated: true)
            
        }))
        
        for photoshoot in Photoshoots.sharedInstance.plannedPhotoshoots {
            
            if photoshoot.date != nil && CalendarHelper().getMonth(date: self.selectedDate) == CalendarHelper().getMonth(date: photoshoot.date!) &&
                (indexPath.row - startingSpaces + 1) == CalendarHelper().getDay(date: photoshoot.date!) {
                    
                    sheet.addAction(UIAlertAction(title: "Модель: \(photoshoot.modelName!), \(formatter.string(from: photoshoot.date!))", style: .default, handler: {_ in
                        let vc = self.storyboard?.instantiateViewController(identifier: "addPhotoshoot") as! PhotoshootVC
                        vc.photoShootData = photoshoot
                        vc.title = photoshoot.modelName
                        if photoshoot.date != nil {
                            vc.title! += " " + formatter.string(from: photoshoot.date!)
                        }
                        
                        vc.setInfoForUI()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }))
                
            }
        }
        
        present(sheet, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @IBAction func previousMonth(_ sender: Any)
    {
        selectedDate = CalendarHelper().minusMonth(date: selectedDate)
        setMonthView()
    }
    
    @IBAction func nextMonth(_ sender: Any)
    {
        selectedDate = CalendarHelper().plusMonth(date: selectedDate)
        setMonthView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setMonthView()
    }
    
    override open var shouldAutorotate: Bool
    {
        return false
    }
}

