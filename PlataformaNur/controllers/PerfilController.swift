import Alamofire
import SVProgressHUD
import SwiftyJSON
import UIKit

class PerfilController: UIViewController {

    @IBOutlet weak var lbStudentName: UILabel!
    @IBOutlet weak var lbStudentHours: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.obtenerPerfil()
    }
    
    func obtenerPerfil() -> Void {
        let url = "http://sisnur.nur.edu:8085/api/Registros/GetAlumnoInfo"

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Util.getToken()!)",
            "Accept": "application/json"
        ]
        
        Alamofire.request(url, method: .post, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                let respuesta = JSON(response.data!)
                
                if respuesta["Status"].boolValue {
                    let student = respuesta["Data"]
                    
                    self.lbStudentName.text = "\(student["SNOMBRES"].string!) \(student["SAPELLIDOP"].string!) \(student["SAPELLIDOM"].string!)"
                    self.lbStudentHours.text = String(describing: student["LHORASERVICIO"].int!)
                }
            
                break
                
            case .failure:
                break
            }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        Util.setToken(token: nil)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as! LoginController
        self.present(vc, animated: false, completion: nil)
    }
    
}
