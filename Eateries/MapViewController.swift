//
//  MapViewController.swift
//  Eateries
//
//  Created by OlehMalichenko on 07.12.2017.
//  Copyright © 2017 OlehMalichenko. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // аутлет для Вью на который переходим по кнопке "карта"
    @IBOutlet weak var mapView: MKMapView!
    
    // укземпляр структуры для получения выбранного ресторана
    var restaurant: Restaurant!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // MARK: Геопозиция
        // Процесс получения геопозиции и отображения её аннотации во Вью
        let geocoder = CLGeocoder() // создаётся экземпляр класса CLGeocoder (для трансформации в координаты)
        
        /* с помощью метода geocodeAddressString получаем из String позицию (placemarks)
         и работаем с этой позицией в замыкании*/
        geocoder.geocodeAddressString(restaurant.location!) { (placemarks, error) in
            guard error == nil else {return} // проверяем нет ли ошибки получения данных
            guard let placemarks = placemarks else {return} // переводим из опционального placemarks в неопциональный
            let placemark = placemarks.first! // поскольку placemarks это массив, получаем первый эллемент
            
            // создание аннотации (значёк на карте) и заводим в title и subtitle необходмые данные
            let anotation = MKPointAnnotation()
            anotation.title = self.restaurant.name
            anotation.subtitle = self.restaurant.type
            
            guard let location = placemark.location else {return} // получаем локацию (если она есть)
            anotation.coordinate = location.coordinate // и заводим эту локацию в аннотацию
            
            // говорим Вью отобразить аннотацию и развернуть её сразу для показа
            self.mapView.showAnnotations([anotation], animated: true)
            self.mapView.selectAnnotation(anotation, animated: true)
        } // тут заканчивается замыкание передаваемое в метод geocodeAddressString
    }

    
    // метод протокола MKMapViewDelegate для создания аннотации с изображением
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {return nil} // проверяем не является ли входящие в метод данные местоположением пользователя
        
        let annotationIdentifier = "restAnnotation" // создаётся идентификатор для повторного использования аннотации
        
        // создаём аннотацию через повторное использование выбывших аннотаций с соотвествующим идентификатором
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        // если выбывших аннотаций для повторного использвоания нет - создаём аннотацию
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true // возможность включать в аннотацию дополнительные данные
        }
        
        let rightImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) // создаём вью для изображения, котороре будет вставляться в аннотацию
        rightImage.image = UIImage(data: restaurant.image! as Data) // вставляем в это вью изображение соотвествующего ресторана
        
        annotationView?.rightCalloutAccessoryView = rightImage // вставляем вью с изображением в правую часть аннотации
        
        annotationView?.tintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) // меняем цвет иголочки
        
        return annotationView
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
