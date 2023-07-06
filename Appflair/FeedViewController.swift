//
//  ViewController.swift
//  Appflair
//
//  Created by Artem Shuneyko on 5.07.23.
//

import UIKit
import SnapKit

class FeedViewController: UIViewController {
    
    private let tableView = UITableView()
    private var cars = [Car]()
    private let cellReuseIdentifier = "CarCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        loadData()
    }
    
    private func loadData() {
        let url = URL(string: "https://xenr-r2up-tben.n7c.xano.io/api:6mbbF8N6/car")!
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                print("Error: \(error.localizedDescription)")
                loadSavedData()
                return
            }
            guard let data = data else { return }
            do {
                let cars = try JSONDecoder().decode([Car].self, from: data)
                self.cars = cars
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                DataManager.shared.saveCars(cars)
            } catch {
                loadSavedData()
                return
            }
        }
        task.resume()
    }
    
    private func loadSavedData(){
        if let cachedCars = DataManager.shared.fetchCars() {
            cars = cachedCars
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        let car = cars[indexPath.row]
        cell.textLabel?.text = "\(car.brand) \(car.model)"
        return cell
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let car = cars[indexPath.row]
        let detailVC = DetailViewController(car: car)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
