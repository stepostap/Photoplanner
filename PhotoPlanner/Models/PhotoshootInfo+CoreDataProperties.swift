

import Foundation
import CoreData


extension PhotoshootInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoshootInfo> {
        return NSFetchRequest<PhotoshootInfo>(entityName: "PhotoshootInfo")
    }

    @NSManaged public var modelImage: Data?
    @NSManaged public var modelName: String?
    @NSManaged public var modelMail: String?
    @NSManaged public var modelPhone: String?
    @NSManaged public var date: Date?
    @NSManaged public var link: String?
    @NSManaged public var status: St
    @NSManaged public var studioName: String?
    @NSManaged public var id: Int
    @NSManaged public var comment: String?
    @NSManaged public var imageKeys: String?
    @NSManaged public var studioRoom: String?
    @NSManaged public var rentDuration: String?
    
    public func getFilterInfo() -> String {
        var str = studioName ?? ""
        str += modelName ?? " "
        return str.lowercased()
    }
    
    @objc public enum St : Int32, Codable{
        case done = 0
        case planned = 1
        case idea = 2
    }

}

extension PhotoshootInfo : Identifiable {

}
