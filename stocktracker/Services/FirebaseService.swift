//
//  FirebaseService.swift
//  stocktracker
//
//  Created by Alex Do on 2/12/22.
//

import UIKit
import FirebaseDatabase

class FirebaseService: NSObject {
    static let sharedInstance = FirebaseService()
    let database = Database.database().reference()
    
    func listenForUserWatchlistAdd(completion: @escaping (String, String, String) -> ()) {
        database.child("testlist").observe(.childAdded, with: { snapshot in
            if snapshot.exists() {
                let stockId = snapshot.key
                let stock = snapshot.value as! [String:Any]
                let symbol = stock["symbol"] as! String
                let name = stock["name"] as! String
                print("\(snapshot.key) added")
                completion(stockId, symbol, name)
            }
        })
    }
    
    func listenForUserWatchlistDelete(completion: @escaping (String) -> ()) {
        database.child("testlist").observe(.childRemoved, with: { snapshot in
            if snapshot.exists() {
                print("\(snapshot.key) deleted")
                completion(snapshot.key)
            }
        })
    }
    
    func fetchUserWatchlist(completion: @escaping ([String:[String:String]]) -> ()) {
        database.child("testlist").observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                var userWatchlist = [String:[String:String]]()
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let watchListKey = snap.key
                    let watchlistValue = snap.value as! [String:Any]
                    
                    let symbol = watchlistValue["symbol"] as! String
                    let name = watchlistValue["name"] as! String
                    userWatchlist[watchListKey] = ["symbol": symbol, "name": name]
                }
                completion(userWatchlist)
            }
            
        })
    }
    
    func addStockToWatchlist(symbol: String, name: String, completion: @escaping (String) -> ()) {
        let watchlistValue: [String:String] = ["symbol": symbol, "name": name]
        let reference = database.child("testlist").childByAutoId()
        reference.setValue(watchlistValue)
        completion(reference.key ?? "")
    }
    
    func deleteStockFromWatchlist(stockId: String, completion: @escaping () -> Void) {
        database.child("testlist").child(stockId).removeValue()
        completion()
    }
}
