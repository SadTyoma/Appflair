//
//  DetailViewController.swift
//  Appflair
//
//  Created by Artem Shuneyko on 5.07.23.
//

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
    private let car: Car
    
    init(car: Car) {
        self.car = car
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    var imageViews: [UIImageView] = []
    
    var scrollView = UIScrollView()
        
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(scrollView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(descriptionLabel)
        
        for image in car.images {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.imageFromURL(image)
            imageViews.append(imageView)
            scrollView.addSubview(imageView)
        }
        
        titleLabel.text = "\(car.brand) \(car.model)"
        descriptionLabel.text = car.description

        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.bottom.left.right.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
        }
        
        for i in 0..<imageViews.count {
            let imageView = imageViews[i]
            let previousView = i > 0 ? imageViews[i - 1] : descriptionLabel
            
            imageView.snp.makeConstraints { make in
                make.top.equalTo(previousView.snp.bottom).offset(10)
                make.width.equalToSuperview().multipliedBy(0.9)
                make.height.equalTo(200)
                make.centerX.equalToSuperview()
                
                if i == imageViews.count - 1 {
                    make.bottom.equalToSuperview()
                }
            }
        }
    }
}


