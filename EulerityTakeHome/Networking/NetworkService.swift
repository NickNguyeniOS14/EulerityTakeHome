import UIKit

enum Endpoint: String {
  case image = "https://eulerity-hackathon.appspot.com/image"
  case upload = "https://eulerity-hackathon.appspot.com/upload"
}

class NetworkService {

  static let sharedInstance = NetworkService()

  // MARK:- GET
  
  func getDataFrom(endpoint: Endpoint, completion: @escaping (Result<Codable, NetworkError>) -> Void) {

    let url = URL(string: endpoint.rawValue)!

    let urlRequest = URLRequest(url: url)

    URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in

      guard let data = data else {
        completion(.failure(.badURL))
        return
      }

      if let error = error {
        print(error.localizedDescription)
      }
      let jsonDecoder = JSONDecoder()
      switch endpoint {
        case .image:
          do {
            let urlArray = try jsonDecoder.decode([ImageObject].self, from: data)
            completion(.success(urlArray))
          } catch {
            print(error.localizedDescription)
          }
        case .upload:
          do {
            let uploadURL = try jsonDecoder.decode(UploadURL.self, from: data)
            completion(.success(uploadURL))
          } catch {
            print(error.localizedDescription)
          }
      }
    }.resume()
  }
}
