//
//  ProjectStatusPresenter.swift
//  ProjectTracker_TDD_OFF
//
//  Created by Ihor Savynskyi on 17.04.2021.
//

import Foundation

protocol ProjectStatusPresenter {
    func viewDidLoad()
    func progressDidChange(_ value: Float)
}

class DefaultProjectStatusPresenter {
    
    private weak var view: ProjectStatusView?
    
    init(view: ProjectStatusView) {
        self.view = view
    }
}

extension DefaultProjectStatusPresenter: ProjectStatusPresenter {
    
    func viewDidLoad() {
        view?.setTitle("Awesome project progress")
        view?.setProjectProgress(0)
        view?.setStatus("not started")
    }
    
    func progressDidChange(_ value: Float) {
        
    }
}
