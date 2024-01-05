//
//  NewsTableViewCell.swift
//  Project-9-NewsApp
//
//  Created by suhail on 22/09/23.
//

import UIKit
class NewsTableViewCellViewModel{
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    
    init(title: String, subtitle: String, imageURL: URL?) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
    }
 
}
class NewsTableViewCell: UITableViewCell {
    static let identifier = "NewsTableViewCell"
    static let nib = UINib(nibName: "NewsTableViewCell", bundle: nil)
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDetail: UILabel!
    @IBOutlet var imgNewsHeadline: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgNewsHeadline.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel){
        lblTitle.text = viewModel.title
        lblDetail.text = viewModel.subtitle
        
        if let data = viewModel.imageData{
            imgNewsHeadline.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL{
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                if let imageData = data, error==nil{
                    viewModel.imageData = imageData
                    DispatchQueue.main.async {
                        self?.imgNewsHeadline.image = UIImage(data: imageData)
                    }
                    
                }
                
            }.resume()
        }
    }
    
}
