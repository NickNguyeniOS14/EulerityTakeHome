import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
  func loadImage(withUrl urlString : String) {
    let url = URL(string: urlString)
    self.image = nil
    
    // Check cached image
    if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
      self.image = cachedImage
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
          self.image = image
        }
      }
    }
    ).resume()
  }
}

