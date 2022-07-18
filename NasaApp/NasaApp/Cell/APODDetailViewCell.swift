
//  Created by Yash Rathore on 17/07/22.
//  Copyright © 2022 Yash Rathore. All rights reserved.
//


import UIKit

class APODDetailViewCell: UITableViewCell {

    @IBOutlet weak var apodOverview: UILabel!
    @IBOutlet weak var favouriteImageView: UIImageView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var copyRightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setModel(apodModel:APODModel)
    {
        self.apodOverview.text = apodModel.pictureDetail
        self.copyRightLabel.text = apodModel.copyrightMessage
        self.releaseDateLabel.text = apodModel.releaseDate
        apodModel.favourite == true ? (self.favouriteImageView.image = UIImage.init(named: "fill")): (self.favouriteImageView.image = UIImage.init(named: "empty"))
    }    
}
