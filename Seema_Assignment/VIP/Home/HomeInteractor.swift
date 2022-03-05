//
//  HomeInteractor.swift
//  Seema_Assignment
//
//  Created on 03/03/22.
//

import UIKit

protocol HomeInteractorProtocol {
    func callNowPlayingApi()
}

protocol HomeDataStore {
    //{ get set }
}

class HomeInteractor: HomeInteractorProtocol, HomeDataStore {
    
    // MARK: Objects & Variables
    var presenter: HomePresentationProtocol?
    
    //==========================================
    //MARK:- Custom Method
    
    
    //==========================================
    //MARK:- Protocol Method
    func callNowPlayingApi(){
        WebService.call.withPath("https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed") { (json, error) in
            
            print(json)
            
            do {
                let decoder = JSONDecoder()
              //  decoder.keyDecodingStrategy = .convertFromSnakeCase
                let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
                let objModelNowPlayingData = try? decoder.decode(ModelNowPlaying.self, from: jsonData)
                if objModelNowPlayingData != nil {
                    self.presenter?.getResponseNowPlaying(response : objModelNowPlayingData!)
                }
                
            } catch let myJSONError {
                print(myJSONError)
            }
          
        }
    }
}
