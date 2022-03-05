//
//  NowPlayDetailViewController.swift
//  Seema_Assignment
//
//  Created on 05/03/22.
//


import UIKit

protocol NowPlayDetailProtocol: class {
    
}

class NowPlayDetailViewController: UIViewController, NowPlayDetailProtocol {
    
    class func initializeVC() -> NowPlayDetailViewController {
        return Storyboard.home.instantiateViewController(withIdentifier: NowPlayDetailViewController.identifier) as! NowPlayDetailViewController
    }

    //=========================
    //MARK:- Outlet
    @IBOutlet weak var imgMoviePoster: UIImageView!
    
    //=========================
    //MARK:- Class Variable
    var presenter : NowPlayDetailPresentationProtocol?
    var strMoviePoster : String?
    
    
    //=========================
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    //=========================
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = NowPlayDetailInteractor()
        let presenter = NowPlayDetailPresenter()
        
        //View Controller will communicate with only presenter
        viewController.presenter = presenter
        //viewController.interactor = interactor
        
        //Presenter will communicate with Interector and Viewcontroller
        presenter.viewController = viewController
        presenter.interactor = interactor
        
        //Interactor will communucate with only presenter.
        interactor.presenter = presenter
    }
    
    
    //=========================
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    //=========================
    //MARK:- Custome Method
    func setupView(){
        let url = URL(string: WebURL.imgBaseURL + (strMoviePoster ?? ""))!
        DispatchQueue.main.async {
            self.imgMoviePoster.load(url: url, strName: "")
        }
        
    }
    
    //=========================
    //MARK:- Protocol Method
    
    
    //=========================
    
}
//=========================
//MARK:- Action Method
extension NowPlayDetailViewController {
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.popViewController(self)
        
    }
    
}
