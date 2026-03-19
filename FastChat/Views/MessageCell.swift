

import UIKit

class MessageCell: UITableViewCell {

  
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageBackgroundView: UIView!
    @IBOutlet weak var leftImageView: UIImageView!
    override func awakeFromNib() {
    super.awakeFromNib()
    
        messageBackgroundView.layer.cornerRadius = 15
        messageBackgroundView.clipsToBounds = true
}

override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
}

}
