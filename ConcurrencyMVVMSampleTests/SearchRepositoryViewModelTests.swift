//
//  ConcurrencyMVVMSampleTests.swift
//  ConcurrencyMVVMSampleTests
//
//  Created by Hikaru Kuroda on 2023/01/29.
//

import XCTest
@testable import ConcurrencyMVVMSample

class MockSearchRepositoryModel: SearchRepositoryModelable {
    var onFetchRepositoriesCalled: (() -> Void)?
    var fetchRepositoriesResult: [Repository]!
    var fetchRepositoryCalledCount = 0

    func fetchRepositries(keyword: String) async throws -> [ConcurrencyMVVMSample.Repository] {
        fetchRepositoryCalledCount += 1
        onFetchRepositoriesCalled?()

        return await withCheckedContinuation {
            $0.resume(returning: fetchRepositoriesResult)
        }
    }

    func reset() {
        onFetchRepositoriesCalled = nil
        fetchRepositoriesResult = nil
        fetchRepositoryCalledCount = 0
    }
}

@MainActor
final class ConcurrencyMVVMSampleTests: XCTestCase {

    private var viewModel: SearchRepositoryViewModel!
    private var model: MockSearchRepositoryModel!

    override func setUpWithError() throws {
        model = MockSearchRepositoryModel()
        viewModel = SearchRepositoryViewModel(model: model)
    }

    override func tearDownWithError() throws {
        self.model.reset()
    }

    func testOnSearchButtonClicked_通信中にisLoadingがTrueになること() async throws {
        // 初期値
        XCTAssertFalse(viewModel.isLoading)

        // 通信中
        model.onFetchRepositoriesCalled = {
            XCTAssertTrue(self.viewModel.isLoading)
        }

        model.fetchRepositoriesResult = []

        await viewModel.onSearchButtonTapped()

        // 通信後
        XCTAssertFalse(self.viewModel.isLoading)
    }
}
