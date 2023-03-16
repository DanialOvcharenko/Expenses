//
//  ViewController.swift
//  Expenses(2.0)
//
//  Created by Mac on 10.03.2023.
//

import UIKit
import CoreData


class ExpenceTypesVC: UIViewController {
    
    static var expenceTypes = [ExpenceType]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortAZButton: UIButton!
    @IBOutlet weak var sortZAButton: UIButton!
    
    
    let cellID = "expenceTypeTVCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        ExpenceTypesVC.expenceTypes = DataManager.shared.expenceTypes()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addExpenceType))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        self.sortAZButton.layer.cornerRadius = 8
        self.sortZAButton.layer.cornerRadius = 8
        
        if ExpenceTypesVC.expenceTypes.isEmpty {
            title = "Add Expence Type"
        } else {
            title = "Expence Types"
        }
        
        self.tableView.reloadData()
    }
    
    @objc func addExpenceType(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Enter new Expence type", message: "", preferredStyle: .alert)
        
        let createAction = UIAlertAction(title: "Create", style: .default) { (action) in
            
            if !ExpenceTypesVC.expenceTypes.contains(where: { $0.name == textfield.text ?? "" }) {
                
                let expenceType = DataManager.shared.expenceType(name: textfield.text ?? "")
                
                ExpenceTypesVC.expenceTypes.append(expenceType)
                DataManager.shared.save()
                self.tableView.reloadData()

                self.title = "Expence Type"
            } else {

                let alert = UIAlertController(title: "Attention", message: "This Expence type is already in your list", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "ok", style: .cancel) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Ex: Home"
            textfield = alertTextField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - ButtonsPressed
    
    @IBAction func buttonAZPressed(_ sender: Any) {
        ExpenceTypesVC.expenceTypes.sort(by: { $0.name ?? "" < $1.name ?? "" })
        DataManager.shared.save()
        tableView.reloadData()
    }
    
    @IBAction func buttonZAPressed(_ sender: Any) {
        ExpenceTypesVC.expenceTypes.sort(by: { $0.name ?? "" > $1.name ?? "" })
        DataManager.shared.save()
        tableView.reloadData()
    }
    
    //

}


// MARK: - UITableView extension
extension ExpenceTypesVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ExpenceTypesVC.expenceTypes.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let expenceType = ExpenceTypesVC.expenceTypes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! expenceTypeTVCell
        cell.setupCell(expenceType: expenceType)
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
        let expenceType = ExpenceTypesVC.expenceTypes[indexPath.row]
        var nameTextField = UITextField()

        let alert = UIAlertController(title: "Edit Expence Type", message: "", preferredStyle: .alert)
        let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
            expenceType.setValue(nameTextField.text ?? "", forKey: "name")
            DataManager.shared.save()
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Ex: Home"
            alertTextField.text = expenceType.name
            nameTextField = alertTextField
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(editAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func deleteExpenceTypeAction(indexPath: IndexPath) {
        let expenceType = ExpenceTypesVC.expenceTypes[indexPath.row]
        let areYouSureAlert = UIAlertController(title: "Are you sure you want to delete this Expence Type?", message: "", preferredStyle: .alert)
        let yesDeleteAction = UIAlertAction(title: "Yes", style: .destructive) { [self] (action) in
            
            TrackingVC.total -= expenceType.total
            
            DataManager.shared.deleteExpenceType(expenceType: expenceType)
            ExpenceTypesVC.expenceTypes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            
            if ExpenceTypesVC.expenceTypes.isEmpty {
                title = "Add Expence Type"
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
