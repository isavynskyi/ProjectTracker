//
//  ViewController.swift
//  ProjectTracker_TDD_ON
//
//  Created by Ihor Savynskyi on 17.04.2021.
//

import UIKit

protocol ProjectProgressView: AnyObject {
    func updateTitle(_ title: String)
    func updateSlider(_ value: Float)
    func updateStatus(_ status: String, color: UIColor)
}

class ProjectProgressViewController: UIViewController {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var progressSlider: UISlider!
    @IBOutlet private var statusLabel: UILabel!
    
    private lazy var presenter: ProjectProgressPresenter? = {
        DefaultProjectProgressPresenter(view: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }

}

private extension ProjectProgressViewController {
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        guard sender === progressSlider else { return }
        
        presenter?.progressValueDidChange(sender.value)
    }
}

extension ProjectProgressViewController: ProjectProgressView {
    
    func updateTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func updateSlider(_ value: Float) {
        progressSlider.value = value
    }
    
    func updateStatus(_ status: String, color: UIColor) {
        statusLabel.text = status
        statusLabel.textColor = color
    }
}

