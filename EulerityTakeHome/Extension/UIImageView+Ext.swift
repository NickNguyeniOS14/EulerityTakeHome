import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
  func loadImageUsingCache(withUrl urlString : String) {
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.style = .large
    activityIndicator.color = .gray
    activityIndicator.hidesWhenStopped = true
    activityIndicator.frame = self.bounds
    self.addSubview(activityIndicator)

    DispatchQueue.main.async {
      activityIndicator.startAnimating()
    }
    let url = URL(string: urlString)
    self.image = nil
    
    // Check cached image
    if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
      self.image = cachedImage
      activityIndicator.stopAnimating()
      activityIndicator.removeFromSuperview()
      return 
    }
    
    // If not, download image from URL
    URLSession.shared.dataTask(with: url!, completionHandler: { data, response, error in
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
          self.image = image
        }
      }
    }
    ).resume()
  }
}
