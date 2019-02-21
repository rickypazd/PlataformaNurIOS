import Alamofire
import SVProgressHUD
import SwiftyJSON
import UIKit

class GradesViewController: UIViewController {
    
//    @IBAction func handleSelection(_ sender: UIButton) {
//        careersButton.forEach { (button) in
//            UIView.animate(withDuration: 0.3, animations: {
//                button.isHidden = !button.isHidden
//                self.view.layoutIfNeeded()
//            })
//        }
//    }
//    @IBOutlet var careersButton: [UIButton]!
//    @IBOutlet weak var careersStackView: UIStackView!
//
//    @IBAction func careerTapped(_ sender: UIButton) {
//        guard let title = sender.currentTitle else {
//            return
//        }
//
//        print(title)
//    }
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshSubjects), for: .valueChanged)
        
        return refreshControl
    }()

    @IBOutlet weak var careerPickerView: UIPickerView!
    @IBOutlet weak var subjectsTableView: UITableView!
    
    var careersList:[JSON] = []
    var subjectsList:[JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.subjectsTableView.refreshControl = refresher
        self.getCareers()
        
        let button = UIButton()
        button.setTitle("Relaciones internacionales", for: .normal)

        //let button2 = careersButton[1]
        //button2.setTitle("Derecho", for: .normal)
        //careersButton.append(button2)
        
//        careersButton.remove(at: 1)
        
//        self.careersButton.append(button)
//        self.view.layoutIfNeeded()
//        careersStackView.reloadInputViews()
//        careersStackView.layoutIfNeeded()
    }
    
    func getCareers() -> Void {
        let url = "http://sisnur.nur.edu:8085/api/Registros/GetAlumnoCarreras"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Util.getToken()!)",
            "Accept": "application/json"
        ]
        
        Alamofire.request(url, method: .post, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                let respuesta = JSON(response.data!)
                
                if respuesta["Status"].boolValue {
                    self.careersList = respuesta["Data"].array!
                    
                    self.careerPickerView.reloadAllComponents()
                    
                    if self.careersList.count == 1 {
                        self.careerPickerView.isHidden = false
                    }
                    
                    // getting the subjects of the first career
                    let career = self.careersList[0]
                    self.getSubjects(careerId: career["LCARRERA_ID"].int!, semesterId: career["LPERIODOACTUAL_ID"].int!) //)
                }
                
                break
                
            case .failure:
                self.showLoginDialog()
                break
            }
        }
    }
    
    func showLoginDialog() {
        let alert = UIAlertController(title: "Vuelva a iniciar sesión", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Número de registro"
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Pin"
            textField.isSecureTextEntry = true
        }
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            let register = alert.textFields?.first?.text!
            let password = alert.textFields![1].text!
            
            self.loginAgain(register: register!, password: password, alert: alert)
            
            alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(okAction)
        
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    func loginAgain(register:String, password:String, alert: UIAlertController) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show(withStatus: "Iniciando sesión...")
        
        let parameters = [
            "username": register,
            "password": password,
            "bloqueo": false // TODO: remove this
            ] as [String : Any]
        
        let url = "http://sisnur.nur.edu:8085/api/Registros/Login"
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString { response in
            switch response.result {
            case .success:
                var apiResponse = response.result.value!
                apiResponse = apiResponse.replacingOccurrences(of: "\"", with: "")
                
                if apiResponse == "Bloqueo. Tiene deuda pendiente." {
                    Util.showAlert(title: "Hubo un error", message: apiResponse)
                    self.showLoginDialog()
                } else {
                    Util.setToken(token: apiResponse)
                    self.getCareers()
                }
                
                break
                
            case .failure:
                Util.showAlert(title: "Error", message: "No se pudo conectar con el servidor")
                break
            }
            
            SVProgressHUD.dismiss()
        }
    }
    
    func getSubjects(careerId:Int, semesterId:Int) -> Void {
        let url = "http://sisnur.nur.edu:8085/api/Registros/GetNotasFaltas"
        
        let parameters: Parameters = [
            "pCarreraId": "\(careerId)",
            "pPeriodoId": "\(semesterId)"
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Util.getToken()!)",
            "Accept": "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                let respuesta = JSON(response.data!)
                
                if respuesta["Status"].boolValue {
                    self.subjectsList = respuesta["Data"].array!
                    self.subjectsTableView.reloadData()
                    
                }
                
                break
                
            case .failure:
                break
            }
        }
    }
    
    @objc
    func refreshSubjects() {
        let careerIndex = careerPickerView.selectedRow(inComponent: 0)
        let career = self.careersList[careerIndex]
        
        self.getSubjects(careerId: career["LCARRERA_ID"].int!, semesterId: career["LPERIODOACTUAL_ID"].int!)
        
        self.refresher.endRefreshing()
    }
    
}

extension GradesViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.careersList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.careersList[row]["SCARRERA_DSC"].string!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let career = self.careersList[row]
        self.getSubjects(careerId: career["LCARRERA_ID"].int!, semesterId: career["LPERIODOACTUAL_ID"].int!)
    }
    
}

extension GradesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //self.subjectsList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.subjectsList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectCell", for: indexPath) as! SubjectCell
        
        let index = indexPath.section// row
        let subject = self.subjectsList[index]
        
        cell.lbSubjectName.text = subject["SMATERIA_DSC"].string!
        cell.lbTeacherName.text = subject["DOCENTE"].string!
        
        return cell
    }
    
}
