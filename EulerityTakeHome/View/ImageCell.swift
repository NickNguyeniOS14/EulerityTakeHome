//
//  ImageCell.swift
//  EulerityTakeHome
//
//  Created by Nick Nguyen on 2/2/21.
//
import UIKit

class ImageCell: UITableViewCell {

  @IBOutlet weak var cellImageView: UIImageView!

  func update(with urlString: String?) {
    if let string = urlString {
      cellImageView.loadImageUsingCache(withUrl: string)
    } else {
      cellImageView.image = nil
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    update(with: nil)
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    update(with: nil)
  }
}
