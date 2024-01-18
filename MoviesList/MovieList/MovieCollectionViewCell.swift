import UIKit


class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posImg: UIImageView!
    
    @IBOutlet weak var titLabel: UILabel!
    
    
    override func awakeFromNib() {
           super.awakeFromNib()
           
           // Set the title label font
           titLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
           
           
           titLabel.textColor = .white
           titLabel.numberOfLines = 2
         
       }
    func updateTheme(_ theme: Theme) {
           
            if theme == .dark {
              
                backgroundColor = .black
             
            } else {
               
                backgroundColor = .white
                
            }
        }
}
