//
//  ProjectProgressPresenter.swift
//  ProjectTracker_TDD_ON
//
//  Created by Ihor Savynskyi on 17.04.2021.
//

import Foundation
import UIKit

protocol ProjectProgressPresenter {
    func viewDidLoad()
    func progressValueDidChange(_ newValue: Float)
}

class DefaultProjectProgressPresenter {
    
    private weak var view: ProjectProgressView?
    
    private var projectStatus: ProjectStatus = .notStarted { didSet {updateProjectStatusOnView()} }
    
    private enum ProjectStatus {
        case notStarted
        case inProgress(Float)
        case completed
        
        var text: String {
            let percentageText = String(format: "%.f%%", self.progress)
            
            let statusFullText = percentageText + " (\(self.statusLabel))"
            return statusFullText
        }
        
        var color: UIColor {
            switch self {
            case .notStarted:
                return .systemRed
            case .inProgress:
                return .systemYellow
            case .completed:
                return .systemGreen
            }
        }
        
        private var progress: Float {
            switch self {
            case .notStarted:
                return 0
            case .inProgress(let value):
                return value
            case .completed:
                return 100
            }
        }

        private var statusLabel: String {
            switch self {
            case .notStarted:
                return "not started"
            case .inProgress:
                return "work in progress"
            case .completed:
                return "completed"
            }
        }
    }
    
    init(view: ProjectProgressView) {
        self.view = view
    }
}

private extension DefaultProjectProgressPresenter {
    
    func updateProjectStatusOnView() {
        view?.updateStatus(projectStatus.text, color: projectStatus.color)
    }
}

extension DefaultProjectProgressPresenter: ProjectProgressPresenter {
    
    func viewDidLoad() {
        view?.updateTitle("Awesome project progress")
        view?.updateSlider(0)
        view?.updateStatus(projectStatus.text, color: projectStatus.color)
        view?.configureProgressSliderRange(0...100)
    }
    
    func progressValueDidChange(_ newValue: Float) {
        
        let normalizedNewValue = newValue.rounded(.towardZero)
        
        if normalizedNewValue <= 0 {
            projectStatus = .notStarted
        } else if normalizedNewValue > 0 && normalizedNewValue < 100 {
            projectStatus = .inProgress(normalizedNewValue)
        } else if normalizedNewValue >= 100 {
            projectStatus = .completed
        }
    }
}
