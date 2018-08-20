//
//  EateryDitailViewController.swift
//  Eateries
//
//  Created by OlehMalichenko on 05.12.2017.
//  Copyright © 2017 OlehMalichenko. All rights reserved.
//

import UIKit
import CoreData
// подвязан ко Вью с картинкой и описанием конткретного ресторана
class EateryDitailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tabelView: UITableView! // аутлет самого ТэйблВью
    @IBOutlet weak var imageView: UIImageView! // аутлет картинки
    @IBOutlet weak var rateButton: UIButton! // аутлет кнопки на картинке
    @IBOutlet weak var mapButton: UIButton!
    
    var fetchResultController: NSFetchedResultsController<Restaurant>!
    
    var restaurant: Restaurant?
    /* экземпляр структуры находящейся в Restaurant.swift
     необходим для "общения" с EateriesTableViewController, в котором присутствует массив
     экземпляров указанной структуры. Через эту переменную получает элемент массива */
    
    
    // самый первый "вызов".
    override func viewWillAppear(_ animated: Bool) {
        // установка запрета скрывать навБар при прокрутке
        navigationController?.hidesBarsOnSwipe = false // не скрывать бар
        navigationController?.setNavigationBarHidden(false, animated: false)
        /* setNavigationBarHidden говорит о том, что когда мы переходим с Вью
         у которого НавБар уже скрыт(в результате прокрутки), то на нашем
         Вью НавБар всё же присутствует*/
    }
    
    
    // загрузка Вью
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // формирование кнопок всех сразу
        let buttonArray = [rateButton, mapButton]
        for button in buttonArray {
            guard let button = button else { break }
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
        }
        
        
        
        // возможность растягивать ячейку автоматически при большом тексте
        tabelView.estimatedRowHeight = 38 // оценочная высота строки (равная высоте ячейки)
        tabelView.rowHeight = UITableViewAutomaticDimension // автоматическое растягивание
        
        imageView.image = UIImage(data: restaurant!.image! as Data) // установка картинки
        
        tabelView.tableFooterView = UIView(frame: CGRect.zero) /* футер, тот что ниже ячеек
         устанавливается в ноль, что б не отображались пустые ячейки ТайблаВью*/
        
        title = restaurant?.name // установка названия ресторана на титул
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EateryDitailTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Name"
            cell.valueLabel.text = restaurant?.name
        case 1:
            cell.textLabel?.text = "Type"
            cell.valueLabel.text = restaurant?.type
        case 2:
            cell.textLabel?.text = "Location"
            cell.valueLabel.text = restaurant?.location
        case 3:
            cell.textLabel?.text = "Is visit?"
            cell.valueLabel.text = (restaurant?.isVisited)! ? "Yes" : "No"
        default:
            break
        }
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // Экшн для сегвея покидания Вью "Как Вам у нас?".
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
       // Перевод изображения на кнопку-смайлик
        guard let svc = segue.source as? RateViewController else { return } // получаем контроллер с которого переехали
        guard let rating = svc.restRating else { return } /* получаем restRating с этого контроллера,
         то есть название кнопки и одновременно идентификатор изображения для кнопки*/
        rateButton.setImage(UIImage(named: rating), for: .normal) // устанавливаем картинку на кнопку
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapSegue" {
            let dvc = segue.destination as! MapViewController
            dvc.restaurant = self.restaurant
        }
    }
    
}
