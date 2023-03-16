//
//  TrackingDetailVC.swift
//  Expenses(2.0)
//
//  Created by Mac on 12.03.2023.
//

import UIKit

class TrackingDetailVC: UIViewController {

    var expences = [Expence]()
    var index = Int()
    var expenceType: ExpenceType?
    
    var totalForThisExpence: Float = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortByNameButton: UIButton!
    @IBOutlet weak var sortByCostButton: UIButton!
    
    let cellID = "trackingDetailTVCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addExpence))
        
        if let expenceType = expenceType {
            expences = DataManager.shared.expences(expenceType: expenceType)
        }
        tableView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        self.sortByNameButton.layer.cornerRadius = 8
        self.sortByCostButton.layer.cornerRadius = 8
        
        totalForThisExpence = 0
        for eachExpence in expences {
            totalForThisExpence += eachExpence.cost
        }
        
        guard let expenceName = ExpenceTypesVC.expenceTypes[index].name else {
            return
        }
        title = "\(expenceName) (total: \(totalForThisExpence))"
        
        
    }
    
    @objc func goBack(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func addExpence(_ sender: UIBarButtonItem) {
        var nameTextField = UITextField()
        var costOfExpenceTextField = UITextField()
        
        let alert = UIAlertController(title: "Enter new expence", message: "", preferredStyle: .alert)
        let createAction = UIAlertAction(title: "Create", style: .default) { [self] (action) in
            
            if !expences.contains(where: { $0.name == nameTextField.text ?? "" }) {
                
                guard let costOfExpence = Float(costOfExpenceTextField.text ?? "") else {
                    return
                }
                
                let expence = DataManager.shared.expence(name: nameTextField.text ?? "", cost: costOfExpence, expenceType: expenceType!)
                
                expenceType?.total += costOfExpence
                
                totalForThisExpence += costOfExpence
                guard let expenceName = ExpenceTypesVC.expenceTypes[index].name else {
                    return
                }
                title = "\(expenceName) (total: \(totalForThisExpence))"

                expences.append(expence)
                tableView.reloadData()
                DataManager.shared.save()
                
            } else {
                
                let alert = UIAlertController(title: "Attention", message: "This Expence is already in your list. You can edit it if needed", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "ok", style: .cancel) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                
            }
                
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Ex: Window"
            nameTextField = alertTextField
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Ex: 200"
            costOfExpenceTextField = alertTextField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - ButtonsPressed
    
    @IBAction func sortByNameButtonPressed(_ sender: Any) {
        expences.sort(by: { $0.name ?? "" < $1.name ?? "" })
        DataManager.shared.save()
        tableView.reloadData()
    }
    
    @IBAction func SortByCostButtonPressed(_ sender: Any) {
        expences.sort(by: { $0.cost < $1.cost  })
        DataManager.shared.save()
        tableView.reloadData()
    }
    
    //
}



// MARK: - UITableView extensions
extension TrackingDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return expences.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let expence = expences[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! trackingDetailTVCell
        cell.setupCell(expence: expence)
        cell.accessoryType = .none
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, view, completionHandler) in
            self?.editExpenceAction(indexPath: indexPath)
            completionHandler(true)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.deleteExpenceAction(indexPath: indexPath)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [editAction, deleteAction])
    }
    
    private func editExpenceAction(indexPath: IndexPath) {
        let expence = expences[indexPath.row]
        var nameTextField = UITextField()
        var costOfExpenceTextField = UITextField()

        let alert = UIAlertController(title: "Edit Expence", message: "", preferredStyle: .alert)
        let editAction = UIAlertAction(title: "Edit", style: .default) { [self] (action) in
            
            guard let newCost = Float(costOfExpenceTextField.text ?? "") else {
                return
            }
            
            
            expenceType?.total -= expence.cost
            totalForThisExpence -= expence.cost
            
            DataManager.shared.deleteExpence(expense: expence)
            expences.remove(at: indexPath.row)
            
            guard let expenceName = nameTextField.text else {
                return
            }
            
            let newExpence = DataManager.shared.expence(name: expenceName, cost: newCost, expenceType: expenceType!)
            
            expenceType?.total += newCost
            totalForThisExpence += newCost
    
            
            expences.insert(newExpence, at: indexPath.row)
            
            guard let expenceTypeName = ExpenceTypesVC.expenceTypes[index].name else {
                return
            }
            title = "\(expenceTypeName) (total: \(totalForThisExpence))"
            
            self.tableView.reloadData()
            DataManager.shared.save()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Ex: Window"
            alertTextField.text = expence.name
            nameTextField = alertTextField
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Ex: 200"
            alertTextField.text = String(expence.cost)
            costOfExpenceTextField = alertTextField
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    private func deleteExpenceAction(indexPath: IndexPath) {
        let expence = expences[indexPath.row]
        let areYouSureAlert = UIAlertController(title: "Are you sure you want to delete this Expence?", message: "", preferredStyle: .alert)
        let yesDeleteAction = UIAlertAction(title: "Yes", style: .destructive) { [self] (action) in
            
            expenceType?.total -= expence.cost
            
            totalForThisExpence -= expence.cost
            guard let expenceName = ExpenceTypesVC.expenceTypes[index].name else {
                return
            }
            title = "\(expenceName) (total: \(totalForThisExpence))"
            
            DataManager.shared.deleteExpence(expense: expence)
            expences.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            
        }
        let noDeleteAction = UIAlertAction(title: "No", style: .default) { (action) in
            //do nothing
        }
        areYouSureAlert.addAction(noDeleteAction)
        areYouSureAlert.addAction(yesDeleteAction)
        self.present(areYouSureAlert, animated: true, completion: nil)
    }

}
