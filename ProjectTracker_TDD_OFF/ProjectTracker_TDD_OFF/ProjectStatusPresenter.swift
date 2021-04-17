//
//  ProjectStatusPresenter.swift
//  ProjectTracker_TDD_OFF
//
//  Created by Ihor Savynskyi on 17.04.2021.
//

import Foundation
import UIKit

protocol ProjectStatusPresenter {
    func viewDidLoad()
    func progressDidChange(_ newValue: Float)
}

class DefaultProjectStatusPresenter {
    
    private weak var view: ProjectStatusView?
    
    private static let progressRange: ClosedRange<Float> = 0.0...100.0
    
    private var projectStatus: ProjectStatus = .notStarted { didSet {updateProjectStatus()} }
    
    private enum ProjectStatus {
        
        case notStarted
        case inProgress(Float)
        case completed
        
        var progress: Float {
            switch self {
            case .notStarted:
                return progressRange.lowerBound
            case .inProgress(let value):
                return value
            case .completed:
                return progressRange.upperBound
            }
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
        
        var text: String {
            var suffix: String
            
            switch self {
            case .notStarted:
                suffix = "(not started)"
            case .inProgress:
                suffix = "(work in progress)"
            case .completed:
                suffix = "(completed)"
            }
            
            let prefix = String(format: "%.f%%", self.progress)
            
            return prefix + " " + suffix
        }
    }
    
    
    init(view: ProjectStatusView) {
        self.view = view
    }
}

private extension DefaultProjectStatusPresenter {
    
    func updateProjectStatus() {
        view?.setStatus(projectStatus.text, color: projectStatus.color)
    }
}

extension DefaultProjectStatusPresenter: ProjectStatusPresenter {
    
    func viewDidLoad() {
        view?.setTitle("Awesome project progress")
        view?.configureProgressAllowedRange(Self.progressRange)
        view?.setProjectProgress(Self.progressRange.lowerBound)
        view?.setStatus(projectStatus.text, color: projectStatus.color)
    }
    
    func progressDidChange(_ newValue: Float) {
        
        if newValue <= Self.progressRange.lowerBound {
            projectStatus = .notStarted
        } else if newValue > Self.progressRange.lowerBound && newValue < Self.progressRange.upperBound {
            projectStatus = .inProgress(newValue)
        } else if newValue >= Self.progressRange.upperBound {
            projectStatus = .completed
        }
    }
}
