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
    
    private static let allowedProgressRange: ClosedRange<Float> = 0...100
    
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
                return allowedProgressRange.lowerBound
            case .inProgress(let value):
                return value
            case .completed:
                return allowedProgressRange.upperBound
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
        view?.configureProgressSliderRange(Self.allowedProgressRange)
    }
    
    func progressValueDidChange(_ newValue: Float) {
        
        let normalizedNewValue = newValue.rounded(.towardZero)
        
        if normalizedNewValue <= Self.allowedProgressRange.lowerBound {
            projectStatus = .notStarted
        } else if normalizedNewValue > Self.allowedProgressRange.lowerBound && normalizedNewValue < Self.allowedProgressRange.upperBound {
            projectStatus = .inProgress(normalizedNewValue)
        } else if normalizedNewValue >= Self.allowedProgressRange.upperBound {
            projectStatus = .completed
        }
    }
}
