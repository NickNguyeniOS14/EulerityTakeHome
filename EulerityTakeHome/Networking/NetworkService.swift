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

  // MARK: - POST

  func uploadImage(to urlString: String, original: String, file: Data) {
    let url = URL(string: urlString)!
    let uploadingData = UploadingData(appid: "nicknguyenios14@gmail.com", original: original, file: file)
    // generate boundary string using a unique per-app string
    let boundary = UUID().uuidString

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
    request.setValue("application/json", forHTTPHeaderField: "Accept") // the response expected to be in JSON format
    guard let jsonData = try? JSONEncoder().encode(uploadingData) else {
      print("Error: Trying to convert model to JSON data")
      return
    }
    request.httpBody = jsonData

    URLSession.shared.dataTask(with: request) { data, response, error in
      guard error == nil else {
        print("Error: error calling POST")
        print(error!)
        return
      }
      guard let data = data else {
        print("Error: Did not receive data")
        return
      }
      guard let response = response as? HTTPURLResponse,
            (200 ..< 299) ~= response.statusCode else {
        print("Error: HTTP request failed")
        return
      }
      print(response.statusCode)
      do {
        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
          print("Error: Cannot convert data to JSON object")
          return
        }
        guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
          print("Error: Cannot convert JSON object to Pretty JSON data")
          return
        }
        guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
          print("Error: Couldn't print JSON in String")
          return
        }

        print(prettyPrintedJson)
      } catch {
        print("Error: Trying to convert JSON data to string")
        return
      }
    }.resume()
  }
}
