//
//  NASASearchAPIViewController.swift
//  NasaApp
//
//  Created by Yash Rathore on 18/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

import UIKit

class NASASearchAPIViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var dateFormatter = DateFormatter()
    private var webService:APODWebService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureWebService()
        
        dateLabel.text = "Select the date"
        
        dateFormatter.calendar = .init(identifier: .iso8601)
        dateFormatter.locale = .init(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    func configureWebService(){
        self.webService = APODWebService()
        self.webService?.wsDelegate = self
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        let strDate = dateFormatter.string(from: datePicker.date)
        dateLabel.text = strDate
    }
    
    
    @IBAction func searchAction(_ sender: Any) {
        guard let dateString = dateLabel.text, let _ = dateFormatter.date(from: dateString) else{
            dateLabel.text = "Invalid date"
            return
        }
        dateLabel.text = "Loading"
        self.webService?.searchAPOD(forDate: dateString)
    }
}

// MARK: - Web Service Delegate
extension NASASearchAPIViewController: WebServiceDelegate{
   
    func webServiceResponse(_ responseDict: [AnyHashable : Any]) {
        let result:Int = responseDict[RETPARAM_RESULT] as? Int ?? 0
        
        if result < 0 {
            dateLabel.text = "Error"
            let errorInfoDict:NSDictionary? = responseDict[RETPARAM_ERROR] as? NSDictionary

            if errorInfoDict != nil{

                let errorType:Int32 = errorInfoDict?[RETPARAM_ERROR_TYPE] as! Int32
                let errorSubType:Int32 = errorInfoDict?[RETPARAM_ERROR_SUBTYPE] as! Int32

                switch errorType {
                case ERROR_TYPE_INTERNAL:
                    //TODO: handle error
                    print("ERROR_TYPE_INTERNAL")
                    if (errorSubType == ERROR_WS_PARAMS_ERROR) {
                        //TODO: handle error
                        //Error Type Parameter
                    }
                    else if (errorSubType == ERROR_WS_NO_CONNECTOR){
                        //TODO: handle error

                    }
                case ERROR_TYPE_LOCK:
                    //TODO: handle error
                    print("ERROR_TYPE_LOCK")
                case ERROR_TYPE_COMMUNICATION:

                    if (errorSubType == ERROR_WS_DATA_NOT_FOUND) {
                        //Error Type Parameter
                        print("ERROR_WS_DATA_NOT_FOUND")
                    }
                    else if(errorSubType == STATUS_CODE_NOT_CONNECTED_TO_INTERNET){

                        let alert:UIAlertController = UIAlertController(title:"No network", message: "Network issue. Please wait till network restore.", preferredStyle: UIAlertController.Style.alert)
                        //Add Buttons
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
                            //Cancel Action
                        }))
                        self.navigationController?.present(alert, animated: true)
                    }
                    else{
                        //TODO: handle error
                        print("ERROR_TYPE_COMMUNICATION")
                    }
                case ERROR_TYPE_ACCOUNT:
                    //TODO: handle error
                    print("ERROR_TYPE_ACCOUNT")
                case ERROR_TYPE_SERVER:
                    //TODO: handle error
                    print("ERROR_TYPE_SERVER")
                default:
                    //TODO: handle error
                    print("Unknown Error")
                }

            }
        }
        else{
            guard let tempArray:[APODModel] = responseDict[RETPARAM_SEARCH_ARRAY] as? [APODModel] else{
                return
            }
            DispatchQueue.main.async {
                self.dateLabel.text = "Select the date"
                guard let detailViewController = UIStoryboard.init(name: "NasaApp", bundle: Bundle.main).instantiateViewController(withIdentifier: "NasaAPODDetailViewController") as? NasaAPODDetailViewController else{
                    return
                }
                detailViewController.apodModel = tempArray.first
                detailViewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(detailViewController, animated: true)
                
            }
        }
    }
}
