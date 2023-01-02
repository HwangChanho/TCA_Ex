//
//  testModel.swift
//  TCA_Simple_Tutorial
//
//  Created by MDsqr on 2023/01/02.
//

import Foundation

// MARK: - PushVideoElement
struct Memo: Codable ,Equatable, Identifiable {
    let createdAt, name: String
    let number: Int
    let id: String
}

typealias Memos = [Memo]
