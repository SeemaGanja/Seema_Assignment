//
//  HomeViewController.swift
//  Seema_Assignment
//
//  Created on 03/03/22.
//


import UIKit
import SDWebImage



protocol HomeProtocol: class {
    func getResponseNowPlaying(response: ModelNowPlaying)
}

class HomeViewController: UIViewController, HomeProtocol {

    //=========================
    //MARK:- Outlet
    @IBOutlet weak var collNowPlaying: UICollectionView!
    @IBOutlet var searchMovie: UISearchBar!
    
    
    //=========================
    //MARK:- Class Variable
    var presenter : HomePresentationProtocol?
    var arrNowPlaying : ModelNowPlaying?
    var searchedarrNowPlaying : [Results]?
    var searchActive = false
    
    
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
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        
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
        
        //Call API
        self.presenter?.callNowPlayingApi()
       
        //Register Coll Cell
        self.collNowPlaying.register(UINib(nibName: "CellColPopular", bundle: nil), forCellWithReuseIdentifier: "CellColPopular")
        self.collNowPlaying.register(UINib(nibName: "CellColUnPopular", bundle: nil), forCellWithReuseIdentifier: "CellColUnPopular")
        
        //ToolBar For KeyBoard
        let textFieldInsideSearchBar = self.searchMovie.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.keyboardType = UIKeyboardType.default
        self.addToolBar(textField: textFieldInsideSearchBar!)
    }
    
    //=========================
    //MARK:- Protocol Method
    func getResponseNowPlaying(response: ModelNowPlaying) {
        self.arrNowPlaying = response
        self.searchedarrNowPlaying = self.arrNowPlaying?.results
        self.collNowPlaying.reloadData()
        
    }
    
}

//=========================
//MARK:- IBACtion Functions
extension HomeViewController {
    
}

//MARK: Collectionview Delegate and datasource
extension HomeViewController :UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                return  !searchActive ? self.arrNowPlaying?.results?.count ?? 0 : self.searchedarrNowPlaying?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let  objNowPlay = searchActive ?  self.searchedarrNowPlaying?[indexPath.row] : self.arrNowPlaying?.results?[indexPath.row]
        if objNowPlay?.voteAverage ?? 0.0 > 7 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellColPopular", for: indexPath) as! CellColPopular
            cell.setUI(objNowPlay :objNowPlay)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellColUnPopular", for: indexPath) as! CellColUnPopular
            cell.setUI(objNowPlay :objNowPlay)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let  objNowPlay = searchActive ?  self.searchedarrNowPlaying?[indexPath.row] : self.arrNowPlaying?.results?[indexPath.row]
        let height = (objNowPlay?.voteAverage ?? 0.0) > 7.0 ? 250 : 360
        return CGSize(width: Int(self.view.frame.width) - 50, height: height)
     
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = NowPlayDetailViewController.initializeVC()
        
        let  objNowPlay = searchActive ?  self.searchedarrNowPlaying?[indexPath.row] : self.arrNowPlaying?.results?[indexPath.row]
       
        detailVC.strMoviePoster = objNowPlay?.posterPath
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
     func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        self.arrNowPlaying?.results?.remove(at: indexPath.row)
        collNowPlaying.deleteItems(at: [indexPath])
      
      }
    
}

//MARK: UISearchBarDelegate
extension HomeViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchActive = searchText.count > 0 ? true : false
        
        self.searchedarrNowPlaying = self.arrNowPlaying?.results?.filter( {(obj) in
            return Bool((obj.originalTitle?.lowercased().contains(searchBar.text!.lowercased()))!)
        })
        collNowPlaying.reloadData()
    }
    
}

//=========================
//MARK:- UITextFieldDelegate
extension HomeViewController:UITextFieldDelegate
{
    func addToolBar(textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.backgroundColor = UIColor(red: 141/255, green: 143/255, blue: 147/255, alpha: 1)//UIColor.gray
        toolBar.tintColor = UIColor(red: 0 / 255, green: 0/255, blue: 0 / 255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        //textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    @objc func donePressed() {
        self.view.endEditing(true)
    }
}
