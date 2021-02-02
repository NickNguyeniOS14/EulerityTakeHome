//
//  ImageCell.swift
//  EulerityTakeHome
//
//  Created by Nick Nguyen on 2/2/21.
//
import UIKit

class ImageCell: UITableViewCell {

  @IBOutlet var cellImageView: UIImageView!
  var onReuse: () -> Void = {}

  override func prepareForReuse() {
    super.prepareForReuse()
    onReuse()
    cellImageView.image = nil
    cellImageView.cancelImageLoad()
  }
}
