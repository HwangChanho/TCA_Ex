//
//  MemoClient.swift
//  TCA_Simple_Tutorial
//
//  Created by MDsqr on 2023/01/02.
//

import Foundation
import ComposableArchitecture

/*
 side Effect
 
 외부에서 일어난일 (ex) API호출) 등 과 상호작용을(store로 가져와서 상태변경) 할떄 Effect 사용
 */

struct MemoClient {
    // 단일 아이템 조회
    var fetchMemoItem: (_ id: String) -> Effect<Memo, Failure> // id
    
    var fetchMemos: () -> Effect<Memos, Failure> // typealias 사용 Memo의 배열
    
    struct Failure: Error, Equatable {}
}

extension MemoClient {
    static let live = Self { id in
        // fetchMemoItem
        Effect.task {
            let (data, _) = try await URLSession.shared
                .data(from: URL(string: "https://63b22cd40d51f5b2972513f8.mockapi.io/testapi/v1/testAPI2/\(id)")!)
            return try JSONDecoder().decode(Memo.self, from: data)
        }
        .mapError { _ in
            Failure() // error의 형태 변환
        }
        .eraseToEffect()
    } fetchMemos: {
        Effect.task {
            let (data, _) = try await URLSession.shared
                .data(from: URL(string: "https://63b22cd40d51f5b2972513f8.mockapi.io/testapi/v1/testAPI2/")!)
            return try JSONDecoder().decode(Memos.self, from: data)
        }
        .mapError { _ in
            Failure() // error의 형태 변환
        }
        .eraseToEffect()
    }

}
