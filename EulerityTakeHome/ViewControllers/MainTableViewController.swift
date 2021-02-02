//
//  ViewController.swift
//  EulerityTakeHome
//
//  Created by Nick Nguyen on 2/2/21.
//

import UIKit

class MainTableViewController: UITableViewController {

  let networkService = NetworkService()

  var internalURLArray: [ImageObject] = [] {
    didSet {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    networkService.downloadURLSFromServer { [weak self] (result) in
      switch result {
        case .success(let urlArray):
          self?.internalURLArray = urlArray
        case .failure(let error):
          print(error)
      }
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return internalURLArray.count
  }

  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath)
    let urlString = internalURLArray[indexPath.row].urlString
    
    cell.imageView?.loadImageUsingCache(withUrl: urlString)

    return cell
  }
}


