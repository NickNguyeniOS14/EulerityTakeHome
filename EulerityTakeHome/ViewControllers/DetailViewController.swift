//
//  DetailViewController.swift
//  EulerityTakeHome
//
//  Created by Nick Nguyen on 2/3/21.
//

import UIKit
import CoreImage.CIFilterBuiltins

class DetailViewController: UIViewController {

  @IBOutlet weak var detailImageView: UIImageView!

  var selectedImageURL: ImageObject? // url

  override func viewDidLoad() {
    super.viewDidLoad()
    if let selectedImage = selectedImageURL {
      detailImageView.loadImage(withUrl: selectedImage.url)
    }
  }

  @IBAction func uploadTapped(_ sender: UIBarButtonItem) {
    guard let originalURL = selectedImageURL?.url else { return }
    guard let currentImage = detailImageView.image else { return }
    NetworkService.sharedInstance.getDataFrom(endpoint:.upload,
                                              completion: { result in
      if let uploadURL = try? result.get() as? UploadURL {
        NetworkService.sharedInstance.uploadImage(to: uploadURL.url,
                                                  original: originalURL,
                                                  file: currentImage.jpegData(compressionQuality: 1.0)!)
      }
    })
  }

  @IBAction func applyFilter(_ sender: UIButton) {
    let context = CIContext(options: nil)

    guard let currentImage = detailImageView.image,
          let ciImage = CIImage(image: currentImage) else {
      return
    }
    DispatchQueue.global().async {
      let filter = CIFilter(name: "CISepiaTone")
      filter?.setValue(ciImage, forKey: kCIInputImageKey)
      filter?.setValue(1.0, forKey: kCIInputIntensityKey)
      guard let filteredImage = filter?.value(forKey: kCIOutputImageKey) as? CIImage else {
        return
      }
      guard let cgImage = context.createCGImage(filteredImage, from: filteredImage.extent) else {
        return
      }
      let outputImage = UIImage(cgImage: cgImage)
      
      DispatchQueue.main.async {
        self.detailImageView.image = outputImage
      }
    }
  }

  @IBAction func addOverlayText(_ sender: UIButton) {
    // TODO
  }
}
