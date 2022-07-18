//
//  SimilarMoviesTableViewCell.swift
//  TMDBDemoAppSwift
//
//  Created by Yash Rathore on 22/05/19.
//  Copyright © 2019 Yash Rathore. All rights reserved.
//


import UIKit

//class SimilarMoviesTableViewCell: UITableViewCell,WebServiceDelegate,iCarouselDataSource,iCarouselDelegate {
//
//    @IBOutlet weak var carousel: iCarousel!
//
//    var imageDownloadsInProgress:[String:ImageDownloadUtility] = [:]
//    var similarMoviesArray:[MovieModel] = []
//    var movieModel:MovieModel? = nil
//    var totalPages = 1
//    var pageNumber = 1
//    var wrap : Bool = false
//    var webService:TMDBWebService?
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//        setup()
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//
//    func setup()
//    {
//        self.wrap = true
//        configureWebService()
//        self.carousel.type = iCarouselType.coverFlow2
//        self.carousel.dataSource = self
//        self.carousel.delegate = self
//
//    }
//
//    func configureWebService()
//    {
//        self.webService = TMDBWebService()
//        self.webService?.wsDelegate = self
//    }
//
//
//    func getSimilarMoviesForPageNumber(pageNo:Int)
//    {
//        if pageNumber>totalPages {
//            return
//        }
//        self.webService?.getSimilarMovies(forMovieID: self.movieModel!.movieId, withPageNumber: Int32(pageNo))
//    }
//
//    func setModel(model:MovieModel)
//    {
//        self.movieModel = model
//        getSimilarMoviesForPageNumber(pageNo: pageNumber)
//    }
//
//    //MARK: Carousel handling
//    func numberOfItems(in carousel: iCarousel) -> Int {
//        return similarMoviesArray.count
//    }
//
//    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
//        if carousel.currentItemIndex == self.similarMoviesArray.count - 5 {
//            self.pageNumber+=1;
//            self.getSimilarMoviesForPageNumber(pageNo: self.pageNumber)
//        }
//    }
//
//    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView
//    {
//        let model:MovieModel = self.similarMoviesArray[index]
//        var carouselView = view
//        if carouselView == nil {
//            carouselView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//        }
//
//        let image:UIImage? = model.posterImage
//        if ((image) == nil)
//        {
//            startImageDownload(model: model, index: index)
//            (carouselView as! UIImageView).image = UIImage(named: "PlaceHolder")
//        } else {
//            (carouselView as! UIImageView).image = model.posterImage
//        }
//        return carouselView!
//    }
//
//    func numberOfPlaceholders(in carousel: iCarousel) -> Int {
//        return 2
//    }
//
//    func carousel(_ carousel: iCarousel, placeholderViewAt index: Int, reusing view: UIView?) -> UIView {
//        var carouselView = view
//        if carouselView == nil {
//            carouselView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//            (carouselView as! UIImageView).image = UIImage(named: "page.png")
//            carouselView?.contentMode = ContentMode.center
//        }
//        return carouselView!
//    }
//
//    func carousel(_ carousel: iCarousel, itemTransformForOffset offset: CGFloat, baseTransform transform: CATransform3D) -> CATransform3D {
//        var trans = transform
//        trans = CATransform3DRotate(trans, CGFloat(Double.pi / 8.0), 0.0, 1.0, 0.0)
//        return CATransform3DTranslate(trans, 0.0, 0.0, offset * self.carousel.itemWidth)
//    }
//
//    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
//        switch option {
//        case iCarouselOption.wrap:
//            return 1.0
//        case iCarouselOption.spacing:
//            return value * 1.05
//        case iCarouselOption.fadeMax:
//            if self.carousel.type == iCarouselType.custom
//            {
//                return 0.0
//            }
//            return value
//        default:
//            return value
//        }
//    }
//
//    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
//        let model:MovieModel = self.similarMoviesArray[index]
//
//        if model.posterPath != "NoData"{
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "similarMovieSelected"), object: nil, userInfo: ["movieObject":model])
//        }
//    }
//
//    // MARK: - Download Logic
//    func startImageDownload(model:MovieModel, index:Int)
//    {
//        var imageDownloadUtility = self.imageDownloadsInProgress["\(index)"]
//        if imageDownloadUtility == nil {
//            imageDownloadUtility = ImageDownloadUtility()
//            imageDownloadUtility!.model = model
//            imageDownloadUtility?.completionBlock = { ()  -> Void in
//                let subView:UIView? = self.carousel.itemView(at: index)
//
//                if subView != nil {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    (subView as! UIImageView).image = model.posterImage;
//                }
//                self.imageDownloadsInProgress.removeValue(forKey:"\(index)")
//            }
//            };
//        }
//        self.imageDownloadsInProgress["\(index)"] = imageDownloadUtility
//        imageDownloadUtility?.startImageDownload()
//    }
//
//
//    // MARK: - Web Service Delegate
//    func webServiceResponse(_ responseDict: [AnyHashable : Any]) {
//        let result:Int = responseDict[RETPARAM_RESULT] as? Int ?? 0
//
//        if result < 0 {
//            let errorInfoDict:NSDictionary? = responseDict[RETPARAM_ERROR] as? NSDictionary
//
//            if errorInfoDict != nil{
//
//                let errorType:Int32 = errorInfoDict?[RETPARAM_ERROR_TYPE] as! Int32
//                let errorSubType:Int32 = errorInfoDict?[RETPARAM_ERROR_SUBTYPE] as! Int32
//
//                switch errorType {
//                case ERROR_TYPE_INTERNAL:
//                    //TODO: handle error
//                    print("ERROR_TYPE_INTERNAL")
//                    if (errorSubType == ERROR_WS_PARAMS_ERROR) {
//                        //TODO: handle error
//                        //Error Type Parameter
//                    }
//                    else if (errorSubType == ERROR_WS_NO_CONNECTOR){
//                        //TODO: handle error
//
//                    }
//                case ERROR_TYPE_LOCK:
//                    //TODO: handle error
//                    print("ERROR_TYPE_LOCK")
//                case ERROR_TYPE_COMMUNICATION:
//
//                    if (errorSubType == ERROR_WS_DATA_NOT_FOUND) {
//                        //Error Type Parameter
//                        print("ERROR_WS_DATA_NOT_FOUND")
//                        let movieModel:MovieModel = MovieModel()
//                        movieModel.posterPath = "NoData"
//                        movieModel.posterImage = UIImage(named: "NoData")!
//                        self.similarMoviesArray.append(movieModel)
//                        self.carousel.reloadData()
//                    }
//                    else if(errorSubType == STATUS_CODE_NOT_CONNECTED_TO_INTERNET){
//
//                        let alert:UIAlertController = UIAlertController(title:"No network", message: "Network issue. Please wait till network restore.", preferredStyle: UIAlertController.Style.alert)
//                        //Add Buttons
//                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
//                            //Cancel Action
//                        }))
//                        self.window?.rootViewController?.navigationController?.topViewController?.present(alert, animated: true, completion: nil)
//                    }
//                    else{
//                        //TODO: handle error
//                        print("ERROR_TYPE_COMMUNICATION")
//                    }
//                case ERROR_TYPE_ACCOUNT:
//                    //TODO: handle error
//                    print("ERROR_TYPE_ACCOUNT")
//                case ERROR_TYPE_SERVER:
//                    //TODO: handle error
//                    print("ERROR_TYPE_SERVER")
//                default:
//                    //TODO: handle error
//                    print("Unknown Error")
//                }
//
//            }
//        }
//        else{
//            let tempArray:[MovieModel] = responseDict[RETPARAM_MOVIE_ARRAY] as! [MovieModel];
//            self.totalPages = responseDict[RETPARAM_TOTAL_PAGES] as! Int
//            similarMoviesArray.append(contentsOf: tempArray)
//            self.carousel.reloadData()
//        }
//    }
//}
