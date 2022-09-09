
import UIKit
import SafariServices
import PhotosUI
import ContactsUI

protocol notificationDelegate {
    func setNotificationDates(dates: [Bool])
}

class PhotoshootVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SFSafariViewControllerDelegate, UITextViewDelegate, notificationDelegate {
    
    let photoshootDuruation = ["1 час", "2 часа", "3 часа", "4 часа", "5 часов"]
    var durationPicker = UIPickerView()
    
    var notificationManager = LocalNotificationManager()
    var notificationDates =  Array(repeating: false, count: 8)
    
    var photoShootData: PhotoshootInfo?
    var scrollView = UIScrollView()
    
    var modelView = UIView()
    var modelName = UITextField(frame: .zero)
    var modelPhone = UITextField()
    var modelEmail = UITextField()
    var modelImage = UIImageView()
    var imageBuutton = UIButton(type: .system)
    
    var studioView = UIView()
    var studioName = UITextField()
    var studioRoom = UITextField()
    var rentDuration = UITextField()
    var openLinkButton = UIButton(type: .system)
    var studioLink = UITextField()
    
    var dateView = UIView()
    var setNotificationsButton = UIButton(type: .system)
    var dateTextfield = UITextField()
    var date : Date? {
        didSet {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm dd.MM.yyyy"
            dateTextfield.text = formatter.string(from: date!)
        }
    }
    
    let datePicker = UIDatePicker()
    var id = Int.random(in: 0..<1000000)
    let ideaSwitch = UISwitch()
    var commentView = UITextView()
    
    let moodboard: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    var imagesURL : [String]?
    var resultImagesCount: Int = 0
    var images: [UIImage] = [] {
        didSet {
            if images.count == resultImagesCount {
                // Добавить на вью контроллерdc
                DispatchQueue.main.async {
                    self.moodboard.reloadData()
                }
            }
        }
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
       
    }

    func setNotificationDates(dates: [Bool]) {
        notificationDates = dates
    }
    
    func setInfoForUI(){
        if photoShootData?.modelImage != nil {
            modelImage.image = UIImage(data: (photoShootData?.modelImage!)!)
        } else {
            modelImage.image = UIImage(named: "unknown_user")
        }
        
        modelName.text = photoShootData?.modelName
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd.MM.yyyy"
        
        if photoShootData?.date != nil {
            dateTextfield.text = formatter.string(from: (photoShootData?.date)!)
        }
        
        studioLink.text = photoShootData?.link
        studioName.text = photoShootData?.studioName
        studioRoom.text = photoShootData?.studioRoom
        rentDuration.text = photoShootData?.rentDuration
        modelEmail.text = photoShootData?.modelMail
        modelPhone.text = photoShootData?.modelPhone
        if (photoShootData?.comment == nil) {
            commentView.text = "Заметки к фотосъемке..."
            commentView.textColor = UIColor.systemGray
        } else {
            commentView.text = photoShootData?.comment
        }
        if photoShootData?.status == PhotoshootInfo.St.idea {
            ideaSwitch.isOn = true
        }
        
        id = photoShootData?.id ?? 0
        imagesURL = photoShootData?.imageKeys?.split{$0 == "*"}.map(String.init)
       
        images = []
        for url in imagesURL! {
            DispatchQueue.main.async {
                if let image = ImageSaver().getImage(Key: url) {
                    self.images.append(image)
                }
                self.resultImagesCount += 1
            }
        }
        getNotfications()
        

    }
    
    func getNotfications() {
        let closure: (String) -> () = { (notificationID:String) -> () in
            switch notificationID {
            case "\(self.id)1hour":
                self.notificationDates[0] = true
            case "\(self.id)2hour":
                self.notificationDates[1] = true
            case "\(self.id)3hour":
                self.notificationDates[2] = true
            case "\(self.id)5hour":
                self.notificationDates[3] = true
            case "\(self.id)1day":
                self.notificationDates[4] = true
            case "\(self.id)2day":
                self.notificationDates[5] = true
            case "\(self.id)3day":
                self.notificationDates[6] = true
            case "\(self.id)week":
                self.notificationDates[7] = true
            default: break
            }
        }
        notificationManager.getCurrentNotificationsId(closure: closure)
    }
    
    func clearNotifications(){
        notificationManager.deleteNotification(id: ["\(id)1hour", "\(id)2hour", "\(id)3hour",
                                                    "\(id)5hour", "\(id)1day", "\(id)3day",
                                                    "\(id)2day", "\(id)week"])
    }
    
    func createNotifications(){
        clearNotifications()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd.MM.yyyy"
        let date = formatter.date(from: dateTextfield.text!)!
        if notificationDates[0] {
            let notificationDate = Calendar.current.date(byAdding: .hour, value: -1, to: date)!
            let n = localNotification(id: "\(id)1hour", title: "\(modelName.text!), \(formatter.string(from: date))",
                                      body: "Остался час до фотосъемки с \( modelName.text!)\nСтудия: \(studioName.text!)",
                                      datetime: Calendar.current.dateComponents([.month, .day, .hour, .minute], from: notificationDate))
            notificationManager.notifications.append(n)
        }
        if notificationDates[1] {
            let notificationDate = Calendar.current.date(byAdding: .hour, value: -2, to: date)!
            let n = localNotification(id: "\(id)2hour", title: "\(modelName.text!), \(formatter.string(from: date))",
                                      body: "Осталось два часа до фотосъемки с \( modelName.text!)\nСтудия: \(studioName.text!)",
                                      datetime: Calendar.current.dateComponents([.month, .day, .hour, .minute], from: notificationDate))
            notificationManager.notifications.append(n)
        }
        if notificationDates[2] {
            let notificationDate = Calendar.current.date(byAdding: .hour, value: -3, to: date)!
            let n = localNotification(id: "\(id)3hour", title: "\(modelName.text!), \(formatter.string(from: date))",
                                      body: "Осталось три часа до фотосъемки с \( modelName.text!)\nСтудия: \(studioName.text!)",
                                      datetime: Calendar.current.dateComponents([.month, .day, .hour, .minute], from: notificationDate))
            notificationManager.notifications.append(n)
        }
        if notificationDates[3] {
            let notificationDate = Calendar.current.date(byAdding: .hour, value: -5, to: date)!
            let n = localNotification(id: "\(id)5hour", title: "\(modelName.text!), \(formatter.string(from: date))",
                                      body: "Осталось пять часов до фотосъемки с \( modelName.text!)\nСтудия: \(studioName.text!)",
                                      datetime: Calendar.current.dateComponents([.month, .day, .hour, .minute], from: notificationDate))
            notificationManager.notifications.append(n)
        }
        if notificationDates[4] {
            let notificationDate = Calendar.current.date(byAdding: .day, value: -1, to: date)!
            let n = localNotification(id: "\(id)1day", title: "\(modelName.text!), \(formatter.string(from: date))",
                                      body: "Остался день до фотосъемки с \( modelName.text!)\nСтудия: \(studioName.text!)",
                                      datetime: Calendar.current.dateComponents([.month, .day, .hour, .minute], from: notificationDate))
            notificationManager.notifications.append(n)
        }
        if notificationDates[5] {
            let notificationDate = Calendar.current.date(byAdding: .day, value: -2, to: date)!
            let n = localNotification(id: "\(id)2day", title: "\(modelName.text!), \(formatter.string(from: date))",
                                      body: "Осталось два дня до фотосъемки с \( modelName.text!)\nСтудия: \(studioName.text!)",
                                      datetime: Calendar.current.dateComponents([.month, .day, .hour, .minute], from: notificationDate))
            notificationManager.notifications.append(n)
        }
        
        if notificationDates[6] {
            let notificationDate = Calendar.current.date(byAdding: .day, value: -3, to: date)!
            let n = localNotification(id: "\(id)3day", title: "\(modelName.text!), \(formatter.string(from: date))",
                                      body: "Осталось три дня до фотосъемки с \( modelName.text!)\nСтудия: \(studioName.text!)",
                                      datetime: Calendar.current.dateComponents([.month, .day, .hour, .minute], from: notificationDate))
            notificationManager.notifications.append(n)
        }
        if notificationDates[7] {
            let notificationDate = Calendar.current.date(byAdding: .day, value: -7, to: date)!
            let n = localNotification(id: "\(id)week", title: "\(modelName.text!), \(formatter.string(from: date))",
                                      body: "Осталась неделя до фотосъемки с \( modelName.text!)\nСтудия: \(studioName.text!)",
                                      datetime: Calendar.current.dateComponents([.month, .day, .hour, .minute], from: notificationDate))
            notificationManager.notifications.append(n)
        }
        
        notificationManager.schedule()
    }
    
    @objc func datepickerDone(){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd.MM.yyyy"
        dateTextfield.text = formatter.string(from: datePicker.date)
        ideaSwitch.isOn = false
    }
    
    @objc func presentNotificationController(){
        
        let vc = NotificationVC()
        vc.delegate = self
        vc.notifications = self.notificationDates
        present(vc, animated: true, completion: nil)
         
    }
    
    @objc func chooseImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let userPickedImage = info[.editedImage] as? UIImage else { return }
        modelImage.image = userPickedImage
        
        picker.dismiss(animated: true)
    }
    
    @objc func showSafariVC() {
        if (studioLink.text != " "){
            if !studioLink.text!.hasPrefix("https://") {
                let alert = UIAlertController(title: "Wgonr URL", message: "Enter new url", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {[weak self] _  in
                    self!.studioLink.text = ""
                }))
                present(alert, animated: true)
            } else {
                guard let url = URL(string: studioLink.text!) else {
                    return
                }
                print(url)
                let safariVC = SFSafariViewController(url: url)
                safariVC.delegate = self
                present(safariVC, animated: true)
            }
        }
        
        
    }
    
    override func viewDidLoad() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        view.backgroundColor = UIColor(named: "mainBackground")
        durationPicker.delegate = self
        durationPicker.dataSource = self
        moodboard.dataSource = self
        moodboard.delegate = self
        moodboard.register(MoodboardCell.self, forCellWithReuseIdentifier: "cell")
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = true
        
        configureModelInfoView()
        configureStudioView()
        configureDateView()
        configureCommentView()
        configureMoodboard()
        
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.systemGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        let scrollPoint : CGPoint = CGPoint.init(x:0, y:textView.frame.origin.y - 100)
        self.scrollView.setContentOffset(scrollPoint, animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Заметки к фотосъемке..."
            textView.textColor = UIColor.systemGray
        }
        let scrollPoint : CGPoint = CGPoint.init(x:0, y:textView.frame.origin.y - 100)
        self.scrollView.setContentOffset(scrollPoint, animated: true)
    }
    
    @objc func adjustForKeyboard() {

        commentView.scrollIndicatorInsets = commentView.contentInset

        let selectedRange = commentView.selectedRange
        commentView.scrollRangeToVisible(selectedRange)
    }
    
    
    @objc func showPHPController() {
        
        var configuration:PHPickerConfiguration = PHPickerConfiguration()
        configuration.filter = PHPickerFilter.images
        configuration.selectionLimit = 10
        
        let picker: PHPickerViewController = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func getContacts() {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys =
                [CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactEmailAddressesKey]
        present(contactPicker, animated: true, completion: nil)
    }
    
    @objc func save(){
        
        if modelName.text == "" {
            let alert = UIAlertController(title: "Не введено имя модели", message: "Пожалуйста, введите имя модели", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {[weak self] _  in
                self?.modelName.becomeFirstResponder()
            }))
            present(alert, animated: true)
        }
        
        else if dateTextfield.text == "" && !ideaSwitch.isOn {
            let alert = UIAlertController(title: "Не введена дата съемки", message: "Пожалуйста, введите дату съемки или отметьте фотосессию как идею", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {[weak self] _  in
                self?.dateTextfield.becomeFirstResponder()
            }))
            present(alert, animated: true)
        }
        
        else if studioName.text == "" {
            let alert = UIAlertController(title: "Не введено название фотостудии", message: "Пожалуйста, введите название фотостудии", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {[weak self] _  in
                self?.studioName.becomeFirstResponder()
                
            }))
            present(alert, animated: true)
        }
        
        else {
            if photoShootData == nil {
                photoShootData = PhotoshootInfo(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
            }
            
            saveMoodboord()
            refreshPhotoshootInfo()
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    func saveMoodboord() {
        var count = 0
        photoShootData?.imageKeys = ""
        for image in images {
            let key = "\(id)moodboard\(count)"
            DispatchQueue.global().async {
                ImageSaver().saveImage(image: image, Key: key)
            }
            photoShootData?.imageKeys! += "\(key)*"
            count += 1
        }
    }
    
    func refreshPhotoshootInfo() {
        
        photoShootData?.modelImage = modelImage.image?.pngData()
        if dateTextfield.text != "" {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm dd.MM.yyyy"
            photoShootData?.date = formatter.date(from: dateTextfield.text!)
        } else {
            photoShootData?.date = nil
        }
        photoShootData?.id = id
        photoShootData?.modelName = modelName.text
        photoShootData?.link = studioLink.text
        photoShootData?.studioName = studioName.text
        photoShootData?.studioRoom = studioRoom.text
        photoShootData?.rentDuration = rentDuration.text
        photoShootData?.modelMail = modelEmail.text
        photoShootData?.modelPhone = modelPhone.text
        if commentView.text != "Заметки к фотосъемке..." {
            photoShootData?.comment = commentView.text
        } else {
            photoShootData?.comment = nil
        }
        if ideaSwitch.isOn {
            photoShootData?.status = PhotoshootInfo.St.idea
        } else {
            photoShootData?.status = PhotoshootInfo.St.planned
        }
        Photoshoots.sharedInstance.addPhotoshoot(photoShoot: photoShootData!)
        
        if photoShootData?.status != PhotoshootInfo.St.idea {
            createNotifications()
        }
    }
    
    @objc func setStatus() {
        if ideaSwitch.isOn {
            
            dateTextfield.text = ""
        }
    }
    
    func addPaddingAndBorder(to textfield: UITextField) {
        textfield.layer.cornerRadius =  7
        textfield.backgroundColor = UIColor(named: "mainBackground")
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 5.0, height: 2.0))
        textfield.leftView = leftView
        textfield.leftViewMode = .always
    }
    
    //MARK: - Configures
    
    func configureModelInfoView() {
        let header = UILabel()
        
        scrollView.frame = self.view.frame;
        scrollView.contentSize = CGSize(width: view.frame.width, height:  1300)
        
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        scrollView.isPagingEnabled = false
        view.addSubview(scrollView)
        scrollView.pin(to: view)
        
        scrollView.addSubview(header)
        header.pinLeft(to: view, const: 20)
        header.pinRight(to: view.centerXAnchor, const: 16)
        header.pinTop(to: scrollView, const: 10)
        header.setHeight(to: 30)
        header.text = "Модель"
        header.textColor = .systemGray
        
        scrollView.addSubview(modelView)
        modelView.pinLeft(to: view, const: 5)
        modelView.pinRight(to: view, const: 5)
        modelView.pinTop(to: header.bottomAnchor)
        modelView.setHeight(to: 220)
        modelView.backgroundColor = UIColor(named: "viewBackground")
        modelView.layer.cornerRadius = 7
        modelView.layer.shadowRadius = 5
        modelView.layer.shadowOpacity = 0.8
        modelView.layer.shadowOffset = CGSize(width: 0, height: 10)
        modelView.layer.shadowColor = UIColor.systemRed.cgColor
        
        let contactButton = UIButton(type: .system)
        modelView.addSubview(contactButton)
        contactButton.pinTop(to: modelView.safeAreaLayoutGuide.topAnchor, const: 10)
        contactButton.pinLeft(to: modelView, const: 16)
        contactButton.setHeight(to: 30)
        contactButton.setWidth(to: 70)
        contactButton.setTitle("Контакты", for: .normal)
        contactButton.addTarget(self, action: #selector(getContacts), for: .touchUpInside)
        
        modelView.addSubview(modelName)
        modelName.pinLeft(to: modelView, const: 6)
        modelName.pinRight(to: modelView.centerXAnchor, const: 6)
        modelName.pinTop(to: contactButton.bottomAnchor, const: 16)
        modelName.setHeight(to: 40)
        modelName.attributedPlaceholder = NSAttributedString(string: "ФИО",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        modelName.textColor = .black
        addPaddingAndBorder(to: modelName)
        
        modelView.addSubview(modelPhone)
        modelPhone.pinLeft(to: modelView, const: 6)
        modelPhone.pinRight(to: modelView.centerXAnchor, const: 6)
        modelPhone.pinTop(to: modelName.bottomAnchor, const: 16)
        modelPhone.setHeight(to: 40)
        addPaddingAndBorder(to: modelPhone)
        modelPhone.attributedPlaceholder = NSAttributedString(string: " Номер телефона",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        modelPhone.textColor = .black
        modelView.addSubview(modelEmail)
        modelEmail.pinLeft(to: modelView, const: 6)
        modelEmail.pinRight(to: modelView.centerXAnchor, const: 6)
        modelEmail.pinTop(to: modelPhone.bottomAnchor, const: 16)
        modelEmail.setHeight(to: 40)
        addPaddingAndBorder(to: modelEmail)
        modelEmail.attributedPlaceholder = NSAttributedString(string: " Email",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        modelEmail.textColor = .black
        modelView.addSubview(imageBuutton)
        imageBuutton.setWidth(to: 120)
        imageBuutton.pinRight(to: modelView.safeAreaLayoutGuide.trailingAnchor, const: 16)
        imageBuutton.pinTop(to: modelView.safeAreaLayoutGuide.topAnchor, const: 10)
        imageBuutton.setHeight(to: 30)
        imageBuutton.setTitle("Добавить фото", for: .normal)
        imageBuutton.titleLabel?.textColor = UIColor.systemBlue
        imageBuutton.addTarget(self, action: #selector(chooseImage), for: .touchUpInside)
        
        modelView.addSubview(modelImage)
        modelImage.pinLeft(to: modelName.trailingAnchor, const: 16)
        modelImage.pinRight(to: modelView, const: 16)
        modelImage.pinHeight(to: modelView.heightAnchor, mult: 0.8)
        modelImage.pinCenter(to: modelPhone.centerYAnchor)
        modelImage.contentMode = .scaleAspectFit
        
        modelView.clipsToBounds = true
    }
    
    func configureStudioView(){
        let nameLabel = UILabel()
        let linkLabel = UILabel()
        let roomLabel = UILabel()
        let durationLabel = UILabel()
        let titleLabel = UILabel()
        let safariButton = UIButton(type: .system)
        
        scrollView.addSubview(titleLabel)
        titleLabel.pinLeft(to: view, const: 20)
        titleLabel.pinRight(to: view.centerXAnchor, const: 16)
        titleLabel.pinTop(to: modelView.bottomAnchor, const: 10)
        titleLabel.setHeight(to: 30)
        titleLabel.text = "Фотостудия"
        titleLabel.textColor = .systemGray
        
        scrollView.addSubview(studioView)
        studioView.pinLeft(to: view, const: 5)
        studioView.pinRight(to: view, const: 5)
        studioView.pinTop(to: titleLabel.bottomAnchor)
        studioView.setHeight(to: 250)
        studioView.layer.cornerRadius = 5
        studioView.backgroundColor = UIColor(named: "viewBackground")
        
        studioView.addSubview(safariButton)
        safariButton.pinRight(to: studioView.trailingAnchor, const: 5)
        safariButton.pinTop(to: studioView.safeAreaLayoutGuide.topAnchor, const: 10)
        safariButton.setHeight(to: 30)
        safariButton.setWidth(to: 190)
        safariButton.addTarget(self, action: #selector(showSafariVC), for: .touchUpInside)
        safariButton.setTitle("Открыть в Safari", for: .normal)
        safariButton.titleLabel?.textColor = UIColor.systemBlue
        
        studioView.addSubview(nameLabel)
        nameLabel.pinTop(to: safariButton.bottomAnchor, const: 10)
        nameLabel.pinLeft(to: studioView, const: 16)
        nameLabel.pinWidth(to: studioView.widthAnchor, mult: 0.3)
        nameLabel.setHeight(to: 40)
        nameLabel.text = "Фотостудия: "
        nameLabel.textColor = .black
        
        studioView.addSubview(studioName)
        studioName.pinTop(to: safariButton.bottomAnchor, const: 10)
        studioName.pinLeft(to: nameLabel.trailingAnchor, const: 16)
        studioName.pinRight(to: studioView, const: 16)
        studioName.setHeight(to: 40)
        addPaddingAndBorder(to: studioName)
        studioName.textColor = .black
        
        studioView.addSubview(roomLabel)
        roomLabel.pinTop(to: nameLabel.bottomAnchor, const: 10)
        roomLabel.pinLeft(to: studioView, const: 16)
        roomLabel.pinWidth(to: studioView.widthAnchor, mult: 0.3)
        roomLabel.setHeight(to: 40)
        roomLabel.text = "Зал: "
        roomLabel.textColor = .black
        
        studioView.addSubview(studioRoom)
        studioRoom.pinTop(to: studioName.bottomAnchor, const: 10)
        studioRoom.pinLeft(to: roomLabel.trailingAnchor, const: 16)
        studioRoom.pinRight(to: studioView, const: 16)
        studioRoom.setHeight(to: 40)
        studioRoom.textColor = .black
        addPaddingAndBorder(to: studioRoom)
        
        studioView.addSubview(durationLabel)
        durationLabel.pinTop(to: roomLabel.bottomAnchor, const: 10)
        durationLabel.pinLeft(to: studioView, const: 16)
        durationLabel.pinWidth(to: studioView.widthAnchor, mult: 0.3)
        durationLabel.setHeight(to: 40)
        durationLabel.text = "Длительность: "
        durationLabel.textColor = .black
        
        studioView.addSubview(rentDuration)
        rentDuration.pinTop(to: studioRoom.bottomAnchor, const: 10)
        rentDuration.pinLeft(to: roomLabel.trailingAnchor, const: 16)
        rentDuration.pinRight(to: studioView, const: 16)
        rentDuration.setHeight(to: 40)
        rentDuration.textColor = .black
        addPaddingAndBorder(to: rentDuration)
        rentDuration.inputView = durationPicker
        
        studioView.addSubview(linkLabel)
        linkLabel.pinTop(to: durationLabel.bottomAnchor, const: 10)
        linkLabel.pinLeft(to: studioView, const: 16)
        linkLabel.pinWidth(to: studioView.widthAnchor, mult: 0.3)
        linkLabel.setHeight(to: 40)
        linkLabel.text = "Ссылка: "
        linkLabel.textColor = .black
        
        studioView.addSubview(studioLink)
        studioLink.pinTop(to: rentDuration.bottomAnchor, const: 10)
        studioLink.pinLeft(to: linkLabel.trailingAnchor, const: 16)
        studioLink.pinRight(to: studioView, const: 16)
        studioLink.setHeight(to: 40)
        addPaddingAndBorder(to: studioLink)
        studioLink.textColor = .systemBlue
    }
    
    func configureDateView() {
       
        datePicker.datePickerMode = .dateAndTime
        datePicker.frame.size = CGSize(width: 0, height: 50)
        datePicker.addTarget(self, action: #selector(datepickerDone), for: .valueChanged)
        let dateHeader = UILabel()
        let dateLabel = UILabel()
        
        scrollView.addSubview(dateHeader)
        dateHeader.pinLeft(to: view, const: 20)
        dateHeader.setWidth(to: 400)
        // Change this to: strudioView.bottomAnchor
        //dateHeader.pinTop(to: scrollView.topAnchor, const: 10)
        dateHeader.pinTop(to: studioView.bottomAnchor, const: 10)
        dateHeader.setHeight(to: 30)
        dateHeader.text = "Дата и уведомления"
        dateHeader.textColor = .systemGray
        
        scrollView.addSubview(dateView)
        dateView.pinLeft(to: view, const: 5)
        dateView.pinRight(to: view, const: 5)
        dateView.pinTop(to: dateHeader.bottomAnchor)
        dateView.setHeight(to: 135)
        dateView.backgroundColor = UIColor(named: "viewBackground")
        dateView.layer.cornerRadius = 5
        
        dateView.addSubview(setNotificationsButton)
        setNotificationsButton.pinTop(to: dateView.safeAreaLayoutGuide.topAnchor, const: 5)
        setNotificationsButton.pinRight(to: dateView.trailingAnchor, const: 10)
        setNotificationsButton.setWidth(to: 190)
        setNotificationsButton.setTitle("Настроить уведомления", for: .normal)
        setNotificationsButton.addTarget(self, action: #selector(presentNotificationController), for: .touchUpInside)
        
        dateView.addSubview(dateLabel)
        dateLabel.pinTop(to: setNotificationsButton.bottomAnchor, const: 5)
        dateLabel.setHeight(to: 30)
        dateLabel.pinLeft(to: dateView, const: 16)
        dateLabel.setWidth(to: 40)
        dateLabel.text = "Дата"
        dateLabel.textColor = .black
        
        dateView.addSubview(dateTextfield)
        dateTextfield.pinRight(to: dateView.trailingAnchor, const: 16)
        dateTextfield.pinTop(to: setNotificationsButton.bottomAnchor, const: 5)
        dateTextfield.setHeight(to: 30)
        dateTextfield.pinWidth(to: dateView.widthAnchor, mult: 0.5)
        dateTextfield.textColor = .black
        addPaddingAndBorder(to: dateTextfield)
        dateTextfield.inputView = datePicker
        
        let ideaLabel = UILabel()
        dateView.addSubview(ideaLabel)
        ideaLabel.text =  "Сохранить как идею"
        ideaLabel.pinTop(to: dateTextfield.bottomAnchor, const: 16)
        ideaLabel.pinLeft(to: dateView, const: 16)
        ideaLabel.setHeight(to: 30)
        ideaLabel.pinWidth(to: dateView.widthAnchor, mult: 0.7)
        ideaLabel.textColor = .black
        
        dateView.addSubview(ideaSwitch)
        ideaSwitch.pinTop(to: dateTextfield.bottomAnchor, const: 16)
        ideaSwitch.pinRight(to: dateView, const: 16)
        ideaSwitch.setHeight(to: 30)
        ideaSwitch.setWidth(to: 60)
        ideaSwitch.addTarget(self, action: #selector(setStatus), for: .valueChanged)
    }
    
    func configureCommentView(){
        let commnetLabel = UILabel()
        scrollView.addSubview(commnetLabel)
        commnetLabel.pinLeft(to: view, const: 20)
        commnetLabel.pinRight(to: view.centerXAnchor, const: 16)
        commnetLabel.pinTop(to: dateView.bottomAnchor, const: 10)
        commnetLabel.setHeight(to: 30)
        commnetLabel.text = "Заметки"
        commnetLabel.textColor = .systemGray
        
        scrollView.addSubview(commentView)
        commentView.delegate = self
        if photoShootData?.comment == nil {
            commentView.text = "Заметки к фотосъемке..."
            commentView.textColor = .systemGray
        }
        
        commentView.pinLeft(to: view, const: 5)
        commentView.pinRight(to: view, const: 5)
        commentView.pinTop(to: commnetLabel.bottomAnchor)
        commentView.setHeight(to: 150)
        commentView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        commentView.font = UIFont.systemFont(ofSize: 17)
        commentView.layer.borderWidth = 2
        commentView.layer.cornerRadius = 10
        commentView.layer.borderColor = UIColor(named: "viewBackground")?.cgColor
        commentView.backgroundColor = UIColor(named: "mainBackground")
        
    }
    
    func configureMoodboard(){
        
        let moodboardLabel = UILabel()
        scrollView.addSubview(moodboardLabel)
        moodboardLabel.pinLeft(to: view, const: 20)
        moodboardLabel.setWidth(to: 100)
        moodboardLabel.pinTop(to: commentView.bottomAnchor, const: 10)
        moodboardLabel.setHeight(to: 30)
        moodboardLabel.text = "Мудборд"
        moodboardLabel.textColor = .systemGray
        
        let loadImagesButton = UIButton(type: .system)
        scrollView.addSubview(loadImagesButton)
        loadImagesButton.pinRight(to: view, const: 10)
        loadImagesButton.pinTop(to: commentView.bottomAnchor, const: 5)
        loadImagesButton.setHeight(to: 40)
        loadImagesButton.setWidth(to: 190)
        loadImagesButton.addTarget(self, action: #selector(showPHPController), for: .touchUpInside)
        loadImagesButton.setTitle("Загрузить фотографии", for: .normal)
        loadImagesButton.titleLabel?.textColor = UIColor.systemBlue
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        moodboard.setCollectionViewLayout(layout, animated: true)
        moodboard.delegate = self
        moodboard.dataSource = self
        moodboard.backgroundColor = UIColor.clear
        
        scrollView.addSubview(moodboard)
        moodboard.pinTop(to: moodboardLabel.bottomAnchor)
        moodboard.pinLeft(to: view, const: 3)
        moodboard.pinRight(to: view, const: 3)
        moodboard.setHeight(to: 340)
        moodboard.layer.borderWidth = 2
        moodboard.layer.borderColor = UIColor(named: "viewBackground")?.cgColor
        moodboard.backgroundColor = UIColor(named: "mainBackground")
        moodboard.layer.cornerRadius = 5 
    }
    
    
}

//MARK: - Extensions

extension PhotoshootVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return photoshootDuruation.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return photoshootDuruation[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        rentDuration.text = photoshootDuruation[row]
        rentDuration.resignFirstResponder()
    }
}

extension PhotoshootVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MoodboardCell
        cell.image.image = images[indexPath.row]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tap.numberOfTapsRequired = 1
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        doubleTap.numberOfTapsRequired = 2
        
        tap.require(toFail: doubleTap)
        tap.delaysTouchesBegan = true
        doubleTap.delaysTouchesBegan = true
        
        cell.addGestureRecognizer(tap)
        cell.addGestureRecognizer(doubleTap)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func tapAction(_ sender: UITapGestureRecognizer) {
        
        let vc = FullScreenVC()
        vc.images = self.images
        
        if let indexPath = self.moodboard.indexPathForItem(at: sender.location(in: self.moodboard)) {
            vc.startIndex = indexPath
            self.navigationController?.pushViewController(vc, animated: true)
        } 
    }
    
    @objc func doubleTapAction(_ sender: UITapGestureRecognizer) {
        if let indexPath = self.moodboard.indexPathForItem(at: sender.location(in: self.moodboard)) {
            images.remove(at: indexPath.item)
        }
        
        for image in images {
            print(image)
        }
        
        moodboard.reloadData()
    }
}

extension PhotoshootVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
        
        resultImagesCount += results.count
    
        let dispatchGroup = DispatchGroup()
        results.forEach {
            dispatchGroup.enter()
            $0.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                if let image = image as? UIImage {
                    self.images.append(image)
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.moodboard.reloadData()
        }
        
        
    }
}

extension PhotoshootVC:  UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: moodboard.frame.width / 3, height: moodboard.frame.width / 3)
    }
}

//MARK: - CNContactPickerDelegate
extension PhotoshootVC: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController,
                       didSelect contact: CNContact) {
        picker.dismiss(animated: true, completion: nil)
        let name = CNContactFormatter.string(from: contact, style: .fullName)
        modelName.text = name
        
        if contact.imageData != nil {
            modelImage.image = UIImage(data: contact.imageData!)
        }
        modelEmail.text = (contact.emailAddresses.first?.value ?? "") as String
        for number in contact.phoneNumbers {
            let mobile = number.value.value(forKey: "digits") as? String
            if (mobile?.count)! > 7 {
                modelPhone.text = mobile
            }
        }
    }
}



 
