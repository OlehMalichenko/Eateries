//
//  RateViewController.swift
//  Eateries
//
//  Created by OlehMalichenko on 06.12.2017.
//  Copyright © 2017 OlehMalichenko. All rights reserved.
//

import UIKit
import CoreData

// подвязан ко View "Как Вам у нас?"
class RateViewController: UIViewController {

    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var badButton: UIButton!
    @IBOutlet weak var goodButton: UIButton!
    @IBOutlet weak var brilliantButton: UIButton!
    
    // переезд при нажатии на каждую кнопку
    var restRating: String? // для установки названия кнопки
    /* экшн для формирования названия кнопки при её нажатии
     перед этим для каждой кнопки установлен соотвествующий тэг*/
    
    
    @IBAction func rateRestaurant(sender: UIButton) {
        switch sender.tag {
        case 0: restRating = "bad"
        case 1: restRating = "good"
        case 2: restRating = "brilliant"
        default: break
        }
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            let restaurant = Restaurant(context: context)
            if let image = UIImage(named: restRating!) {
                restaurant.rating = UIImagePNGRepresentation(image)
            }
            
            do {
              try context.save()
                print("картинка сохранилась")
            } catch {
                print(error.localizedDescription)
            }
            
        }
        
        /* метод переезда по указанному сегвею
         используется идентификатор уже ранее созданного сегвея покидания
         после срабатывает метод в EateryDitailViewController, а именно
         unwindSegue, подвязанный под сегвей*/
        performSegue(withIdentifier: "unwindSegueToDVC", sender: sender)
    }
    
    // вызывается когда Вью уже загружен
    override func viewDidAppear(_ animated: Bool) {
//        /* Анимация со Стеком целиком
//         описывающее суть замыкания */
//        UIView.animate(withDuration: 2.0) {
//            self.ratingStackView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//            /* сама суть замыкания: копируется состояние имеющееся во  viewDidLoad
//             при загрузке Вью с нулевыми показателями, а потом эти показатели устанавливаются в 1 (то есть в реальный размер)*/
//        }
        
        // Анимация с отдельными кнопками
        let buttonArray = [badButton, brilliantButton, goodButton] // массив кнопок
        // цикл для получения каждой кнопки
        for (index, button) in buttonArray.enumerated() {
            let delay = Double(index) * 0.2 // задержка при анимации в зависимости от места в массиве
            // метод анимации
            UIView.animate(withDuration: 0.3, // время за которое должна прйти анимация
                           delay: delay, // задержка анимации
                           options: .curveEaseIn, // способ анимации
                           animations: { button?.transform = CGAffineTransform(scaleX: 1, y: 1) }, // замыкание с параметрами объектов для анимации
                           completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        // для Aнимации: установка начального значения кнопок (на 0)
//        ratingStackView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        /* для анимаци. установка стартового значения кнопок
         для использования в анимации */
        badButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        goodButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        brilliantButton.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        //MARK: Блюр-Эффект
        // создание блюр-эффекта поверх фоновой картинки
        let blurEffect = UIBlurEffect(style: .light) // создаётся сам стиль эффекта
        let blurEffectView = UIVisualEffectView(effect: blurEffect) // создаётся ссамо блюр-эффект View
        blurEffectView.frame = self.view.bounds // задаются рамки блюр-эффект View, которые равняются рамкам основной View
        blurEffectView.autoresizingMask = [.flexibleHeight, .flexibleWidth] // возможность изменения размеров блюра при переходе в ландшафтный режим
        self.view.insertSubview(blurEffectView, at: 1) // установка ко основному View, блюровского сабВью на позицию один (тоесть вторую после 0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
