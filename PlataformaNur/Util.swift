import Foundation
import UIKit
import SwiftyJSON

class Util {
    
    private static let USER = "user"
    private static let TOKEN = "token"
    private static let CAREERS = "careers"
    private static let GRADES = "grades"
    private static let SEMESTERS = "semesters"
    private static let OFFERS = "offers"
    
    static let url:String = "http://biblio.nur.edu/NurServices/api/NotasWeb"
    
    class func getUser() -> JSON? {
        let user = UserDefaults.standard.dictionary(forKey: USER)
        
        if user == nil {
            return nil
        }
        
        return JSON(user!)
    }
    
    class func setUser(user:Any?) {
        if user == nil {
            UserDefaults.standard.removeObject(forKey: USER)
            return
        }
        
        UserDefaults.standard.setValue(user, forKey: USER)
    }
    
    class func getToken() -> String? {
        let token = UserDefaults.standard.string(forKey: TOKEN)
        
        if token == nil {
            return nil
        }
        
        return token
    }
    
    class func setToken(token:String?) {
        if token == nil {
            UserDefaults.standard.removeObject(forKey: TOKEN)
            return
        }
        
        UserDefaults.standard.setValue(token, forKey: TOKEN)
    }
    
    class func getCareers() -> JSON? {
        let careers = UserDefaults.standard.array(forKey: CAREERS)
        
        if careers == nil {
            return []
        }
        
        return JSON(careers!)
    }
    
    class func setCareers(careers:Any?) {
        if careers == nil {
            UserDefaults.standard.removeObject(forKey: CAREERS)
            return
        }
        
        UserDefaults.standard.setValue(careers, forKey: CAREERS)
    }
    
    class func getGrades() -> JSON? {
        let grades = UserDefaults.standard.array(forKey: GRADES)
        
        if grades == nil {
            return []
        }
        
        return JSON(grades!)
    }
    
    class func setGrades(grades:Any?) {
        if grades == nil {
            UserDefaults.standard.removeObject(forKey: GRADES)
            return
        }
        
        UserDefaults.standard.setValue(grades, forKey: GRADES)
    }
    
    class func getSemesters() -> JSON? {
        let semesters = UserDefaults.standard.array(forKey: SEMESTERS)
        
        if semesters == nil {
            return []
        }
        
        return JSON(semesters!)
    }
    
    class func setSemesters(semesters:Any?) {
        if semesters == nil {
            UserDefaults.standard.removeObject(forKey: SEMESTERS)
            return
        }
        
        UserDefaults.standard.setValue(semesters, forKey: SEMESTERS)
    }
    
    class func getOffers() -> JSON? {
        let offers = UserDefaults.standard.array(forKey: OFFERS)
        
        if offers == nil {
            return []
        }
        
        return JSON(offers!)
    }
    
    class func setOffers(offers:Any?) {
        if offers == nil {
            UserDefaults.standard.removeObject(forKey: OFFERS)
            return
        }
        
        UserDefaults.standard.setValue(offers, forKey: OFFERS)
    }
    
    /* a simple alert with a OK button */
    class func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let actionOk = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(actionOk)
        
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
}

/* this is like a Context in Android. Use it like this: UIApplication.topViewController()? */
extension UIApplication {
    
    static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
    
}
