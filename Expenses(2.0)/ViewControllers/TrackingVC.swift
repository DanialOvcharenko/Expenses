//
//  TrackingVC.swift
//  Expenses(2.0)
//
//  Created by Mac on 11.03.2023.
//

import UIKit

class TrackingVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var clearListButton: UIButton!
    @IBOutlet weak var toHistoryButton: UIButton!
    
    static var total: Float = 0
    
    let cellID = "trackingTVCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        TrackingVC.total = 0
        for expenceType in ExpenceTypesVC.expenceTypes {
            TrackingVC.total += expenceType.total
        }
        
        self.totalLabel.text = String(TrackingVC.total)
        
        self.clearListButton.layer.cornerRadius = 8
        self.toHistoryButton.layer.cornerRadius = 8
        
        self.tableView.reloadData()
    }
    
    //MARK: - ButtonsPressed
    
    @IBAction func clearListButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Attention", message: "Do you really want to delete all items of this list. Better save to the history your expence", preferredStyle: .alert)
        
        let clearAction = UIAlertAction(title: "Clear list", style: .default) { (action) in
            
            for eachExpenceType in ExpenceTypesVC.expenceTypes {
                TrackingVC.total -= eachExpenceType.total
                DataManager.shared.deleteExpenceType(expenceType: eachExpenceType)
                ExpenceTypesVC.expenceTypes.removeAll()
                
                self.tableView.reloadData()
            }
            
            TrackingVC.total = 0
            self.totalLabel.text = String(TrackingVC.total)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(clearAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func toHistoryButtonPressed(_ sender: Any) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Name this Expence for history", message: "", preferredStyle: .alert)
        
        let createAction = UIAlertAction(title: "To History", style: .default) { (action) in
            
            guard let name = textfield.text else {
                return
            }
            
            if !HistoryVC.historyExpences.contains(where: { $0.name == name }) {
                
                if !name.isEmpty {
                    
                    let expenceHistory = DataManager.shared.historyExpence(name: name, total: TrackingVC.total)

                    HistoryVC.historyExpences.append(expenceHistory)
                    
                    DataManager.shared.save()
                    self.tableView.reloadData()
                    
                    let alert = UIAlertController(title: "Congratulation", message: "You add the new expence to the history list", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "ok", style: .cancel) { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    
                    let alert = UIAlertController(title: "Stop", message: "Before saving write the name", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "ok", style: .cancel) { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }

            } else {

                let alert = UIAlertController(title: "Attention", message: "This Expence is already in your history list", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "ok", style: .cancel) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Ex: 10-20 March 2023"
            textfield = alertTextField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    //

}


extension TrackingVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ExpenceTypesVC.expenceTypes.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let expenceType = ExpenceTypesVC.expenceTypes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! trackingTVCell
        cell.setupCell(expenceType: expenceType)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TrackingDetailVC") as? TrackingDetailVC {
            vc.index = indexPath.row
            vc.expenceType = ExpenceTypesVC.expenceTypes[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
