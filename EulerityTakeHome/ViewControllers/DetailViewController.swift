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

  var selectedImageURL: ImageObject? // urlString

  override func viewDidLoad() {
    super.viewDidLoad()
    if let selectedImage = selectedImageURL {
      detailImageView.loadImage(withUrl: selectedImage.url)
    }
  }

  @IBAction func uploadTapped(_ sender: UIBarButtonItem) {
    NetworkService.sharedInstance.getDataFrom(endpoint: .upload) { (result) in
      if let uploadURL = try? result.get() as? UploadURL {
        DispatchQueue.main.async {
          if let imageData = self.detailImageView.image?.jpegData(compressionQuality: 0.8),
             let originalURL = self.selectedImageURL?.url {
            NetworkService.sharedInstance.sendMultipartRequest(to: uploadURL.url, originalURLString: originalURL, imageData: imageData)
          }
        }
      }
    }
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
  @IBAction func addOverlayText(_ sender: UIButton) { showAlertTextField() }
  private func textToImage(drawText text: String, inImage image: UIImage) -> UIImage {
    UIGraphicsBeginImageContext(image.size)
    defer { UIGraphicsEndImageContext() }
    image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
    let font = UIFont(name: "Avenir Next", size: 400)!
    let textStyle = NSMutableParagraphStyle()
    textStyle.alignment = NSTextAlignment.center
    let textColor = UIColor.white
    let attributes = [NSAttributedString.Key.font:font,
                      NSAttributedString.Key.paragraphStyle:textStyle, NSAttributedString.Key.foregroundColor:textColor]
    let textHeight = font.lineHeight
    let textY = (image.size.height - textHeight ) / 2
    let textRect = CGRect(x: 0, y: textY, width: image.size.width, height: textHeight)
    text.draw(in: textRect.integral, withAttributes: attributes)
    let result = UIGraphicsGetImageFromCurrentImageContext()!
    return result
  }
  private func showAlertTextField() {
    let alert = UIAlertController(title: "Add overlay text",
                                  message: "Add text to the image",
                                  preferredStyle: .alert)

    alert.addTextField {
      (textField) in textField.placeholder = "Enter text"
    }
    alert.addAction(UIAlertAction(title: "Confirm",
                                  style: .default,
                                  handler: { action in
                                    if let textField = alert.textFields?[0].text {
                                      if let targetImage = self.detailImageView.image {
                                        self.detailImageView.image = self.textToImage(drawText: textField,
                                                                                      inImage: targetImage)
                                      }}}))
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
}
