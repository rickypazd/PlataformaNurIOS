import Alamofire
import SVProgressHUD
import SwiftyJSON
import UIKit

import UIKit

class OffersController: UIViewController {

    @IBOutlet weak var careerPickerView: UIPickerView!
    @IBOutlet weak var semesterPickerView: UIPickerView!
    @IBOutlet weak var subjectsTableView: UITableView!
    
    let STEPS_REQUIRED = 2
    var STEPS_COMPLETED:Int = 0
    
    var careersList:[JSON] = []
    var semestersList:[JSON] = []
    var subjectsList:[JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getCareers()
        self.getSemesters()
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
                    
                    self.checkIfCompleted()
                }
                
                break
                
            case .failure:
                break
            }
        }
    }
    
    func getSemesters() -> Void {
        let url = "http://sisnur.nur.edu:8085/api/Registros/GetPeriodosOferta"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Util.getToken()!)",
            "Accept": "application/json"
        ]
        
        Alamofire.request(url, method: .post, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                let respuesta = JSON(response.data!)
                
                if respuesta["Status"].boolValue {
                    self.semestersList = respuesta["Data"].array!
                    
                    self.semesterPickerView.reloadAllComponents()
                    
                    self.checkIfCompleted()
                }
                
                break
                
            case .failure:
                break
            }
        }
    }
    
    func checkIfCompleted() {
        STEPS_COMPLETED += 1
        
        if (STEPS_COMPLETED == STEPS_REQUIRED) {
            let semesterIndex = semesterPickerView.selectedRow(inComponent: 0)
            let semester = self.semestersList[semesterIndex]
            
            let careerIndex = careerPickerView.selectedRow(inComponent: 0)
            let career = self.careersList[careerIndex]
            
            self.getSubjectsOffered(semesterId: semester["LPERIODO_ID"].int!, careerId: career["LCARRERA_ID"].int!)
            
            STEPS_COMPLETED = 0
        }
    }
    
    func getSubjectsOffered(semesterId:Int, careerId:Int) -> Void {
        let url = "http://sisnur.nur.edu:8085/api/Registros/GetAlumnoOferta"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Util.getToken()!)",
            "Accept": "application/json"
        ]
        
        let parameters = [
            "pCarreraId": careerId,
            "pPeriodoId": semesterId
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
    
}

extension OffersController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == careerPickerView {
            return careersList.count
        } else {
            return semestersList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == careerPickerView {
            return self.careersList[row]["SCARRERA_DSC"].string!
        } else {
            return self.semestersList[row]["SPERIODO_DSC"].string!
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == careerPickerView {
            let semesterIndex = semesterPickerView.selectedRow(inComponent: 0)
            let semester = self.semestersList[semesterIndex]
            
            getSubjectsOffered(semesterId: semester["LPERIODO_ID"].int!, careerId: self.careersList[row]["LCARRERA_ID"].int!)
        } else {
            let careerIndex = careerPickerView.selectedRow(inComponent: 0)
            let career = self.careersList[careerIndex]
            
            getSubjectsOffered(semesterId: self.semestersList[row]["LPERIODO_ID"].int!, careerId: career["LCARRERA_ID"].int!)
        }
    }
    
    
}

extension OffersController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjectsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subjectOfferedCell", for: indexPath) as! SubjectOfferedCell

        let index = indexPath.row
        let subject = self.subjectsList[index]

        cell.lbSubjectName.text = subject["SMATERIA_DSC"].string!
        cell.lbGroupName.text = subject["SCODGRUPO"].stringValue

        return cell
    }

}
