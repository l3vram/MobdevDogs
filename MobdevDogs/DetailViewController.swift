//
//  DetailViewController.swift
//  MobdevDogs
//
//  Created by Marvel Alvarez Rojas on 10/10/2018.
//  Copyright © 2018 Marvel Alvarez Rojas. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
class DetailViewController: UIViewController{
    
    
    let cellid = "cell1"
    var breed: String = ""
    var images: [String] = []
    var vm = ViewModel()
    //var collect: UICollectionView!
    var collect: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collect = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collect.backgroundColor = .white
        collect.translatesAutoresizingMaskIntoConstraints = false
        collect.isScrollEnabled = true
        return collect
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDetails()
        title = breed.capitalized
    }
   
    func initDetails() {
        navigationItem.largeTitleDisplayMode = .never
        view.addSubview(collect)
        let infobutt = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(info))
        infobutt.image = UIImage(named: "info")?.af_imageAspectScaled(toFill: CGSize(width: 28, height: 28))
        self.navigationItem.rightBarButtonItem  = infobutt
        collect.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collect.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        collect.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collect.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        collect.register(CollectionViewCell.self, forCellWithReuseIdentifier: cellid)
        collect.delegate = self
        collect.dataSource = self
        var url = vm.urlDogImages
        url.append(breed)
        url.append(vm.urlEndImg)
        vm.BreedList(url: url) { imglist, error in
            if let i = imglist?.message{
                self.images = i
            }else{
                self.Alert(tittle: "Error", message: error?.localizedDescription ?? "")
            }
            DispatchQueue.main.async {
                self.collect.reloadData()
            }
        }
    }
    @objc func info(){
        var dir = "https://en.wikipedia.org/w/index.php?search="
        dir.append(breed)
        dir.append("+dog&title=Special%3ASearch&fulltext=1")
        UIApplication.shared.open(URL(string: dir)!, options: [:], completionHandler: nil)
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collect.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! CollectionViewCell
        
        if let url = URL(string: images[indexPath.row]){
            SetImage(url: url) { image, error in
                if let i = image{
                    cell.imageView.image = i
                }
            }
        }
        cell.layer.shadowOpacity = 0.3
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Heigth()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    }
}
