//
//  EateriesTableViewController.swift
//  Eateries
//
//  Created by OlehMalichenko on 03.12.2017.
//  Copyright © 2017 OlehMalichenko. All rights reserved.
//

import UIKit
import CoreData

class EateriesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchResultController: NSFetchedResultsController<Restaurant>!
    
    var restaurants: [Restaurant] = []

    
    @IBAction func close(segue: UIStoryboardSegue) {
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tableView.estimatedRowHeight = 85
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                               managedObjectContext: context,
                                                               sectionNameKeyPath: nil,
                                                               cacheName: nil)
            fetchResultController.delegate = self
            do {
             try fetchResultController.performFetch()
                restaurants = fetchResultController.fetchedObjects!
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }

     // MARK: - Fetch result controller delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else {break}
            tableView.insertRows(at: [indexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath else {break}
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath = newIndexPath else {break}
            tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            tableView.reloadData()
        }
        
        restaurants = controller.fetchedObjects as! [Restaurant]
        
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: - Table view data source

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return restaurants.count
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // формирование ячейки и её параметров
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EateriesTableViewCell
        cell.thumbnailImageView.image = UIImage(data: restaurants[indexPath.row].image! as Data)
        cell.thumbnailImageView.layer.cornerRadius = 32.5
        cell.thumbnailImageView.clipsToBounds = true
        // установка в ячейку данных
        cell.nameLabel.text = restaurants[indexPath.row].name
        cell.locationLabel.text = restaurants[indexPath.row].location
        cell.typeLabel.text = restaurants[indexPath.row].type
        cell.accessoryType = restaurants[indexPath.row].isVisited ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let ac = UIAlertController(title: nil, message: "What do you want...", preferredStyle: .actionSheet)
//        let call = UIAlertAction(title: "Call to +38(098)900-07-4\(indexPath.row)", style: .default) {
//            (action: UIAlertAction) -> Void in
//            let check = UIAlertController(title: nil, message: "Dont have this number", preferredStyle: .alert)
//            let chechAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            check.addAction(chechAction)
//            self.present(check, animated: true, completion: nil)
//        }
//        let restorantTitle = self.restorantVisited[indexPath.row] ? "I`m don`t visit this" : "I`m visit this"
//        let mark = UIAlertAction(title: restorantTitle, style: .default) {
//            (_ : UIAlertAction) -> Void in
//            let cell = tableView.cellForRow(at: indexPath)
//            self.restorantVisited[indexPath.row] = !self.restorantVisited[indexPath.row]
//            cell?.accessoryType = self.restorantVisited[indexPath.row] ? .checkmark : .none
//        }
//        let cancel = UIAlertAction(title: "Done", style: .cancel, handler: nil)
//        ac.addAction(call)
//        ac.addAction(mark)
//        ac.addAction(cancel)
//        present(ac, animated: true, completion: nil)
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let share = UITableViewRowAction(style: .default, title: "Send") {
            (_, indexPath) in
            let textDefault = "I`m here " + self.restaurants[indexPath.row].name!
            if let image = UIImage(data: self.restaurants[indexPath.row].image! as Data) {
                let activityController = UIActivityViewController(activityItems: [textDefault, image], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        }
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (_, indexPath) in
            self.restaurants.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                let objectToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(objectToDelete)
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        share.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        delete.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
        return [delete, share]
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ditailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as! EateryDitailViewController
                dvc.restaurant = self.restaurants[indexPath.row]
            }
            
            
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
