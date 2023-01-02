//
//  ContentView.swift
//  TCA_Simple_Tutorial
//
//  Created by MDsqr on 2022/12/29.
//

// https://www.youtube.com/watch?v=fYQ9YnbvasU

import SwiftUI
import ComposableArchitecture

// 도메인 + 상태
struct CounterState: Equatable {
    var count = 0
}

// 도메인 + 액션
enum CounterAction: Equatable {
    case addCount // 카운트 더하는 액션
    case subCount // 카운트 뺴는 액션
}

struct CounterEnvironment {}

/*
 public struct AnyReducer<State, Action, Environment> {
 private let reducer: (inout State, Action, Environment) -> EffectTask<Action>
 */

let counterReducer = AnyReducer<CounterState, CounterAction, CounterEnvironment> { state, action, eniv in
    
    // 들어온 액션에 따라 상태를 변경
    
    switch action {
    case .addCount:
        state.count += 1
        return Effect.none
    case .subCount:
        state.count -= 1
        return Effect.none
    }
}


struct CounterView: View {
    
    let store: Store<CounterState, CounterAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack {
                Text("\(viewStore.state.count)")
                    .padding()
                HStack {
                    Button("더하기") {
                        viewStore.send(.addCount)
                    }
                    Button("뺴기") {
                        viewStore.send(.subCount)
                    }
                }
            }
            
        }
    }
}

//struct CounterView_Previews: PreviewProvider {
//    static var previews: some View {
//        CounterView()
//    }
//}
