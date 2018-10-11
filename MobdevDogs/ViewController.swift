//
//  ViewController.swift
//  MobdevDogs
//
//  Created by Marvel Alvarez Rojas on 09/10/2018.
//  Copyright © 2018 Marvel Alvarez Rojas. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var cellid = "cell"
    var dogl: Doglist?
    var vm = ViewModel()
    var table: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView()  {
        navigationItem.title = "Breed List"
        let image = UIImageView(image: UIImage(named: "dog"))
        image.contentMode = .scaleAspectFit
        navigationItem.titleView =  image
        view.addSubview(table)
        table.delegate =  self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellid)
        table.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        table.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        vm.BreedList(url: vm.urlDogList) { doglist, error in
            if let a = doglist{
                self.dogl = a
            }else{
                self.Alert(tittle: "Error", message: error?.localizedDescription ?? "")
            }
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let names = dogl?.message{
            return names.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: cellid, for: indexPath)
        if let names = dogl?.message{
            cell.textLabel?.text = names[indexPath.row].capitalized
            cell.imageView?.image = UIImage(named: "dog2")
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        }     
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"{
            let detailC = segue.destination as! DetailViewController
            if let row =  self.table.indexPathForSelectedRow?.row{
                detailC.breed = dogl?.message[row] ?? ""
            }
        }
    }
}

