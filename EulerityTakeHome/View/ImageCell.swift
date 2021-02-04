import UIKit

class ImageCell: UITableViewCell {

  private var imageURL: String?
  
  private func loadImageUsingCache(withUrl urlString : String) {
    self.isUserInteractionEnabled = false

    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.style = .large
    activityIndicator.color = .gray
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    
    self.addSubview(activityIndicator)
    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: cellImageView.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: cellImageView.centerYAnchor)
    ])
    let url = URL(string: urlString)!
    self.cellImageView.image = nil
    activityIndicator.startAnimating()
    // Check cached image
    if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
      activityIndicator.stopAnimating()
      activityIndicator.removeFromSuperview()
      self.cellImageView.image = cachedImage
      self.isUserInteractionEnabled = true
      return
    }

    // If not, download image from URL
    URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
      if let error = error {
        NSLog(error.localizedDescription)
        return
      }

      guard let data = data else { return }

      if let image = UIImage(data: data) {
        imageCache.setObject(image, forKey: urlString as NSString)
        DispatchQueue.main.async {
          activityIndicator.stopAnimating()
          activityIndicator.removeFromSuperview()
          if url.absoluteString == self.imageURL {
            self.cellImageView.image = image
            self.isUserInteractionEnabled = true
          }
        }
      }
    }
    ).resume()
  }

  func updateImage(with urlString: String?) {
    if let urlString = urlString {
      imageURL = urlString
      loadImageUsingCache(withUrl: urlString)
    } else {
      cellImageView.image = nil
      imageURL = nil
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    imageURL = nil
  }
  @IBOutlet weak var cellImageView: UIImageView!
}
