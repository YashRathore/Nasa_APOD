//
//  NasaAPODViewController.swift
//  NasaApp
//
//  Created by Yash Rathore on 16/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

import UIKit
import Network

enum CellIdentifier : String {
    case APODCell, PlaceHolderCell, APODNameCell, APODInfoCell
}

class NasaAPODViewController: UIViewController {

    @IBOutlet var nasaAPODTableView: UITableView!
    
    private var modelArray = [APODModel]()
    private var favouriteArray = [APODModel]()
    private var webService:APODWebService?
    private var favouriteListBtn:UIButton!
    
    var showFavourite:Bool = false
    
    var filteredModelArray = [APODModel]()
    var resultSearchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
      return resultSearchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return resultSearchController.isActive && !isSearchBarEmpty
    }
    let monitor = NWPathMonitor()
//    var dataSource: UITableViewDiffableDataSource<Section, APODModel>! = nil
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureNetworkMonitor()
        self.configureWebService()
        setUpSearchController()
        configureNavigationBar()
        setUpDataSource()
    }
    
    // MARK: - initializers
    func configureWebService(){
        self.webService = APODWebService()
        self.webService?.wsDelegate = self
    }
    
    func configureNavigationBar(){
        self.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
        self.title = "Search"
        
        let favouriteIconImage = UIImage.init(named: "empty")
        let imageFrame:CGRect = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        self.favouriteListBtn = UIButton.init(frame: imageFrame)
        favouriteListBtn.setBackgroundImage(favouriteIconImage, for: UIControl.State.normal)
        favouriteListBtn.addTarget(self, action: #selector(showFavouriteList), for: UIButton.Event.touchUpInside)
        let rightBarButton = UIBarButtonItem.init(customView:favouriteListBtn)
        self.navigationItem.setRightBarButton(rightBarButton, animated: false)
    }
    
    func configureNetworkMonitor(){
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
            } else {
                print("No connection.")
            }

            print(path.isExpensive)
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    func setUpDataSource(){
        if (modelArray.isEmpty && monitor.currentPath.status == .satisfied ) {
            self.webService?.getAPODRanging(fromStartDate: "2022-06-01", toEndDate: "2022-07-17")
        }
        else{
            let array = CoreDataManager.sharedManager.fetchAPODModels()
            modelArray.removeAll()
            modelArray.append(contentsOf: array)
        }
    }


    func setUpSearchController(){
        resultSearchController.searchResultsUpdater = self
        resultSearchController.obscuresBackgroundDuringPresentation = false
        resultSearchController.searchBar.placeholder = "Search"
        navigationItem.searchController = resultSearchController
        definesPresentationContext = true
        nasaAPODTableView.reloadData()
    }
    
    @objc private func showFavouriteList()
    {
        self.showFavourite = self.showFavourite == true ? false : true
        let imageName = self.showFavourite ? "fill":"empty"
        self.favouriteListBtn.setImage(UIImage.init(named: imageName), for: UIControl.State.normal)
        self.nasaAPODTableView.reloadData()
    }
}

// MARK: - Web Service Delegate
extension NasaAPODViewController: WebServiceDelegate{
   
    func webServiceResponse(_ responseDict: [AnyHashable : Any]) {
        let result:Int = responseDict[RETPARAM_RESULT] as? Int ?? 0
        
        if result < 0 {
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
            guard let tempArray:[APODModel] = responseDict[RETPARAM_RANGE_ARRAY] as? [APODModel] else{
                return
            }
            modelArray.removeAll()
            modelArray.append(contentsOf: tempArray)
            
            CoreDataManager.sharedManager.deleteAll()
            CoreDataManager.sharedManager.save(apodModelArray: modelArray)
            CoreDataManager.sharedManager.saveContext()
            DispatchQueue.main.async {
                self.nasaAPODTableView.reloadData()
            }
        }
    }
}

// MARK: - APODCellDelegate
extension NasaAPODViewController: APODCellDelegate {
    func favouriteButtonAction(_ cell: APODCell){
        guard let cellIndexPath = nasaAPODTableView.indexPath(for: cell) else{
            return
        }
        if(self.showFavourite == false)
        {
            if(self.isFiltering == true){
                let apodModel = filteredModelArray[cellIndexPath.row]
                if(apodModel.favourite == true){
                    apodModel.favourite = false
                    if let index = favouriteArray.firstIndex(of: apodModel) {
                        favouriteArray.remove(at: index)
                    }
                    cell.favouriteImageView.image = UIImage.init(named: "empty")
                }
                else{
                    apodModel.favourite = true
                    favouriteArray.append(apodModel)
                    cell.favouriteImageView.image = UIImage.init(named: "fill")
                }
                if let index = filteredModelArray.firstIndex(of: apodModel) {
                    filteredModelArray[index] = apodModel
                }
                if let index = modelArray.firstIndex(of: apodModel) {
                    modelArray[index] = apodModel
                }
            }
            else{
                let apodModel = modelArray[cellIndexPath.row]
                if(apodModel.favourite == true){
                    apodModel.favourite = false
                    if let index = favouriteArray.firstIndex(of: apodModel) {
                        favouriteArray.remove(at: index)
                    }
                    cell.favouriteImageView.image = UIImage.init(named: "empty")
                }
                else{
                    apodModel.favourite = true
                    favouriteArray.append(apodModel)
                    cell.favouriteImageView.image = UIImage.init(named: "fill")
                }
                if let index = modelArray.firstIndex(of: apodModel) {
                    modelArray[index] = apodModel
                }
            }
        }
//        cell.favouriteBtn.titleLabel?.text == "Add to favourite" ?(cell.favouriteBtn.titleLabel?.text = "Remove favourite"):(cell.favouriteBtn.titleLabel?.text = "Add to favourite")
        
        guard let indexPath = self.nasaAPODTableView.indexPath(for: cell) else{
            return
        }
        self.nasaAPODTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
    }
}

// MARK: - UISearchResultsUpdating
extension NasaAPODViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        if  (showFavourite == true) {
            filteredModelArray = favouriteArray.filter { (model: APODModel) -> Bool in
                return (model.releaseDate?.lowercased() ?? "" ).contains(searchText.lowercased())
            }
        }
        else{
            filteredModelArray = modelArray.filter { (model: APODModel) -> Bool in
                return (model.releaseDate?.lowercased() ?? "" ).contains(searchText.lowercased())
            }
        }
        self.nasaAPODTableView.reloadData()
    }
}


// MARK: - UITableViewDataSource And UITableViewDelegate
extension NasaAPODViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  (showFavourite == true) {
            return isFiltering == true ? filteredModelArray.count: favouriteArray.count>0 ? favouriteArray.count:1
        } else {
            return isFiltering == true ? filteredModelArray.count: modelArray.count>0 ? modelArray.count:1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = nil
        
        if  (showFavourite == true) {
            if (isFiltering) {
                if (self.filteredModelArray.count>0)
                {
                    cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.APODCell.rawValue, for: indexPath)
                } else {
                    cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.PlaceHolderCell.rawValue, for: indexPath)
                }
            }
            else {
                if (self.favouriteArray.count>0)
                {
                    cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.APODCell.rawValue, for: indexPath)
                } else {
                    cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.PlaceHolderCell.rawValue, for: indexPath)
                }
            }
        } else {
            if (isFiltering) {
                if (self.filteredModelArray.count>0)
                {
                    cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.APODCell.rawValue, for: indexPath)
                } else {
                    cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.PlaceHolderCell.rawValue, for: indexPath)
                }
            }
            else {
                if (self.modelArray.count>0)
                {
                    cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.APODCell.rawValue, for: indexPath)
                } else {
                    cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.PlaceHolderCell.rawValue, for: indexPath)
                }
            }
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if  (showFavourite == true) {
            
            if (isFiltering) {
                if (self.filteredModelArray.count>0)
                {
                    let apodModel:APODModel = self.filteredModelArray[indexPath.row]
                    guard let apodCell = cell as? APODCell, let imageURL = NSURL.init(string: apodModel.sdUrl ?? "") else{
                        return
                    }
                    apodCell.setModel(model: apodModel, showFavourite: showFavourite)
                    apodCell.actionDelegate = self
                    apodCell.apodImageView.image = ImageDownloadUtility.placeholderImage
                    ImageDownloadUtility.imageCache.load(url:imageURL , item: apodModel) { (fetchedItem, image) in
                        guard let img = image, img != fetchedItem.image else {
                            apodCell.apodImageView.image = image
                            return
                        }
                        apodCell.apodImageView.image = img
                        apodModel.image = img
                        self.filteredModelArray[indexPath.row] = apodModel
                        
                        if let index = self.modelArray.firstIndex(of: apodModel) {
                            self.modelArray[index] = apodModel
                        }
                        if let index = self.favouriteArray.firstIndex(of: apodModel) {
                            self.favouriteArray[index] = apodModel
                        }
                    }
                }
                else{
                    guard let placeHolderCell = cell as? APODPlaceHolderCell else{
                        return
                    }
                    placeHolderCell.placeHolderLabel.text = "No results"
                }
            }else{
                if self.favouriteArray.count>0 {
                    let apodModel:APODModel = self.favouriteArray[indexPath.row]
                    guard let apodCell = cell as? APODCell, let imageURL = NSURL.init(string: apodModel.sdUrl ?? "") else{
                        return
                    }
                    apodCell.setModel(model: apodModel, showFavourite: showFavourite)
                    apodCell.actionDelegate = self
                    apodCell.apodImageView.image = ImageDownloadUtility.placeholderImage
                    ImageDownloadUtility.imageCache.load(url:imageURL , item: apodModel) { (fetchedItem, image) in
                        guard let img = image, img != fetchedItem.image else {
                            apodCell.apodImageView.image = image
                            return
                        }
                        apodCell.apodImageView.image = img
                        apodModel.image = img
                        self.favouriteArray[indexPath.row] = apodModel
                        if let index = self.modelArray.firstIndex(of: apodModel) {
                            self.modelArray[index] = apodModel
                        }
                    }
                }
                else{
                    guard let placeHolderCell = cell as? APODPlaceHolderCell else{
                        return
                    }
                    placeHolderCell.placeHolderLabel.text = "No favourites available"
                }
            }
        } else {
            if (isFiltering) {
                if (self.filteredModelArray.count>0)
                {
                    let apodModel:APODModel = self.filteredModelArray[indexPath.row]
                    guard let apodCell = cell as? APODCell, let imageURL = NSURL.init(string: apodModel.sdUrl ?? "") else{
                        return
                    }
                    apodCell.setModel(model: apodModel)
                    apodCell.actionDelegate = self
                    apodCell.apodImageView.image = ImageDownloadUtility.placeholderImage
                    ImageDownloadUtility.imageCache.load(url:imageURL , item: apodModel) { (fetchedItem, image) in
                        guard let img = image, img != fetchedItem.image else {
                            apodCell.apodImageView.image = image
                            return
                        }
                        apodCell.apodImageView.image = img
                        apodModel.image = img
                        self.filteredModelArray[indexPath.row] = apodModel
                        
                        if let index = self.modelArray.firstIndex(of: apodModel) {
                            self.modelArray[index] = apodModel
                        }
                    }
                }else{
                    guard let placeHolderCell = cell as? APODPlaceHolderCell else{
                        return
                    }
                    placeHolderCell.placeHolderLabel.text = "No results"
                }
            }
            else {
                if self.modelArray.count>0 {
                    let apodModel:APODModel = self.modelArray[indexPath.row]
                    guard let apodCell = cell as? APODCell, let imageURL = NSURL.init(string: apodModel.sdUrl ?? "") else{
                        return
                    }
                    apodCell.setModel(model: apodModel)
                    apodCell.actionDelegate = self
                    apodCell.apodImageView.image = ImageDownloadUtility.placeholderImage
                    ImageDownloadUtility.imageCache.load(url:imageURL , item: apodModel) { (fetchedItem, image) in
                        guard let img = image, img != fetchedItem.image else {
                            apodCell.apodImageView.image = image
                            return
                        }
                        apodCell.apodImageView.image = img
                        apodModel.image = img
                        self.modelArray[indexPath.row] = apodModel
                    }
                }else{
                    guard let placeHolderCell = cell as? APODPlaceHolderCell else{
                        return
                    }
                    placeHolderCell.placeHolderLabel.text = "Loading..."
                }
            }
        }
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailViewController = UIStoryboard.init(name: "NasaApp", bundle: Bundle.main).instantiateViewController(withIdentifier: "NasaAPODDetailViewController") as? NasaAPODDetailViewController else{
            return
        }
        if  (showFavourite == true) {
            if (isFiltering) {
                if (self.filteredModelArray.count>0)
                {
                    detailViewController.apodModel = self.filteredModelArray[indexPath.row]
                }
            }
            else {
                if self.favouriteArray.count>0 {
                    detailViewController.apodModel = self.favouriteArray[indexPath.row]
                }
            }
        }
        else{
            if (isFiltering) {
                if (self.filteredModelArray.count>0)
                {
                    detailViewController.apodModel = self.filteredModelArray[indexPath.row]
                }
            }
            else {
                if self.modelArray.count>0 {
                    detailViewController.apodModel = self.modelArray[indexPath.row]
                }
            }
        }
        
        detailViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
