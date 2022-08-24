//
//  HistoryViewModel.swift
//  HistoryView
//
//  Created by Mitya Kim on 8/24/22.
//

import Foundation

struct HistoryViewModel {
    
    var sections = [HistorySection]()
    
    var transactions: [Transaction]? {
        didSet {
            guard let txs = transactions else { return }
            
            let firstMonth = "Jul"
            let secondMonth = "Jun"
            let thirdMonth = "May"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            
            let firstTransactions = txs.filter {
                let dateString = dateFormatter.string(from: $0.date)
                return dateString.starts(with: firstMonth)
            }
            
            let secondTransactions = txs.filter {
                let dateString = dateFormatter.string(from: $0.date)
                return dateString.starts(with: secondMonth)
            }
            
            let thirdTransactions = txs.filter {
                let dateString = dateFormatter.string(from: $0.date)
                return dateString.starts(with: thirdMonth)
            }
            
            let firstMonthSection = HistorySection(title: "Jul", transactions: firstTransactions)
            let secondMonthSection = HistorySection(title: "Jun", transactions: secondTransactions)
            let thirdMonthSection = HistorySection(title: "May", transactions: thirdTransactions)
            
            sections = [HistorySection]()
            sections.append(firstMonthSection)
            sections.append(secondMonthSection)
            sections.append(thirdMonthSection)
        }
    }
}
