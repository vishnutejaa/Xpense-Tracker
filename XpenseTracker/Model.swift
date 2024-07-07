//
//  Models.swift
//  TrackXpense
//
//  Created by Vishnu Tejaa on 3/17/24.
//

import Foundation



import Foundation

struct Transaction: Identifiable {
    var id: UUID = UUID()
    var amount: Double
    var date: Date
    var category: String
    var isIncome: Bool
    var payee: String?
}

struct Budget: Identifiable {
    var id: UUID = UUID()
    var category: String
    var limit: Double
}

