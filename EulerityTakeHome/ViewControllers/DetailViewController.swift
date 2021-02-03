//
//  DetailViewController.swift
//  EulerityTakeHome
//
//  Created by Nick Nguyen on 2/3/21.
//

import UIKit

class DetailViewController: UIViewController {

  @IBOutlet weak var detailImageView: UIImageView!

  var selectedImage: ImageObject? // url

  override func viewDidLoad() {
    super.viewDidLoad()
    if let selectedImage = selectedImage {
      detailImageView.loadImageUsingCache(withUrl: selectedImage.url)
    }
  }

  @IBAction func uploadTapped(_ sender: UIBarButtonItem) {
  }

  @IBAction func applyFilter(_ sender: UIButton) {
  }

  @IBAction func addOverlayText(_ sender: UIButton) {
  }

}
