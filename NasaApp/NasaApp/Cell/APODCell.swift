//
//  APODCell.swift
//  NasaApp
//
//  Created by Yash Rathore on 16/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//

import UIKit

protocol  APODCellDelegate{
    func favouriteButtonAction(_ cell: APODCell)
}

class APODCell: UITableViewCell {

    @IBOutlet weak var apodImageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var favouriteImageView: UIImageView!
    @IBOutlet weak var favouriteBtn: UIButton!
    
    var actionDelegate: APODCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setModel(model:APODModel, showFavourite:Bool = false) {
        self.title.text = model.title
        self.releaseDate.text = model.releaseDate
        if(model.favourite == true){
            self.favouriteImageView.image = UIImage.init(named: "fill")
            self.favouriteBtn.titleLabel?.text = "Remove favourite"
        }
        else{
            self.favouriteImageView.image = UIImage.init(named: "empty")
            self.favouriteBtn.titleLabel?.text = "Add to favourite"
        }
        self.favouriteBtn.isHidden = showFavourite
    }
    
    @IBAction func favouriteButtonAction(_ sender: Any) {
        guard let delegate = self.actionDelegate  else{
            return
        }
        delegate.favouriteButtonAction(self)
    }

}
