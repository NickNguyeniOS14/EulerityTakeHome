import UIKit

enum Endpoint: String {
  case image = "https://eulerity-hackathon.appspot.com/image"
  case upload = "https://eulerity-hackathon.appspot.com/upload"
}

class NetworkService {

  static let sharedInstance = NetworkService()

  // MARK:- GET
  
  func getDataFrom(endpoint: Endpoint,
                   completion: @escaping (Result<Codable, NetworkError>) -> Void) {

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


  func sendMultipartRequest(to urlString: String,
                            originalURLString: String?,
                            imageData: Data?) {
    var request = URLRequest(url: URL(string: urlString)!)
    request.httpMethod = "POST"
    let boundary = "Boundary-\(UUID().uuidString)"
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    guard let selectedImageString = originalURLString else { return }
    let params = ["appid": "nicknguyenios14",
                  "original": selectedImageString]
    DispatchQueue.main.async {
      guard let imageData = imageData else { return }
      request.httpBody = self.createBody(parameters: params,
                                         boundary: boundary,
                                         data: imageData,
                                         mimeType: "image/jpeg",
                                         filename: "hello.jpeg")
      URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let response = response as? HTTPURLResponse {
          print("UPLOAD STATUS CODE is \(response.statusCode)")
        }
        if let error = error {
          print(error)
        }
      }.resume()
    }
  }

  private func createBody(parameters: [String: String],
                          boundary: String,
                          data: Data,
                          mimeType: String,
                          filename: String) -> Data {

    let body = NSMutableData()

    let boundaryPrefix = "--\(boundary)\r\n"

    for (key, value) in parameters {
      body.appendString(boundaryPrefix)
      body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
      body.appendString("\(value)\r\n")
    }

    body.appendString(boundaryPrefix)
    body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
    body.appendString("Content-Type: \(mimeType)\r\n\r\n")
    body.append(data)
    body.appendString("\r\n")
    body.appendString("--".appending(boundary.appending("--")))

    return body as Data
  }
}
