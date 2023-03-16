//
//  HistoryVC.swift
//  Expenses(2.0)
//
//  Created by Mac on 14.03.2023.
//

import UIKit

class HistoryVC: UIViewController {

    static var historyExpences = [HistoryExpence]()
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellID = "historyExpenceTVCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        HistoryVC.historyExpences = DataManager.shared.historyExpences()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        if HistoryVC.historyExpences.isEmpty {
            title = "History is empty"
        } else {
            title = "History of ypor expences"
        }
        
        HistoryVC.historyExpences = DataManager.shared.historyExpences()
        tableView.reloadData()
        
    }
    
}


extension HistoryVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return HistoryVC.historyExpences.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let historyExpence = HistoryVC.historyExpences[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! historyExpenceTVCell
        cell.setupCell(historyExpence: historyExpence)
        //cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, view, completionHandler) in
            self?.editExpenceTypeAction(indexPath: indexPath)
            completionHandler(true)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.deleteExpenceTypeAction(indexPath: indexPath)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [editAction, deleteAction])
    }
    
    private func editExpenceTypeAction(indexPath: IndexPath) {
        let historyExpence = HistoryVC.historyExpences[indexPath.row]
        var nameTextField = UITextField()
        var costOfHistoryExpenceTextField = UITextField()

        let alert = UIAlertController(title: "Edit history expence", message: "", preferredStyle: .alert)
        let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
            
            
            if let cost = Float(costOfHistoryExpenceTextField.text ?? "") {
                historyExpence.setValue(nameTextField.text ?? "", forKey: "name")
                historyExpence.setValue(cost, forKey: "total")
                
            } else {
                
            }
            
            DataManager.shared.save()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Ex: 10-20 MArch 2023"
            alertTextField.text = historyExpence.name
            nameTextField = alertTextField
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Ex: 1000"
            alertTextField.text = String(historyExpence.total)
            costOfHistoryExpenceTextField = alertTextField
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func deleteExpenceTypeAction(indexPath: IndexPath) {
        let historyExpence = HistoryVC.historyExpences[indexPath.row]
        let areYouSureAlert = UIAlertController(title: "Are you sure you want to delete this Expence from history?", message: "", preferredStyle: .alert)
        let yesDeleteAction = UIAlertAction(title: "Yes", style: .destructive) { [self] (action) in
            
            DataManager.shared.deleteHistoryExpence(historyExpence: historyExpence)
            HistoryVC.historyExpences.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            
            if HistoryVC.historyExpences.isEmpty {
                title = "History is empty"
            }
        }
        let noDeleteAction = UIAlertAction(title: "No", style: .default) { (action) in
            //do nothing
        }
        areYouSureAlert.addAction(noDeleteAction)
        areYouSureAlert.addAction(yesDeleteAction)
        self.present(areYouSureAlert, animated: true, completion: nil)
    }
    
}



