//
//  CommonLabels.swift
//  ZWeather App
//
//  Created by Dinesh G on 04/01/24.
//

import UIKit

class HeaderLabel: UILabel{
    private func setupHeaderLabel() {
        textColor = .black
        font = .systemFont(ofSize: 18, weight: .semibold)
        numberOfLines = 0
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeaderLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupHeaderLabel()
    }
}

class TitleLabel: UILabel{
    private func setupHeaderLabel() {
        textColor = .black
        font = .systemFont(ofSize: 15, weight: .regular)
        numberOfLines = 0
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeaderLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupHeaderLabel()
    }
}

class SemiBoldTitleLabel: UILabel{
    private func setupHeaderLabel() {
        textColor = .black
        font = .systemFont(ofSize: 15, weight: .semibold)
        numberOfLines = 0
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeaderLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupHeaderLabel()
    }
}

class SubtitleLabel: UILabel{
    private func setupHeaderLabel() {
        textColor = .black
        font = .systemFont(ofSize: 13, weight: .regular)
        numberOfLines = 0
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeaderLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupHeaderLabel()
    }
}

class SubtitleLabel1: UILabel{
    private func setupHeaderLabel() {
        textColor = .darkGray
        font = .systemFont(ofSize: 10, weight: .regular)
        numberOfLines = 0
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeaderLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupHeaderLabel()
    }
}

