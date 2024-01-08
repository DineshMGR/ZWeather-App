//
//  ZSearchWeather1VC.swift
//  ZWeather App
//
//  Created by Dinesh G on 04/01/24.
//

import UIKit

class ZSearchWeatherVC: UIViewController {

    private var searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search City or ZIP code"
        return searchBar
    }()
    
    private var buttonCancel : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()
    
    private var labelCityName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Test City"
        label.font = .systemFont(ofSize: 22)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private var imageWeather : CustomImageView = {
       let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(resource: .partlycloudyday)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var labelWeatherCondition: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Test Weather"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private var labelDate: SubtitleLabel = {
        let label = SubtitleLabel()
        label.textAlignment = .left
        label.text = "Date"
        label.textColor = .white
        return label
    }()
    
    private var labelTemperature: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "65"
        label.textColor = .white
        label.font = .systemFont(ofSize: 68, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private var labelAdditionalDetails: SemiBoldTitleLabel = {
        let label = SemiBoldTitleLabel()
        label.textAlignment = .left
        label.text = "Addtional Details"
        return label
    }()
    
    private var windView : CustomAdditionalWeatherDetailsView = {
        let view = CustomAdditionalWeatherDetailsView()
        view.iconImgView.image = UIImage(resource: .wind)
        view.iconImgView.tintColor = .darkGray
        view.labelTitle.textColor = .darkGray
        view.labelTitle.text = "WIND"
        return view
    }()
    
    private var feelsLikeView : CustomAdditionalWeatherDetailsView = {
        let view = CustomAdditionalWeatherDetailsView()
        view.iconImgView.image = UIImage(resource: .thermometer)
        view.iconImgView.tintColor = .darkGray
        view.labelTitle.textColor = .darkGray
        view.labelTitle.text = "FEELS LIKE"
        return view
    }()
    
    private var indexUvVIew : CustomAdditionalWeatherDetailsView = {
        let view = CustomAdditionalWeatherDetailsView()
        view.iconImgView.image = UIImage(systemName: "sun.max.fill")
        view.iconImgView.tintColor = .darkGray
        view.labelTitle.textColor = .darkGray
        view.labelTitle.text = "INDEX UV"
        return view
    }()

    private var pressureView : CustomAdditionalWeatherDetailsView = {
        let view = CustomAdditionalWeatherDetailsView()
        view.iconImgView.image = UIImage(resource: .pressure)
        view.iconImgView.tintColor = .darkGray
        view.labelTitle.textColor = .darkGray
        view.labelTitle.text = "PRESSURE"
        return view
    }()
    
    private var collectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ZHourlyForecastCollectionCell.self, forCellWithReuseIdentifier: ZHourlyForecastCollectionCell.identifier)
        collectionView.register(ZCollectionViewHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ZCollectionViewHeaderCell.identifier)
        
        return collectionView
    }()
    
    private var collectionViewHeight : NSLayoutConstraint = {
        let heightAnchor = NSLayoutConstraint()
        heightAnchor.constant = 150
        return heightAnchor
    }()
    
    private var labelDailyForecastTitle: SemiBoldTitleLabel = {
        let label = SemiBoldTitleLabel()
        label.textAlignment = .left
        label.text = "5-Day Forecast"
        return label
    }()
    
    private var tableView : UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(ZDailyForecastCell.self, forCellReuseIdentifier: ZDailyForecastCell.identifier)
        return tableView
    }()
    
    private var tableViewHeightConstraint : NSLayoutConstraint = {
        let heightAnchor = NSLayoutConstraint()
        heightAnchor.constant = 150
        return heightAnchor
    }()
    
    private let addDetailsBgView = UIView()
    private let collectionBgView = UIView()
    private let tableBgView = UIView()
    
    var viewModel = WeatherViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        setupCollectionViewAndTableView()
        setupUIElements()
        setupUI()
        viewModel.dataFetched = { [weak self] in
            DispatchQueue.main.async{
                self?.hideActivityIndicator()
                self?.updateUI()
            }
        }
        viewModel.updateError = { [weak self] message  in
            DispatchQueue.main.async{
                self?.hideActivityIndicator()
                showOkAlert(message: message, vc: self)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //For showing current hourly forecast data
        scrollToCurrentHourIndex()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .white
    }
    
    func setupUI(){
        // NavigationBar setup
        self.navigationController?.navigationBar.tintColor = .white
        navigationItem.backButtonTitle = ""
        
        view.backgroundColor = UIColor(resource: .bg)
        
        buttonCancel.addTarget(self, action: #selector(buttonCancelAction(_:)), for: .touchUpInside)
        viewModel.fetchLocalData(isLiveData: false)
        
        if viewModel.dailyForecastData.isEmpty{
            //first time setup
            labelTemperature.text = "- -"
            labelDate.text = ""
            labelCityName.text = ""
            labelWeatherCondition.text = ""
            changeElementVisibleState(true)
        }else{
            updateUI()
        }
        
        buttonCancel.isHidden = true
    }
    
    // hide or unhide the elements based on data availability
    func changeElementVisibleState(_ state: Bool){
        imageWeather.isHidden = state
        addDetailsBgView.isHidden = state
        collectionBgView.isHidden = state
        tableBgView.isHidden = state
    }
    
    private func setupCollectionViewAndTableView(){
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new , context: nil)
        collectionView.addObserver(self, forKeyPath: "contentSize", options: .new , context: nil)
        collectionViewHeight = collectionView.heightAnchor.constraint(equalToConstant: 200)
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 200)
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { section, _ in
            self.createSectionLayout()
        })
       
    }
    
    func updateUI(){
        changeElementVisibleState(false)
        
        //Adding attributes for city name and Location
        if let cityName = viewModel.location?.name, let countryName = viewModel.location?.country{
            let boldFont = UIFont.boldSystemFont(ofSize: labelCityName.font.pointSize)
            let attributedText = NSMutableAttributedString(string: cityName, attributes: [.font: boldFont, .foregroundColor: UIColor.white])
            attributedText.append(NSAttributedString(string: ", \(countryName)", attributes: [.font: UIFont.systemFont(ofSize: labelCityName.font.pointSize - 2), .foregroundColor: UIColor.white]))
            labelCityName.attributedText = attributedText
        }else{
            labelCityName.text = ""
        }
        
        let imageURL = "https:\(viewModel.currentData?.condition?.icon ?? "")"
        imageWeather.loadImage(url: imageURL)
        labelTemperature.text = String(Int((viewModel.currentData?.tempC ?? 0).rounded())) + "°"
        labelWeatherCondition.text = viewModel.currentData?.condition?.text ?? ""
        windView.labelValue.text = String(viewModel.currentData?.windKmph ?? 0) + " km/h"
        indexUvVIew.labelValue.text = String(viewModel.currentData?.uv ?? 0)
        feelsLikeView.labelValue.text = String(Int((viewModel.currentData?.feelsLikeC ?? 0).rounded())) + "°"
        pressureView.labelValue.text = String(viewModel.currentData?.pressureMb ?? 0) + " mbar"
        tableView.reloadData()
        collectionView.reloadData()
        let date = dateFormatting(GivenFormat: "yyyy-MM-dd", requiredFormat: "EEEE, dd MMM", SeperatingString: " ", date: viewModel.currentData?.lastUpdated ?? "")
        labelDate.text = date
        
        //For showing current hourly forecast data
        scrollToCurrentHourIndex()
        
    }
    
    func scrollToCurrentHourIndex(){
        if !viewModel.hourlyForecastData.isEmpty{
            let index = viewModel.getCurrentTimeIndex()
            let indexPathToScroll = IndexPath(item: index, section: 0)
            collectionView.layoutIfNeeded()
            collectionView.scrollToItem(at: indexPathToScroll, at:.left, animated: false)
        }
    }
    
    //Resizing the table  and collection view as per content size
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
                let newsize  = newvalue as! CGSize
                
                if object as? UITableView == tableView{
                    tableViewHeightConstraint.constant = newsize.height
                }
                
                if object as? UICollectionView == collectionView{
                    collectionViewHeight.constant = newsize.height
                }
            }
        }
    }
    
    
    private func createSectionLayout() -> NSCollectionLayoutSection{
            
        let items = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .estimated(100)))
        //items.contentInsets = .init(top: 4, leading: 8, bottom: 4, trailing: 8)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .estimated(100)), subitems: [items])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .continuous
        return section

    }

    @objc func buttonCancelAction(_ sender: Any) {
        view.endEditing(true)
        buttonCancel.isHidden = true
        searchBar.text = ""
    }
    
    
    private func setupUIElements(){
        
        let searchStackView = UIStackView(arrangedSubviews: [searchBar,buttonCancel])
        searchStackView.axis = .horizontal
        searchStackView.distribution = .fill
        searchStackView.alignment = .fill
        searchStackView.spacing = 0
        searchStackView.translatesAutoresizingMaskIntoConstraints = false
        [searchBar,buttonCancel].forEach{searchStackView.addSubview($0)}
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let scrollBgView = UIView()
        scrollBgView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(scrollBgView)
        
        let weatherStackView = UIStackView(arrangedSubviews: [imageWeather,labelTemperature])
        weatherStackView.axis = .horizontal
        weatherStackView.distribution = .fill
        weatherStackView.alignment = .fill
        weatherStackView.spacing = 10
        weatherStackView.translatesAutoresizingMaskIntoConstraints = false
        [imageWeather,labelTemperature].forEach{ weatherStackView.addSubview($0)}
        
        addDetailsBgView.backgroundColor = .white
        addDetailsBgView.cornerRadius = 10
        addDetailsBgView.dropShadow()
        addDetailsBgView.translatesAutoresizingMaskIntoConstraints = false
        
        let hStackView1 = UIStackView(arrangedSubviews: [windView,feelsLikeView])
        hStackView1.axis = .horizontal
        hStackView1.distribution = .fillEqually
        hStackView1.alignment = .fill
        hStackView1.spacing = 15
        hStackView1.translatesAutoresizingMaskIntoConstraints = false
        
        [windView,feelsLikeView].forEach{hStackView1.addSubview($0)}
        
        let hStackView2 = UIStackView(arrangedSubviews: [indexUvVIew,pressureView])
        hStackView2.axis = .horizontal
        hStackView2.distribution = .fillEqually
        hStackView2.alignment = .fill
        hStackView2.spacing = 15
        hStackView2.translatesAutoresizingMaskIntoConstraints = false
        
        [indexUvVIew,pressureView].forEach{hStackView2.addSubview($0)}
        
        [labelAdditionalDetails, hStackView1, hStackView2].forEach{addDetailsBgView.addSubview($0)}
        
        collectionBgView.backgroundColor = .white
        collectionBgView.cornerRadius = 10
        collectionBgView.translatesAutoresizingMaskIntoConstraints = false
        collectionBgView.dropShadow()
        collectionBgView.addSubview(collectionView)
        collectionView.fillSuperview(padding: .init(top: 2, left: 10, bottom: 17, right: 10))
        
        tableBgView.backgroundColor = .white
        tableBgView.cornerRadius = 10
        tableBgView.dropShadow()
        tableBgView.translatesAutoresizingMaskIntoConstraints = false
        
        let tableStackView = UIStackView(arrangedSubviews: [labelDailyForecastTitle,tableView])
        tableStackView.axis = .vertical
        tableStackView.distribution = .fill
        tableStackView.alignment = .fill
        tableStackView.spacing = 15
        tableStackView.translatesAutoresizingMaskIntoConstraints = false
        [labelDailyForecastTitle,tableView].forEach{tableStackView.addSubview($0)}
        tableBgView.addSubview(tableStackView)
        tableStackView.fillSuperview(padding: .init(top: 20, left: 15, bottom: 20, right: 15))
        
        
        [labelWeatherCondition, weatherStackView, labelDate, addDetailsBgView, collectionBgView, tableBgView ].forEach{scrollBgView.addSubview($0)}
        [searchStackView,labelCityName,scrollView].forEach{self.view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            searchStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            searchStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            
            labelCityName.topAnchor.constraint(equalTo: searchStackView.bottomAnchor, constant: 10),
            labelCityName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            labelCityName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            scrollView.topAnchor.constraint(equalTo: labelCityName.bottomAnchor, constant: 5),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            scrollBgView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollBgView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollBgView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollBgView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollBgView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollBgView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            labelDate.topAnchor.constraint(equalTo: scrollBgView.topAnchor, constant: 5),
            labelDate.leadingAnchor.constraint(equalTo: scrollBgView.leadingAnchor, constant: 16),
            labelDate.trailingAnchor.constraint(equalTo: scrollBgView.trailingAnchor, constant: -16),
            
            weatherStackView.topAnchor.constraint(equalTo: labelDate.bottomAnchor, constant: 10),
            weatherStackView.leadingAnchor.constraint(equalTo: scrollBgView.leadingAnchor, constant: 16),
            weatherStackView.trailingAnchor.constraint(lessThanOrEqualTo: scrollBgView.trailingAnchor, constant: -16),
            
            imageWeather.heightAnchor.constraint(equalToConstant: 92),
            imageWeather.widthAnchor.constraint(equalTo: imageWeather.heightAnchor),
            
            labelWeatherCondition.topAnchor.constraint(equalTo: weatherStackView.bottomAnchor, constant: 10),
            labelWeatherCondition.leadingAnchor.constraint(equalTo: scrollBgView.leadingAnchor, constant: 16),
            labelWeatherCondition.trailingAnchor.constraint(equalTo: scrollBgView.trailingAnchor, constant: -16),
            
            addDetailsBgView.topAnchor.constraint(equalTo: labelWeatherCondition.bottomAnchor, constant: 20),
            addDetailsBgView.leadingAnchor.constraint(equalTo: scrollBgView.leadingAnchor, constant: 16),
            addDetailsBgView.trailingAnchor.constraint(equalTo: scrollBgView.trailingAnchor, constant: -16),
            
            labelAdditionalDetails.topAnchor.constraint(equalTo: addDetailsBgView.topAnchor, constant: 15),
            labelAdditionalDetails.leadingAnchor.constraint(equalTo: addDetailsBgView.leadingAnchor, constant: 15),
            labelAdditionalDetails.trailingAnchor.constraint(equalTo: addDetailsBgView.trailingAnchor, constant: -15),
            
            hStackView1.topAnchor.constraint(equalTo: labelAdditionalDetails.bottomAnchor, constant: 15),
            hStackView1.leadingAnchor.constraint(equalTo: addDetailsBgView.leadingAnchor, constant: 10),
            hStackView1.trailingAnchor.constraint(equalTo: addDetailsBgView.trailingAnchor, constant: -10),
            
            hStackView2.topAnchor.constraint(equalTo: hStackView1.bottomAnchor, constant: 15),
            hStackView2.leadingAnchor.constraint(equalTo: addDetailsBgView.leadingAnchor, constant: 10),
            hStackView2.trailingAnchor.constraint(equalTo: addDetailsBgView.trailingAnchor, constant: -10),
            hStackView2.bottomAnchor.constraint(equalTo: addDetailsBgView.bottomAnchor, constant: -15),
            
            collectionBgView.topAnchor.constraint(equalTo: addDetailsBgView.bottomAnchor, constant: 20),
            collectionBgView.leadingAnchor.constraint(equalTo: scrollBgView.leadingAnchor, constant: 16),
            collectionBgView.trailingAnchor.constraint(equalTo: scrollBgView.trailingAnchor, constant: -16),
            collectionViewHeight,
            
            tableBgView.topAnchor.constraint(equalTo: collectionBgView.bottomAnchor, constant: 20),
            tableBgView.leadingAnchor.constraint(equalTo: scrollBgView.leadingAnchor, constant: 16),
            tableBgView.trailingAnchor.constraint(equalTo: scrollBgView.trailingAnchor, constant: -16),
            tableBgView.bottomAnchor.constraint(equalTo: scrollBgView.bottomAnchor, constant: -25),
            tableViewHeightConstraint
            
        ])
    }

}


//MARK: - CollectionView Data Source

extension ZSearchWeatherVC : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.hourlyForecastData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        return configureHourlyCell(indexPath)
    }
    
    func configureHourlyCell(_ indexPath : IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZHourlyForecastCollectionCell.identifier, for: indexPath) as! ZHourlyForecastCollectionCell
        let val = viewModel.hourlyForecastData[indexPath.row]
        
        let imageURL = "https:\(val.condition?.icon ?? "")"
        cell.imageWeather.loadImage(url: imageURL)
        cell.labelTime.text = dateFormatting(GivenFormat: "yyyy-MM-dd HH:mm", requiredFormat: "HH:mm", SeperatingString: nil, date: val.time ?? "")
        cell.bgView.cornerRadius = 7
        let index = viewModel.getCurrentTimeIndex()
        if indexPath.row == index{
            cell.bgView.borderColor = .white
            cell.bgView.borderWidth = 0
            cell.bgView.backgroundColor = UIColor(resource: .bgFirestClr)
            cell.bgView.dropShadow()
            cell.labelTemperature.text = "Now"
            cell.labelTemperature.textColor = .white
            cell.labelTime.textColor = .white
        }else{
            cell.labelTemperature.text = String(Int(val.tempC.rounded())) + "°"
            cell.bgView.borderColor = .systemGray5
            cell.bgView.borderWidth = 1
            cell.bgView.dropShadow(color: .white, offSet: CGSize(width: 0, height: 0), radius: 0)
            cell.bgView.backgroundColor = .white
            
            cell.labelTemperature.textColor = .black
            cell.labelTime.textColor = .darkGray
        }
        
        return cell
    }
    
    
}

//MARK: - Collection view Delegate

extension ZSearchWeatherVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ZCollectionViewHeaderCell.identifier, for: indexPath) as! ZCollectionViewHeaderCell
        
        headerView.titleLabel.text = "Hourly"
        return headerView
    }
}


//MARK: - TableView Data Source

extension ZSearchWeatherVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dailyForecastData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return confiureDailyForecastCell(indexPath)
    }
    
    
    func confiureDailyForecastCell(_ indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: ZDailyForecastCell.identifier, for: indexPath) as! ZDailyForecastCell
        let val = viewModel.dailyForecastData[indexPath.row].day
        let imageURL = "https:\(val?.condition?.icon ?? "")"
        cell.imageWeather.loadImage(url: imageURL)
        cell.lblDescription.text = val?.condition?.text ?? ""
        let date = dateFormatting(GivenFormat: "yyyy-MM-dd", requiredFormat: "EEEE, dd MMM", SeperatingString: " ", date: viewModel.dailyForecastData[indexPath.row].date ?? "")
        if indexPath.row == 0{
            cell.lblDate.text = "Today"
        }else{
            cell.lblDate.text = date
        }
        cell.lblTemperature.text = "\(Int(val?.minTempC.rounded() ?? 0))° / \(Int(val?.maxTempC.rounded() ?? 0))°"
        
        return cell
    }
    
}


//MARK: - Searchbar delegate

extension ZSearchWeatherVC: UISearchBarDelegate{
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        buttonCancel.isHidden = false
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        buttonCancel.isHidden = true
        searchBar.resignFirstResponder()
        
        guard Reachability.isConnectedToNetwork() else{
            return showOkAlert(message: "It seems you're offline. Please connect to the internet and try again.", vc: self)
        }
        showActivityIndicator()
        viewModel.fetchApiData(searchBar.text ?? "")
        searchBar.text = ""
        
    }
}
