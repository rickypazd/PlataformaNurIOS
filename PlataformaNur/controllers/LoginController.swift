import Alamofire

import UIKit
import SVProgressHUD
import SwiftyJSON

class LoginController: UIViewController {

    @IBOutlet weak var tfRegister: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func validateLogin(_ sender: Any) {
        let register:String = tfRegister.text!
        let password:String = tfPassword.text!
        
        if register.isEmpty {
            // TODO: validate the register
        }
        
        if password.isEmpty {
            // TODO: validate the password
        }
        
        login(register: register, password: password)
    }
    
    func login(register:String, password:String) {
//        if 1 == 1 {
////            let career = Career()
////            career.LCARRERA_ID = 1
////            career.SCARRERA_DSC = "Ingeniería de sistemas"
//
//            let realm = try! Realm()
//
//            let careers = realm.objects(Career.self)
//            let grades = realm.objects(Grade.self)
//            print("careers count \(careers.count)") // => 0 because no dogs have been added to the Realm yet
//            print("grades count \(grades.count)")
//
//            let offers = realm.objects(Offer.self)
//
//            for offer in offers {
//                print(offer.SMATERIA_DSC)
//            }
//
//
//
//            return
//        }
        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show(withStatus: "Iniciando sesión...")
        
        // TODO: use the parameters
        let parameters = [
//            "username":"520577",
//            "password":"11955",
            "username":"503265",
            "password":"99008",
            "bloqueo": false
            ] as [String : Any]
        
        let url = "http://sisnur.nur.edu:8085/api/Registros/Login"
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString { response in
            switch response.result {
            case .success:
                var apiResponse = response.result.value!
                apiResponse = apiResponse.replacingOccurrences(of: "\"", with: "")
                
                if apiResponse == "Bloqueo. Tiene deuda pendiente." {
                    Util.showAlert(title: "Hubo un error", message: apiResponse)
                } else {
                    Util.setToken(token: "\(apiResponse)")
                    
                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarMainController") as! TabBarMainController
                    viewController.selectedViewController = viewController.viewControllers?[1]
                    self.present(viewController, animated: false, completion: nil)
                }

                break

            case .failure:
                Util.showAlert(title: "Error", message: "No se pudo conectar con el servidor")
                break
            }

            SVProgressHUD.dismiss()
        }
    }
    
   
    
}
