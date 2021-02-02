//
//  ImageCell.swift
//  EulerityTakeHome
//
//  Created by Nick Nguyen on 2/2/21.
//
import UIKit

class ImageCell: UITableViewCell {

  @IBOutlet var cellImageView: UIImageView!

  override func prepareForReuse() {
    super.prepareForReuse()

    cellImageView.image = nil

  }
}
