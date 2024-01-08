//
//  ZWeatherHome1VC.swift
//  ZWeather App
//
//  Created by Dinesh G on 29/12/23.
//

import UIKit
import CoreLocation

class ZWeatherHomeVC: UIViewController {

    private var labelCityName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Test City"
        label.font = .systemFont(ofSize: 22)
        label.numberOfLines = 0
        return label
    }()
    
    private var weatherView: CustomGradiantView = {
        let view = CustomGradiantView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startColor = UIColor(resource: .bgFirestClr)
        view.endColor = UIColor(resource: .bgSecondClr)
        view.dropShadow()
        view.cornerRadius = 15
        return view
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
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private var labelDate: SubtitleLabel = {
        let label = SubtitleLabel()
        label.textColor = .systemGray3
        label.textAlignment = .center
        label.text = "Date"
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
    
    private var windView : CustomAdditionalWeatherDetailsView = {
        let view = CustomAdditionalWeatherDetailsView()
        view.iconImgView.image = UIImage(resource: .wind)
        view.iconImgView.tintColor = .white
        view.labelValue.textColor = .white
        view.labelTitle.text = "WIND"
        return view
    }()
    
    private var feelsLikeView : CustomAdditionalWeatherDetailsView = {
        let view = CustomAdditionalWeatherDetailsView()
        view.iconImgView.image = UIImage(resource: .thermometer)
        view.iconImgView.tintColor = .white
        view.labelValue.textColor = .white
        view.labelTitle.text = "FEELS LIKE"
        return view
    }()
    
    private var indexUvVIew : CustomAdditionalWeatherDetailsView = {
        let view = CustomAdditionalWeatherDetailsView()
        view.iconImgView.image = UIImage(systemName: "sun.max.fill")
        view.iconImgView.tintColor = .white
        view.labelValue.textColor = .white
        view.labelTitle.text = "INDEX UV"
        return view
    }()

    private var pressureView : CustomAdditionalWeatherDetailsView = {
        let view = CustomAdditionalWeatherDetailsView()
        view.iconImgView.image = UIImage(resource: .pressure)
        view.iconImgView.tintColor = .white
        view.labelValue.textColor = .white
        view.labelTitle.text = "PRESSURE"
        return view
    }()
    
    private var collectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ZDailyForecastCollectionCell.self, forCellWithReuseIdentifier: ZDailyForecastCollectionCell.identifier)
        collectionView.register(ZHourlyForecastCollectionCell.self, forCellWithReuseIdentifier: ZHourlyForecastCollectionCell.identifier)
        collectionView.register(ZCollectionViewHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ZCollectionViewHeaderCell.identifier)
        return collectionView
    }()
    
    private var collectionViewHeight : NSLayoutConstraint = {
        let heighAnchor = NSLayoutConstraint()
        heighAnchor.constant = 150
        return heighAnchor
    }()
    
    private var buttonSearchOtherLocation : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Search Other Locations", for: .normal)
        button.setTitleColor(UIColor(resource: .bgFirestClr), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.tintColor = .black
        return button
    }()
    
    var viewModel = WeatherViewModel()
    let locationManager = CLLocationManager()
    private var hourlyForecastTitle = "Hourly"
    private var dailyForecastTitle = "5-Day Forecast"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewHeight = collectionView.heightAnchor.constraint(equalToConstant: 200)
        collectionView.addObserver(self, forKeyPath: "contentSize", options: .new , context: nil)
        setupCollectionView()
        setupUIElements()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
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
        self.navigationController?.navigationBar.tintColor = .black
        //For showing current hourly forecast data
        scrollToCurrentHourIndex()
    }
    
    
    func setupUI(){
        // NavigationBar setup
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "location.circle.fill"), style: .plain, target: self, action: #selector(locationButtonAction))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonAction))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = .white
        
        buttonSearchOtherLocation.addTarget(self, action: #selector(buttonSearchOtherLocationAction(_:)), for: .touchUpInside)
        
        viewModel.fetchLocalData()
        if viewModel.dailyForecastData.isEmpty{
            //intial app launch setup
            labelTemperature.text = "- -"
            labelDate.text = ""
            labelCityName.text = ""
            labelWeatherCondition.text = ""
            changeElementVisibleState(true)
            
        }else{
            updateUI()
        }
        
    }
    
    // hide or unhide the elements based on data availability
    func changeElementVisibleState(_ state: Bool){
        imageWeather.isHidden = state
        windView.isHidden = state
        feelsLikeView.isHidden = state
        indexUvVIew.isHidden = state
        pressureView.isHidden = state
        buttonSearchOtherLocation.isHidden = state
        hourlyForecastTitle = state ? "" : "Hourly"
        dailyForecastTitle  = state ? "" : "5-Day Forecast"
    }

    @objc private func locationButtonAction(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @objc private func searchButtonAction(){
        pushToSearchVC()
    }
    
    func updateUI(){
        changeElementVisibleState(false)
        
        //Adding attributes for city name and Location
        if let cityName = viewModel.location?.name, let countryName = viewModel.location?.country{
            let boldFont = UIFont.boldSystemFont(ofSize: labelCityName.font.pointSize)
            let attributedText = NSMutableAttributedString(string: cityName, attributes: [.font: boldFont, .foregroundColor: UIColor.black])
            attributedText.append(NSAttributedString(string: ", \(countryName)", attributes: [.font: UIFont.systemFont(ofSize: labelCityName.font.pointSize - 2), .foregroundColor: UIColor.darkGray]))
            labelCityName.attributedText = attributedText
        }else{
            labelCityName.text = "Unknown"
        }
        
        let imageURL = "https:\(viewModel.currentData?.condition?.icon ?? "")"
        imageWeather.loadImage(url: imageURL)
        labelTemperature.text = String(Int((viewModel.currentData?.tempC ?? 0).rounded())) + "°"
        labelWeatherCondition.text = viewModel.currentData?.condition?.text ?? ""
        windView.labelValue.text = String(viewModel.currentData?.windKmph ?? 0) + " km/h"
        indexUvVIew.labelValue.text = String(viewModel.currentData?.uv ?? 0)
        feelsLikeView.labelValue.text = String(Int((viewModel.currentData?.feelsLikeC ?? 0).rounded())) + "°"
        pressureView.labelValue.text = String(viewModel.currentData?.pressureMb ?? 0) + " mbar"
        collectionView.reloadData()
        let date = dateFormatting(GivenFormat: "yyyy-MM-dd", requiredFormat: "EEEE, dd MMM", SeperatingString: " ", date: viewModel.currentData?.lastUpdated ?? "")
        labelDate.text = date
        
        //For showing current hourly forecast data
        scrollToCurrentHourIndex()
        
        
    }
    
    private func scrollToCurrentHourIndex(){
        if !viewModel.hourlyForecastData.isEmpty{
            let index = viewModel.getCurrentTimeIndex()
            let indexPathToScroll = IndexPath(item: index, section: 0)
            collectionView.layoutIfNeeded()
            collectionView.scrollToItem(at: indexPathToScroll, at:.left, animated: false)
        }
    }
    
    //Resizing the collection View as per content size
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
                let newsize  = newvalue as! CGSize
                
                if object as? UICollectionView == collectionView{
                    collectionViewHeight.constant = newsize.height
                }
            }
        }
    }

    private func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { section, _ in
            self.createSectionLayout(section: section)
        })
    }
    
    
    private func setupUIElements(){
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let view1 = UIView()
        view1.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(view1)
        
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
        
        [imageWeather, labelWeatherCondition, labelDate, labelTemperature,hStackView1,hStackView2].forEach{weatherView.addSubview($0)}
        [weatherView,collectionView, buttonSearchOtherLocation].forEach{view1.addSubview($0)}

        [labelCityName,scrollView].forEach{self.view.addSubview($0)}
        
        NSLayoutConstraint.activate([
            labelCityName.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            labelCityName.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            labelCityName.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            scrollView.topAnchor.constraint(equalTo: labelCityName.bottomAnchor, constant: 15),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            view1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            view1.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            view1.topAnchor.constraint(equalTo: scrollView.topAnchor),
            view1.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            view1.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            view1.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            weatherView.topAnchor.constraint(equalTo: view1.topAnchor, constant: 15),
            weatherView.leadingAnchor.constraint(equalTo: view1.leadingAnchor, constant: 20),
            weatherView.trailingAnchor.constraint(equalTo: view1.trailingAnchor, constant: -20),
            
            imageWeather.topAnchor.constraint(equalTo: weatherView.topAnchor, constant: 20),
            imageWeather.heightAnchor.constraint(equalToConstant: 100),
            imageWeather.widthAnchor.constraint(equalTo: imageWeather.heightAnchor),
            imageWeather.centerXAnchor.constraint(equalTo: weatherView.centerXAnchor),
            
            labelWeatherCondition.topAnchor.constraint(equalTo: imageWeather.bottomAnchor, constant: 12),
            labelWeatherCondition.leadingAnchor.constraint(equalTo: weatherView.leadingAnchor, constant: 10),
            labelWeatherCondition.trailingAnchor.constraint(equalTo: weatherView.trailingAnchor, constant: -10),
            
            labelDate.topAnchor.constraint(equalTo: labelWeatherCondition.bottomAnchor, constant: 8),
            labelDate.leadingAnchor.constraint(equalTo: weatherView.leadingAnchor, constant: 10),
            labelDate.trailingAnchor.constraint(equalTo: weatherView.trailingAnchor, constant: -10),
            
            labelTemperature.topAnchor.constraint(equalTo: labelDate.bottomAnchor, constant: 15),
            labelTemperature.leadingAnchor.constraint(equalTo: weatherView.leadingAnchor, constant: 10),
            labelTemperature.trailingAnchor.constraint(equalTo: weatherView.trailingAnchor, constant: -10),
            
            hStackView1.topAnchor.constraint(equalTo: labelTemperature.bottomAnchor, constant: 15),
            hStackView1.leadingAnchor.constraint(equalTo: weatherView.leadingAnchor, constant: 10),
            hStackView1.trailingAnchor.constraint(equalTo: weatherView.trailingAnchor, constant: -10),
            
            hStackView2.topAnchor.constraint(equalTo: hStackView1.bottomAnchor, constant: 20),
            hStackView2.leadingAnchor.constraint(equalTo: weatherView.leadingAnchor, constant: 10),
            hStackView2.trailingAnchor.constraint(equalTo: weatherView.trailingAnchor, constant: -10),
            hStackView2.bottomAnchor.constraint(equalTo: weatherView.bottomAnchor, constant: -20),
            
            collectionView.topAnchor.constraint(equalTo: weatherView.bottomAnchor, constant: 15),
            collectionView.leadingAnchor.constraint(equalTo: view1.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view1.trailingAnchor, constant: -16),
            collectionViewHeight,
            
            buttonSearchOtherLocation.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 25),
            buttonSearchOtherLocation.bottomAnchor.constraint(equalTo: view1.bottomAnchor, constant: -25),
            buttonSearchOtherLocation.centerXAnchor.constraint(equalTo: view1.centerXAnchor)
            
        ])
    }
    
    //Creating layout for different sections in collection view
    private func createSectionLayout(section : Int) -> NSCollectionLayoutSection{
        switch section{
        case 0:
            let items = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .estimated(100)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(100), heightDimension: .estimated(100)), subitems: [items])
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [header]
            section.orthogonalScrollingBehavior = .continuous //For horizontal scrolling
            return section
    
        default:
            let items = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100)), subitems: [items])
            group.contentInsets = .init(top: 4, leading: 0, bottom: 4, trailing: 0)
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [header]
            return section
        }
    }
    
    @objc private func buttonSearchOtherLocationAction(_ sender: UIButton) {
        pushToSearchVC()
    }
    
    private func pushToSearchVC(){
        let vc = ZSearchWeatherVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - CLLocationManagerDelegate

extension ZWeatherHomeVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            let time = dateFormatting(GivenFormat: "yyyy-MM-dd HH:mm", requiredFormat: "MMM dd, HH:mm", SeperatingString: nil, date: viewModel.currentData?.lastUpdated ?? "")
            guard Reachability.isConnectedToNetwork() else{
                return showOkAlert(message: "It seems you're offline. Please connect to the internet and try again. \n Last updated: \(time)", vc: self)
            }
            showActivityIndicator()
            viewModel.fetchApiData(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


//MARK: - CollectionView Data Source

extension ZWeatherHomeVC : UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return viewModel.hourlyForecastData.count
        }else{
            return viewModel.dailyForecastData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0{
            return configureHourlyCell(indexPath)
        }else{
            return confiureDailyForecastCell(indexPath)
        }
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
            cell.bgView.backgroundColor = UIColor(resource: .bgSecondClr)
            cell.bgView.dropShadow()
            cell.labelTemperature.text = "Now"
            cell.labelTemperature.textColor = .white
            cell.labelTime.textColor = .white
        }else{
            cell.labelTemperature.text = String(Int(val.tempC.rounded())) + "°"
            cell.bgView.borderColor = .systemGray5
            cell.bgView.borderWidth = 1
            cell.bgView.backgroundColor = .white
            cell.bgView.dropShadow(color: .white, offSet: CGSize(width: 0, height: 0), radius: 0)
            cell.labelTemperature.textColor = .black
            cell.labelTime.textColor = .darkGray
        }
        
        return cell
    }
    
    func confiureDailyForecastCell(_ indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZDailyForecastCollectionCell.identifier, for: indexPath) as! ZDailyForecastCollectionCell
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


extension ZWeatherHomeVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
         let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ZCollectionViewHeaderCell.identifier, for: indexPath) as! ZCollectionViewHeaderCell
        if indexPath.section == 0{
            headerView.titleLabel.text = hourlyForecastTitle
        }else {
            headerView.titleLabel.text = dailyForecastTitle
        }
        return headerView
    }
}
