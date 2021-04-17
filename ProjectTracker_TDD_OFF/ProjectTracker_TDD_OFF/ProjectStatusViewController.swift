//
//  ViewController.swift
//  ProjectTracker_TDD_OFF
//
//  Created by Ihor Savynskyi on 17.04.2021.
//

import UIKit

protocol ProjectStatusView: AnyObject {
    func setTitle(_ title: String)
    func configureProgressAllowedRange(_ range: ClosedRange<Float>)
    func setProjectProgress(_ value: Float)
    func setStatus(_ status: String, color: UIColor)
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
        presenter.viewDidLoad()
    }
}

private extension ProjectStatusViewController {
    
    @IBAction func sliderValueDidChange(_ sender: UISlider) {
        guard sender === progressSlider else { return }
        
        presenter.progressDidChange(sender.value)
    }
}

extension ProjectStatusViewController: ProjectStatusView {
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func configureProgressAllowedRange(_ range: ClosedRange<Float>) {
        progressSlider.minimumValue = range.lowerBound
        progressSlider.maximumValue = range.upperBound
    }
    
    func setProjectProgress(_ value: Float) {
        progressSlider.value = value
    }
    
    func setStatus(_ status: String, color: UIColor) {
        statusLabel.text = status
        statusLabel.textColor = color
    }
}
