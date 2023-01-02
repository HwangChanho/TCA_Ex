//
//  TCA_Simple_TutorialApp.swift
//  TCA_Simple_Tutorial
//
//  Created by MDsqr on 2022/12/29.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCA_Simple_TutorialApp: App {
    
    let counterStore = Store(initialState: CounterState(), reducer: counterReducer, environment: CounterEnvironment())
    
    let memoStore = Store(initialState: MemoState(), reducer: memoReducer, environment: MemoEnvironment(memoClient: MemoClient.live, mainQueue: .main)) // static memo

    var body: some Scene {
        WindowGroup() {
            MemoView(store: memoStore)
        }
    }
}
