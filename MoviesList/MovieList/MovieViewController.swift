//
//  MovieViewController.swift
//  MoviesList
//
//  Created by Ketan Aggarwal on 16/11/23.



import UIKit
import SDWebImage
import SideMenu
import GoogleSignIn
import SafariServices
import WebKit
import FirebaseAuth



protocol MovieDisplayLogic: AnyObject {
    func displayMovies(viewModel: MovieListViewModels.MovieListViewModel)
    func displayConfiguration(viewModel: MovieListViewModels.ImageConfigurationViewModel)
}

class MovieViewController: UIViewController , MovieDisplayLogic, UITableViewDelegate, UITableViewDataSource, MovieListDataPassing, MenuControllerDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    var sideMenu: SideMenuNavigationController?
    private let infoController = InfoViewController()
    private let signoutController = SignOutViewController()
    private let likedController = LikedMoviesViewController()
    var dataStore: MovieListDataStore?
    
    var isTableView: Bool = true
    var currentScrollPosition: CGFloat = 0.0
    
    @IBOutlet weak var myCollection: UICollectionView!
    @IBOutlet weak var myTable: UITableView!
    
    public var apiKey: String = "e3d053e3f62984a4fa5d23b83eea3ce6"
    public var currentPage = 1
    var movies:[Movie]?
    var configuration : ImageConfiguration?
    var interactor: MovieListInteractor?
    var router: MovieListRouter?
    
    
    let button = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        setupTable()
        setup()
        setupCollectionView()
        loadScrollPosition()
        popularMoviesSelected()
        fetchConfiguration(apiKey: apiKey)
        configureBarBtn()
        addChildControllers()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleThemeChange), name: ThemeManager.themeChangedNotification, object: nil)
        
        self.view.tintColor = isDarkMode ? .black : .white
        self.navigationItem.setHidesBackButton(true, animated: false)
        let menu = MenuController(with: SideMenuItems.allCases)
        menu.delegate = self
        sideMenu = SideMenuNavigationController(rootViewController: menu)
        sideMenu?.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveScrollPosition), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        updateTheme()
        ( UIApplication.shared.delegate as? AppDelegate)?.navigationAppearance(themeColor: isDarkMode ? .white : .black)
        debugPrint("traitcollection called")
        configureBarBtn()
    }
    
    
    
    @objc private func handleThemeChange() {
        // Update UI elements based on the new theme
        updateTheme()
    }
    
    
    
    
    private func addChildControllers(){
        addChild(infoController)
        addChild(signoutController)
        addChild(likedController)
        
        view.addSubview(infoController.view)
        view.addSubview(signoutController.view)
        view.addSubview(likedController.view)
        
        infoController.view.frame = view.bounds
        signoutController.view.frame = view.bounds
        likedController.view.frame = view.bounds
        
        infoController.didMove(toParent: self)
        signoutController.didMove(toParent: self)
        likedController.didMove(toParent: self)
        
        infoController.view.isHidden = true
        signoutController.view.isHidden = true
        likedController.view.isHidden = true
    }
    
    
    private func setup() {
        let viewController = self
        let presenter = MoviePresenter()
        let interactor = MovieListInteractor(presenter: presenter)
        let worker = MovieListWorker()
        let router = MovieListRouter(viewController: viewController)
        router.dataStore = interactor
        viewController.interactor = interactor
        interactor.worker = worker
        interactor.presenter = presenter
        presenter.viewController = viewController
        viewController.router = router
    }
    
    func setupTable(){
        myTable.delegate = self
        myTable.dataSource = self
        
    }
    
    func setupCollectionView(){
        myCollection.dataSource = self
        myCollection.delegate = self
        myCollection.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Save the current scroll position when scrolling
        currentScrollPosition = scrollView.contentOffset.y
        guard let moviesCount = movies?.count, moviesCount > 0 else {
            return
        }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - screenHeight {
            loadMoreMovies()
        }
    }
    func loadScrollPosition() {
        // Load the last saved scroll position
        if let savedScrollPosition = UserDefaults.standard.value(forKey: "lastScrollPosition") as? CGFloat {
            currentScrollPosition = savedScrollPosition
        }
    }
    @objc func saveScrollPosition() {
        UserDefaults.standard.set(currentScrollPosition, forKey: "lastScrollPosition")
    }
    
    
    func configureBarBtn() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain ,target: self, action: #selector(yourAction))
        navigationItem.leftBarButtonItem?.tintColor = isDarkMode ? .white : .black
        
        let switchButton = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2"), style: .plain, target: self, action: #selector(switchView))
        navigationItem.rightBarButtonItem = switchButton
        navigationItem.rightBarButtonItem?.tintColor = isDarkMode ? .white : .black
        updateTheme()
        updateRightBarButton()
    }
    
    @objc func switchView(){
        
        isTableView = !isTableView
        if isTableView {
            updateRightBarButton()
            myTable.isHidden = false
            myCollection.isHidden = true
            myTable.reloadData()
        } else {
            updateRightBarButton()
            myTable.isHidden = true
            myCollection.isHidden = false
            myCollection.reloadData()
            
            DispatchQueue.main.async { [weak self] in
                // Restore the scroll position for collection view
                self?.myCollection.collectionViewLayout.invalidateLayout()
                self?.myCollection.contentOffset.y = self?.currentScrollPosition ?? 0
            }
        }
        updateTheme()
    }
    
    
    func updateRightBarButton(){
        let image: UIImage
        let action: Selector
        updateTheme()
        if isTableView {
            image = UIImage(systemName: "square.grid.2x2")!
            action = #selector(switchView)
        } else {
            image = UIImage(systemName: "list.dash")!
            action = #selector(switchView)
        }
        
        let switchButton = UIBarButtonItem(image: image, style: .plain, target: self, action: action)
        navigationItem.rightBarButtonItem = switchButton
        if(isDarkMode){
            navigationItem.rightBarButtonItem?.tintColor = .white
        }else{
            navigationItem.rightBarButtonItem?.tintColor = .black
        }
    }
    
    
    
    @objc func yourAction(_ sender: UIButton){
        present(sideMenu!, animated: true)
    }
    
    
    
    
    
    @objc func popularMoviesSelected() {
        ActivityIndicatorManager.shared.showActivityIndicator()
        currentPage = 1
        navigationItem.title = "Popular Movies"
        let popuralUrl = "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&page=\(currentPage)"
        fetchMovies(apiKey: apiKey,url: popuralUrl)
        ActivityIndicatorManager.shared.hideActivityIndicator()
        print("Popular Movies selected")
        
        
    }
    
    @objc func upcomingMoviesSelected() {
        currentPage = 1
        navigationItem.title = "Upcoming Movies"
        let upcomingUrl = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)&page=\(currentPage)"
        fetchMovies(apiKey: apiKey,url: upcomingUrl)
        
        
    }
    
    
    func loadMoreMovies() {
        
        currentPage += 1
        
        
        let url: String
        
        if navigationItem.title == "Popular Movies" {
            url = "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&page=\(currentPage)"
            
        } else {
            url = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)&page=\(currentPage)"
        }
        
        fetchMovies(apiKey: apiKey, url: url)
        updateTheme()
    }
    
    func fetchMovies(apiKey: String,url:String){
        interactor!.fetchMovies(request: MovieListModels.FetchMovies.Request(apiKey: apiKey, page: 1),url: url)
    }
    
    func fetchConfiguration(apiKey: String){
        interactor!.fetchConfiguration(request: MovieListModels.FetchImageConfiguration.Request(apiKey: apiKey))
    }
    
    
    func displayMovies(viewModel: MovieListViewModels.MovieListViewModel) {
        DispatchQueue.main.async {
            if self.currentPage == 1 {
                // Replace the existing movies array with the new movies
                self.movies = viewModel.movies
                
            } else {
                // Append the new movies to the existing array
                self.movies?.append(contentsOf: viewModel.movies)
            }
            
            print("Movies count after update: \(self.movies?.count ?? 0)")
            self.myTable.reloadData()
            self.myCollection.reloadData()
        }
    }
    
    func displayConfiguration(viewModel: MovieListViewModels.ImageConfigurationViewModel) {
        configuration = viewModel.imageConfig
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.updateTheme(isDarkMode ? .dark : .light)
        let movie = movies![indexPath.row]
        cell.selectionStyle = .none
        cell.title?.text = movie.title ?? "hello"
        cell.desc?.text = movie.overview
        cell.rating?.text = String(movie.vote_average!)
        cell.selectionStyle = .none
        tableView.separatorStyle = .none
        
        if let url = interactor?.getUrlFor(posterPath: movie.poster_path) {
            cell.img.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"))
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225 // Adjust the height as needed
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedMovie = movies?[indexPath.row] {
            passMovieData(selectedMovie)
            
        }
        
    }
    
    func passMovieData(_ movie: Movie) {
        router?.navigateToMovieDetail(movie: movie)
    }
    
    private func updateTheme(){
        let theme = isDarkMode
        
        // Update navigation bar color
        let themeColor: UIColor = (!theme) ? .white : .black
        navigationController?.navigationBar.barTintColor = themeColor
        let oppositeColor: UIColor = themeColor.isLight ? .black : .white
        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: oppositeColor
        ]
        navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        //navigationItem.leftBarButtonItem?.tintColor = oppositeColor
        
        // Update right bar button item color
        if let switchButton = navigationItem.rightBarButtonItem {
            switchButton.tintColor = oppositeColor
        }
        view.backgroundColor = themeColor
        myTable.backgroundColor = themeColor
        myCollection.backgroundColor = themeColor
        
        myTable.reloadData()
        myCollection.reloadData()
        
    }
    
    func didSelectMenuItem(named: SideMenuItems) {
        sideMenu?.dismiss(animated: true, completion: { [weak self] in
            switch named {
            case .popularMovies:
                self?.popularMoviesSelected()
                self?.navigationController?.isNavigationBarHidden = false
                self?.hideChildControllers()
            case .info:
                self?.navigationController?.isNavigationBarHidden = false
                self?.navigationItem.title = ""
                self?.showChildController(controller: self!.infoController)
            case .likedMovies:
                print("Liked Movies")
                self?.navigationController?.isNavigationBarHidden = false
                self?.navigationItem.title = "Liked Movies"
                self?.showChildController(controller: self!.likedController)
            case .signout:
                self?.performSignOut()
            case .upcomingMovies:
                self?.upcomingMoviesSelected()
                self?.navigationController?.isNavigationBarHidden = false
                self?.hideChildControllers()
               
                          }
            
            self?.updateTheme()
        })
    }
    
    
    private func hideChildControllers() {
        infoController.view.isHidden = true
        signoutController.view.isHidden = true
        likedController.view.isHidden = true
        
    }
    
    private func showChildController(controller: UIViewController) {
        hideChildControllers()
        controller.view.isHidden = false
    }
    
    func performSignOut(){
        
        UserDefaults.standard.set(false, forKey: "isUserSignedIn")
        UserDefaults.standard.set(false, forKey: "isUserloggedIn")
        UserDefaults.standard.set(nil, forKey: "userName")
        UserDefaults.standard.set(nil, forKey: "userProfileImageURL")
        do{
            try Auth.auth().signOut()
        }catch{
            print("Error while signing out!")
        }
        GIDSignIn.sharedInstance.signOut()
        SceneDelegate.shared?.handleRootVC()
       
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.updateTheme(isDarkMode ? .dark : .light)
        let movie = movies![indexPath.item]
        if let url = interactor?.getUrlFor(posterPath: movie.poster_path) {
            cell.hiImg.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height - 30)
            cell.hiImg.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage"))
        }
        cell.hiTitle.text = movie.title ?? "ketan"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedMovie = movies?[indexPath.row] {
            passMovieData(selectedMovie)
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItem = collectionView.numberOfItems(inSection: 0) - 1
        if indexPath.item == lastItem {
            print("Will display last item, load more movies")
            loadMoreMovies()
            myCollection.reloadData()
            saveScrollPosition()
        }
    }
    
}

extension MovieViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 5
        let collectionViewWidth = collectionView.bounds.width
        let cellWidth = (collectionViewWidth - 6 * padding) / 3 // Adjusted padding for 3 tiles
        
        let aspectRatio: CGFloat = 16.0 / 9.0
        //        let cellHeight = cellWidth / aspectRatio
        //let cellHeight = cellWidth * (16.0 / 9.0) + 60
        return CGSize(width: cellWidth, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}


extension UIColor {
    var isLight: Bool {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let brightness = (red * 299 + green * 587 + blue * 114) / 1000
        return brightness > 0.5
    }
}

