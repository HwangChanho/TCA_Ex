//
//  MemoVIew.swift
//  TCA_Simple_Tutorial
//
//  Created by MDsqr on 2023/01/02.
//

import SwiftUI
import ComposableArchitecture

// 도메인 + 상태
struct MemoState: Equatable {
    var memos: [Memo] = []
    var selectedMemo: Memo? = nil
    var isLoading: Bool = false
}

// 도메인 + 액션
enum MemoAction: Equatable {
    case fetchItem(_ id: String) // 단일 조회 액션
    case fetchItemResponse(Result<Memo, MemoClient.Failure>) // 단일 조회 액션 응답
    case fetchMemos // 조회 액션
    case fetchMemosResponse(Result<Memos, MemoClient.Failure>) // 조회 액션 응답
}

// 환경설정 주입
struct MemoEnvironment {
    var memoClient: MemoClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

// 상태와 액션을 가지고 있는 리듀서
// 액션이 들어왔을때 상태를 변경하는 부분
let memoReducer = AnyReducer<MemoState, MemoAction, MemoEnvironment> { state, action, eniv in
    
    // 들어온 액션에 따라 상태를 변경
    switch action {
    case .fetchItem(let id):
        enum FetchItemId {}
        state.isLoading = true
        return eniv.memoClient
            .fetchMemoItem(id)
            .debounce(id: FetchItemId.self,
                      for: 0.3,
                      scheduler: eniv.mainQueue)
            .catchToEffect(MemoAction.fetchItemResponse)
    case .fetchItemResponse(.success(let memo)):
        state.selectedMemo = memo
        state.isLoading = false
        return Effect.none
    case .fetchItemResponse(.failure):
        state.selectedMemo = nil
        state.isLoading = false
        return Effect.none
        
    case .fetchMemos:
        enum FetchItems {}
        state.isLoading = true
        return eniv.memoClient
            .fetchMemos()
            .debounce(id: FetchItems.self,
                      for: 0.3,
                      scheduler: eniv.mainQueue)
            .catchToEffect(MemoAction.fetchMemosResponse)
    case .fetchMemosResponse(.success(let memos)):
        state.memos = memos
        state.isLoading = false
        return Effect.none
    case .fetchMemosResponse(.failure):
        state.memos = []
        state.isLoading = false
        return Effect.none
    }
}


struct MemoView: View {
    
    let store: Store<MemoState, MemoAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            
            ZStack {
                
                if viewStore.state.isLoading {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .overlay {
                            ProgressView().tint(.white)
                                .scaleEffect(1.7)
                        }.zIndex(1) // 위로 올리기
                }
                
                List{
                    Section {
                        ForEach(viewStore.state.memos) { aMemo in
                            Button(aMemo.name) {
                                viewStore.send(.fetchItem(aMemo.id), animation: .default)
                            }
                        }
                    } header: {
                        VStack(spacing: 8) {
                            Button("메모 목록 가져오기") {
                                viewStore.send(.fetchMemos, animation: .default)
                            }
                            Text("선택된 메모 정보")
                            Text(viewStore.state.selectedMemo?.id ?? "비어있음")
                            Text(viewStore.state.selectedMemo?.name ?? "비어있음")
                        }
                    }.listStyle(PlainListStyle())
                    
                }
            }
        }
    }
}
