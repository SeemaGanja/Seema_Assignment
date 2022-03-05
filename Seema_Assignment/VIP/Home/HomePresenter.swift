//
//  HomePresenter.swift
//  Seema_Assignment
//
//  Created on 03/03/22.
//


import UIKit

protocol HomePresentationProtocol {
    func callNowPlayingApi()
    func getResponseNowPlaying(response : ModelNowPlaying)
}

class HomePresenter: HomePresentationProtocol {
    
    
    // MARK: Objects & Variables
    weak var viewController: HomeProtocol?
    var interactor: HomeInteractorProtocol?
    
    //==========================================
    //MARK:- Custom Method
    
    
    //==========================================
    //MARK:- Protocol Method
    func callNowPlayingApi() {
        self.interactor?.callNowPlayingApi()
    }
    
    func getResponseNowPlaying(response: ModelNowPlaying) {
        self.viewController?.getResponseNowPlaying(response: response)
    }
    
}
