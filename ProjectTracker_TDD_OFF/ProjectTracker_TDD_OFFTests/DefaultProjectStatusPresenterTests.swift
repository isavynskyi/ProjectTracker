//
//  ProjectTracker_TDD_OFFTests.swift
//  ProjectTracker_TDD_OFFTests
//
//  Created by Ihor Savynskyi on 17.04.2021.
//

import XCTest
@testable import ProjectTracker_TDD_OFF

class DefaultProjectStatusPresenterTests: XCTestCase {

    func test_whenViewDidLoad_thenViewConfigurationMethodsCalled() throws {
        let viewMock = ProjectStatusViewMock()
        let sut = makeSUT(view: viewMock)
        
        XCTAssertEqual(viewMock.setTitleCallsHistory.count, 0)
        XCTAssertEqual(viewMock.configureProgressAllowedRangeCallsHistory.count, 0)
        XCTAssertEqual(viewMock.setProjectProgressCallsHistory.count, 0)
        XCTAssertEqual(viewMock.setStatusCallsHistory.count, 0)

        sut.viewDidLoad()
        
        XCTAssertEqual(viewMock.setTitleCallsHistory.count, 1)
        XCTAssertEqual(viewMock.setTitleCallsHistory.first, "Awesome project progress")

        XCTAssertEqual(viewMock.configureProgressAllowedRangeCallsHistory.count, 1)
        XCTAssertEqual(viewMock.configureProgressAllowedRangeCallsHistory.first, 0.0...100.0)

        XCTAssertEqual(viewMock.setProjectProgressCallsHistory.count, 1)
        XCTAssertEqual(viewMock.setProjectProgressCallsHistory.first, 0.0)

        XCTAssertEqual(viewMock.setStatusCallsHistory.count, 1)
        XCTAssertEqual(viewMock.setStatusCallsHistory.first?.status, "0% (not started)")
        XCTAssertEqual(viewMock.setStatusCallsHistory.first?.color, .systemRed)
    }
    
    func test_whenProjectProgressIncreases_thenProjectStatusUpdatedCorrectly() {
        let viewMock = ProjectStatusViewMock()
        let sut = makeSUT(view: viewMock)

        XCTAssertEqual(viewMock.setStatusCallsHistory.count, 0)
        
        sut.progressDidChange(0)
        XCTAssertEqual(viewMock.setStatusCallsHistory.count, 1)
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.status, "0% (not started)")
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.color, .systemRed)

        sut.progressDidChange(10)
        XCTAssertEqual(viewMock.setStatusCallsHistory.count, 2)
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.status, "10% (work in progress)")
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.color, .systemYellow)

        sut.progressDidChange(50)
        XCTAssertEqual(viewMock.setStatusCallsHistory.count, 3)
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.status, "50% (work in progress)")
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.color, .systemYellow)

        sut.progressDidChange(99)
        XCTAssertEqual(viewMock.setStatusCallsHistory.count, 4)
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.status, "99% (work in progress)")
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.color, .systemYellow)
        
        sut.progressDidChange(100)
        XCTAssertEqual(viewMock.setStatusCallsHistory.count, 5)
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.status, "100% (completed)")
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.color, .systemGreen)
    }
    
    func test_whenProjectProgressLessThanAllowedLowerBound_thenProjectStatusIsCorrect() {
        let viewMock = ProjectStatusViewMock()
        let sut = makeSUT(view: viewMock)

        XCTAssertEqual(viewMock.setStatusCallsHistory.count, 0)
        
        sut.progressDidChange(-0.1)
        XCTAssertEqual(viewMock.setStatusCallsHistory.count, 1)
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.status, "0% (not started)")
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.color, .systemRed)
        
        sut.progressDidChange(-10.5)
        XCTAssertEqual(viewMock.setStatusCallsHistory.count, 2)
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.status, "0% (not started)")
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.color, .systemRed)
    }
    
    func test_whenProjectProgressGreaterThanAllowedUpperBound_thenProjectStatusIsCorrect() {
        let viewMock = ProjectStatusViewMock()
        let sut = makeSUT(view: viewMock)

        XCTAssertEqual(viewMock.setStatusCallsHistory.count, 0)
        
        sut.progressDidChange(100.1)
        XCTAssertEqual(viewMock.setStatusCallsHistory.count, 1)
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.status, "100% (completed)")
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.color, .systemGreen)
        
        sut.progressDidChange(1000.5)
        XCTAssertEqual(viewMock.setStatusCallsHistory.count, 2)
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.status, "100% (completed)")
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.color, .systemGreen)
    }
    
    func test_whenProjectProgressHasDecimalPart_thenProjectStatusRoundededCorrectly_forNotStartedState() {
        let viewMock = ProjectStatusViewMock()
        let sut = makeSUT(view: viewMock)

        XCTAssertEqual(viewMock.setStatusCallsHistory.count, 0)
        
        sut.progressDidChange(0.1)
        XCTAssertEqual(viewMock.setStatusCallsHistory.count, 1)
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.status, "0% (not started)")
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.color, .systemRed)
        
        sut.progressDidChange(0.5)
        XCTAssertEqual(viewMock.setStatusCallsHistory.count, 2)
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.status, "0% (not started)")
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.color, .systemRed)
        
        sut.progressDidChange(0.999)
        XCTAssertEqual(viewMock.setStatusCallsHistory.count, 3)
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.status, "0% (not started)")
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.color, .systemRed)
    }
    
    func test_whenProjectProgressHasDecimalPart_thenProjectStatusRoundededCorrectly_forWorkInProgressState() {
        let viewMock = ProjectStatusViewMock()
        let sut = makeSUT(view: viewMock)

        XCTAssertEqual(viewMock.setStatusCallsHistory.count, 0)
        
        sut.progressDidChange(1.01)
        XCTAssertEqual(viewMock.setStatusCallsHistory.count, 1)
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.status, "1% (work in progress)")
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.color, .systemYellow)
        
        sut.progressDidChange(42.99)
        XCTAssertEqual(viewMock.setStatusCallsHistory.count, 2)
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.status, "42% (work in progress)")
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.color, .systemYellow)
        
        sut.progressDidChange(99.1)
        XCTAssertEqual(viewMock.setStatusCallsHistory.count, 3)
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.status, "99% (work in progress)")
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.color, .systemYellow)
 
        sut.progressDidChange(99.7)
        XCTAssertEqual(viewMock.setStatusCallsHistory.count, 4)
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.status, "99% (work in progress)")
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.color, .systemYellow)
        
        sut.progressDidChange(99.99)
        XCTAssertEqual(viewMock.setStatusCallsHistory.count, 5)
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.status, "99% (work in progress)")
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.color, .systemYellow)
    }
        
    func test_whenProjectProgressHasDecimalPart_thenProjectStatusRoundededCorrectly_forCompletedState() {
        let viewMock = ProjectStatusViewMock()
        let sut = makeSUT(view: viewMock)

        XCTAssertEqual(viewMock.setStatusCallsHistory.count, 0)
        
        sut.progressDidChange(100.0)
        XCTAssertEqual(viewMock.setStatusCallsHistory.count, 1)
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.status, "100% (completed)")
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.color, .systemGreen)
        
        sut.progressDidChange(100.001)
        XCTAssertEqual(viewMock.setStatusCallsHistory.count, 2)
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.status, "100% (completed)")
        XCTAssertEqual(viewMock.setStatusCallsHistory.last?.color, .systemGreen)
    }
}


private extension DefaultProjectStatusPresenterTests {
    
    func makeSUT(view: ProjectStatusView = ProjectStatusViewMock()) -> DefaultProjectStatusPresenter {
        DefaultProjectStatusPresenter(view: view)
    }
}
