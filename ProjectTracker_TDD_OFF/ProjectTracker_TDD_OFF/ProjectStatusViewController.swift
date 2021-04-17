//
//  ViewController.swift
//  ProjectTracker_TDD_OFF
//
//  Created by Ihor Savynskyi on 17.04.2021.
//

import UIKit

protocol ProjectStatusView: AnyObject {
    func setTitle(_ title: String)
    func setProjectProgress(_ value: Float)
    func setStatus(_ status: String)
}

class ProjectStatusViewController: UIViewController {
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var progressSlider: UISlider!
    @IBOutlet private var statusLabel: UILabel!
    
    private lazy var presenter: ProjectStatusPresenter = {
        DefaultProjectStatusPresenter(view: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSlider()
        presenter.viewDidLoad()
    }
}

private extension ProjectStatusViewController {
    
    func configureSlider() {
        progressSlider.minimumValue = 0.0
        progressSlider.maximumValue = 100.0
    }
    
    @IBAction func sliderValueDidChange(_ sender: Any) {
        
    }
}

extension ProjectStatusViewController: ProjectStatusView {
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setProjectProgress(_ value: Float) {
        progressSlider.value = value
    }
    
    func setStatus(_ status: String) {
        statusLabel.text = status
    }
}
