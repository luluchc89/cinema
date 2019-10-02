//
//  MoviesCollectionViewController.swift
//  Cine
//
//  Created by Ma. de Lourdes Chaparro Candiani on 10/2/19.
//  Copyright © 2019 sgh. All rights reserved.
//

import UIKit
import FirebaseFirestore
import MobileCoreServices
import FirebaseStorage
import FirebaseUI

private let reuseIdentifier = "Cell"

class MoviesCollectionViewController: UICollectionViewController {
    
    var movies = [Movie]()
    
    var ref: DocumentReference!
    var getRef: Firestore!
    var storageReference: StorageReference!

    override func viewDidLoad() {
        super.viewDidLoad()

        getRef = Firestore.firestore()
        storageReference = Storage.storage().reference()

        // Register cell classes
        self.collectionView!.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        getMovies()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return movies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MovieCollectionViewCell
        print(movies[indexPath.row].movie_name)
        let placeHolder = UIImage(named: "Placeholder")
        
        let userImageRef = storageReference.child("/billboards").child(movies[indexPath.row].id + ".jpg")
        
        userImageRef.downloadURL { (url, error) in
            if let error = error {
                print(error.localizedDescription)
            }else{
                URLSession.shared.dataTask(with: url!) { (data, _, _) in
                    guard let data = data else{ return }
                    DispatchQueue.main.async{
                        cell.billboard.image = UIImage(data: data)
                    }
                    }.resume()
                print(String(describing: url!))
            }
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    func getMovies(){
        getRef.collection("movies").addSnapshotListener { (querySnapshot, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }else{
                self.movies = [Movie]()
                self.movies.removeAll()
                for document in querySnapshot!.documents{
                    let id = document.documentID
                    let values = document.data()
                    let name = values["movie_name"] as? String ?? "pelicula"
                    let rating = values["rating"] as? String ?? "rate"
                    let duration = values["duration"] as? Int ?? 1
                    let dummySeat = Seat(seat_number: 1, taken: false)
                    let seats = values["seats"] as? [Seat] ?? [dummySeat]
                    let movie = Movie(id: id, movie_name: name, rating: rating, duration: duration, seats: seats)
                    self.movies.append(movie)
                }
                self.collectionView.reloadData()
            }
        }
        
    }

}
