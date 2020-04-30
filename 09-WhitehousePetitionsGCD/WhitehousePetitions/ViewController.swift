//
//  ViewController.swift
//  WhitehousePetitions
//
//  Created by Benjamin van den Hout on 07/11/2019.
//  Copyright © 2019 NGTI. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(creditsTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterTapped))

        fetchJSON()
    }

    func fetchJSON()
    {
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) { // might throw an error so use try?
                    // Ready to parse
                    self?.parse(json: data)
                    return
                }
            }
            
            self?.showError()
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()

        let dataString = String(data: json, encoding: .utf8)
        NSLog("Received data: \(dataString)")
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = jsonPetitions.results
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    func showError() {
        DispatchQueue.main.async { [weak self] in
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac, animated: true)
        }
    }

    @objc func creditsTapped() {
        let ac = UIAlertController(title: "Credits", message: "The data comes from the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @objc func filterTapped() {
        let ac = UIAlertController(title: "Filter", message: "Filter by keyword, leave empty to reset", preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Filter", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else {
                return
            }
            // need explicit self
            self?.filterList(answer)
        }
        
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

    func filterList(_ filter: String) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.filteredPetitions.removeAll()
            
            if filter.isEmpty {
                strongSelf.filteredPetitions = strongSelf.petitions
            }
            else {
                let lowerFilter = filter.lowercased()
                for petition in strongSelf.petitions {
                    if petition.title.lowercased().contains(lowerFilter) || petition.body.lowercased().contains(lowerFilter) {
                        strongSelf.filteredPetitions.append(petition)
                    }
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    
    // MARK: tableview

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count: \(filteredPetitions.count)")
        return filteredPetitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

