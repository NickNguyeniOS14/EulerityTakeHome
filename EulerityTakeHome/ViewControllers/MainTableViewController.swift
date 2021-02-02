//
//  ViewController.swift
//  EulerityTakeHome
//
//  Created by Nick Nguyen on 2/2/21.
//

import UIKit

class MainTableViewController: UITableViewController {

//  fileprivate var tasks = [URLSessionTask]()
//
//  var images: [UIImage] = []
//
//  fileprivate func downloadImage(forItemAtIndex index: Int) {
//    let urlString = internalURLArray[index].url
//    let url = URL(string: urlString)!
//    guard tasks.firstIndex(where: { $0.originalRequest?.url == url }) == nil else {
//      // We're already downloading the image.
//      return
//    }
//    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//      // Perform UI changes only on main thread.
//      DispatchQueue.main.async {
//        if let data = data, let image = UIImage(data: data) {
//
//          // Reload cell with fade animation.
//          let indexPath = IndexPath(row: index, section: 0)
//          if self.tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
//            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
//          }
//        }
//      }
//    }
//    task.resume()
//    tasks.append(task)
//  }
//
//  fileprivate func cancelDownloadingImage(forItemAtIndex index: Int) {
//    let urlString = internalURLArray[index].url
//    let url = URL(string: urlString)
//    // Find a task with given URL, cancel it and delete from `tasks` array.
//    guard let taskIndex = tasks.index(where: { $0.originalRequest?.url == url }) else {
//      return
//    }
//    let task = tasks[taskIndex]
//    task.cancel()
//    tasks.remove(at: taskIndex)
//  }

  let networkService = NetworkService()

  var internalURLArray: [ImageObject] = []

//  let loader = ImageLoader()

  override func viewDidLoad() {
    super.viewDidLoad()
//    tableView.prefetchDataSource = self

    networkService.downloadURLSFromServer { [weak self] result in
      switch result {
        case .success(let urlArray):
          self?.internalURLArray = urlArray
          DispatchQueue.main.async {
            self?.tableView.reloadData()
          }
        case .failure(let error):
          print(error.localizedDescription)
      }
    }
  }

  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    return internalURLArray.count
  }

  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell

    let urlString = internalURLArray[indexPath.row].url
//    let imageUrl = URL(string: urlString)!
    cell.setNeedsDisplay()

    cell.cellImageView.loadImageUsingCache(withUrl: urlString)

    return cell
  }


  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}


//extension MainTableViewController: UITableViewDataSourcePrefetching {
//  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
////    indexPaths.forEach { self.downloadImage(forItemAtIndex: $0.row) }
//  }
//
//  func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
//    print("cancelPrefetchingForRowsAt \(indexPaths)")
//  }
//}
