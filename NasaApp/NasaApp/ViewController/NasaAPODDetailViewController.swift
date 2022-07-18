//
//  NasaAPODDetailViewController.swift
//  NasaApp
//
//  Created by Yash Rathore on 17/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

import UIKit

class NasaAPODDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var apodModel:APODModel? = nil
    @IBOutlet weak var apodDetailTableView: UITableView!
    @IBOutlet weak var apodImage: UIImageView!
    
    let cellIdentifiersArray = [CellIdentifier.APODNameCell.rawValue,CellIdentifier.APODInfoCell.rawValue]
    
    //MARK: View Lifecycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        configureNavigationBar()
        
        guard let model = apodModel, let imageURL = NSURL.init(string: model.sdUrl ?? "") else{
            return
        }
        
        ImageDownloadUtility.imageCache.load(url:imageURL , item: model) { (fetchedItem, image) in
            DispatchQueue.main.async { [self] in
                
                if let img = image, img != fetchedItem.image {
                    self.apodImage.image = img
                    self.apodModel?.image = img
                }
                else{
                    model.image = image
                    self.apodModel?.image = image
                    self.apodImage.image = image
                }
                guard let indexPathArray = self.apodDetailTableView.indexPathsForVisibleRows else{
                    return
                }
                self.apodDetailTableView.reloadRows(at:indexPathArray , with: UITableView.RowAnimation.fade)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setup() {
        let bgImage:UIImage? = self.apodModel?.image
        if bgImage == nil {
            self.apodImage.image = ImageDownloadUtility.placeholderImage
        }
        else{
            self.apodImage.image = bgImage
        }
        self.apodDetailTableView.contentInset = UIEdgeInsets(top: 300, left: 0, bottom: 0, right: 0)
    }
    
    func configureNavigationBar(){
        self.navigationItem.largeTitleDisplayMode = .never
        self.title = "APOD Detail View"
    }
    
    //MARK: Table view handling
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellIdentifiersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiersArray[indexPath.row])
        if indexPath.row == 1{
            (cell as! APODDetailViewCell).setModel(apodModel: self.apodModel!)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            cell.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
            cell.textLabel?.text = self.apodModel?.title
            cell.textLabel?.numberOfLines = 0
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
