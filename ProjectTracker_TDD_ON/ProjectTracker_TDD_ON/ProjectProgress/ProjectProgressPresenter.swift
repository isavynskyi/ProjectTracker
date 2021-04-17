//
//  ProjectProgressPresenter.swift
//  ProjectTracker_TDD_ON
//
//  Created by Ihor Savynskyi on 17.04.2021.
//

import Foundation

protocol ProjectProgressPresenter {
    func viewDidLoad()
    func progressValueDidChange(_ newValue: Float)
}

class DefaultProjectProgressPresenter {
    
    private weak var view: ProjectProgressView?
    
    init(view: ProjectProgressView) {
        self.view = view
    }
}

extension DefaultProjectProgressPresenter: ProjectProgressPresenter {
    
    func viewDidLoad() {
        view?.updateTitle("Awesome project progress")
        view?.updateSlider(0)
        view?.updateStatus("0% (not started)", color: .systemRed)
    }
    
    func progressValueDidChange(_ newValue: Float) {
        view?.updateStatus("0% (not started)", color: .systemRed)
    }
}
