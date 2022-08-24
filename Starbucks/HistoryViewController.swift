//
//  ViewController.swift
//  HistoryView
//
//  Created by Mitya Kim on 8/24/22.
//

import UIKit

struct HistorySection {
    let title: String
    let transactions: [Transaction]
}

struct History: Codable {
    let transactions: [Transaction]
}

struct Transaction: Codable {
    let id: Int
    let type: String
    let amount: String
    let date: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case amount
        case date = "processed_at"
    }
}

class HistoryViewController: UITableViewController {
    
//    var sections = [HistorySection]()
    
    var viewModel: HistoryViewModel?
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
//        data()
        fetchTransactions()
    }
    
    func fetchTransactions() {
        HistoryService.shared.fetchTransactions { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let transactions):
                self.viewModel?.transactions = transactions
                self.tableView.reloadData()
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func style() {
        navigationItem.title = "History"
        tableView.register(HistoryViewCell.self, forCellReuseIdentifier: cellId)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        viewModel = HistoryViewModel()
    }
    
//    func data() {
//        let a1 = Transaction(id: 1, type: "Hello", amount: "745", date: Date())
//        let a2 = Transaction(id: 1, type: "Hello", amount: "7yr", date: Date())
//        let a3 = Transaction(id: 1, type: "Hello", amount: "7sg", date: Date())
//        let a4 = Transaction(id: 1, type: "Hello", amount: "746", date: Date())
//        let a5 = Transaction(id: 1, type: "Hello", amount: "778", date: Date())
//        let a6 = Transaction(id: 1, type: "Hello", amount: "79000", date: Date())
//
//        let firstSection = HistorySection(title: "Jan", transactions: [a1,a2])
//        let secondSection = HistorySection(title: "Aug", transactions: [a3,a5,a6])
//        let thirdSection = HistorySection(title: "May", transactions: [a4])
//
//        sections.append(firstSection)
//        sections.append(secondSection)
//        sections.append(thirdSection)
//    }
    
}

// MARK: - DataSource
extension HistoryViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? HistoryViewCell else { return UITableViewCell() }
        
        guard let vm = viewModel else { return UITableViewCell() }
        
        let section = indexPath.section
        
        var transaction: Transaction
        
        switch section {
                case 0:
                    transaction = vm.sections[0].transactions[indexPath.row]
                case 1:
                    transaction = vm.sections[1].transactions[indexPath.row]
                case 2:
                    transaction = vm.sections[2].transactions[indexPath.row]
                default:
                    return UITableViewCell()
                }
        
//        switch section {
//        case 0:
//            transaction = sections[0].transactions[indexPath.row]
//        case 1:
//            transaction = sections[1].transactions[indexPath.row]
//        case 2:
//            transaction = sections[2].transactions[indexPath.row]
//        default:
//            return UITableViewCell()
//        }
        
        cell.transaction = transaction
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let vm = viewModel else { return 0 }
        switch section {
        case 0:
            return vm.sections[0].transactions.count
        case 1:
            return vm.sections[1].transactions.count
        case 2:
            return vm.sections[2].transactions.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let vm = viewModel else { return nil }
        switch section {
        case 0:
            return vm.sections[0].title
        case 1:
            return vm.sections[1].title
        case 2:
            return vm.sections[2].title
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = viewModel?.sections else { return 0 }
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .tileBrown
    }
}

