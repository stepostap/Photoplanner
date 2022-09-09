
import Foundation
import UIKit
import CoreData

class Photoshoots {
    static let sharedInstance = Photoshoots()
    
    var allPhotoshoots = [PhotoshootInfo]()
    var plannedPhotoshoots = [PhotoshootInfo]()
    var ideaPhotoshoots = [PhotoshootInfo]()
    var archivePhotoshoots = [PhotoshootInfo]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getAllItems(){
        do{
            ideaPhotoshoots.removeAll()
            plannedPhotoshoots.removeAll()
            archivePhotoshoots.removeAll()
            allPhotoshoots = try context.fetch(PhotoshootInfo.fetchRequest())
            for photoshoot in allPhotoshoots {
                
                if photoshoot.date == nil {
                    ideaPhotoshoots.append(photoshoot)
                }
                else if photoshoot.date! < Date() {
                    
                    photoshoot.status = PhotoshootInfo.St.done
                    archivePhotoshoots.append(photoshoot)
                } else {
                    plannedPhotoshoots.append(photoshoot)
                }
            } 
            
            plannedPhotoshoots.sort(by: {$0.date!.timeIntervalSinceNow < $1.date!.timeIntervalSinceNow})
            archivePhotoshoots.sort(by: {$0.date!.timeIntervalSinceNow > $1.date!.timeIntervalSinceNow})
            ideaPhotoshoots.sort(by: {$0.id > $1.id})
        }
        catch{
            
        }
    }
    
    func deleteItem(photoshoot: PhotoshootInfo) {
        context.delete(photoshoot)
        do{
            try context.save()
            getAllItems()
        }
        catch{
            
        }
    }
    
    func addPhotoshoot(photoShoot: PhotoshootInfo) {
        allPhotoshoots.append(photoShoot)
        do{
            try context.save()
            getAllItems()
        }
        catch{
            
        }
    }
}
