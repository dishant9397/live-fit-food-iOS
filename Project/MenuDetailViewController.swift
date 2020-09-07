//
//  MenuDetailViewController.swift
//  Project
//
//  Created by Dishant Patel on 2020-05-29.
//  Copyright © 2020 Dishant Patel. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import MapKit
import CoreLocation

class MenuDetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {
    
    //MARK-OUTLETS
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var scratchCardLabel: UILabel!
    @IBOutlet var tipTextbox: UITextField!
    @IBOutlet var tipSegment: UISegmentedControl!
    @IBOutlet var orderPickedButton: UIButton!
    @IBOutlet var placeOrderButton: UIButton!
    
    //MARK-VARIABLES
    var meal:Meal = Meal()
    var user:User = User()
    var order:Order = Order()
    var scratchCards:[ScratchCard] = [ScratchCard]()
    var locationManager:CLLocationManager?
    
    //MAIN FUNCTION
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialValues()
    }
    
    //MARK-ACTIONS
    //Action when segment of tip changes to adjust User Interface dynamically
    @IBAction func tipSegmentChanged(_ sender: Any) {
        if tipSegment.selectedSegmentIndex == 3 {
            tipTextbox.isEnabled = true
        }
        else {
            tipTextbox.isEnabled = false
        }
    }
    
    //Action when user presses place order button
    @IBAction func placeOrderButtonPressed(_ sender: Any) {
        var tip = 0.0
        if tipTextbox.isEnabled {
            tip = Double(tipTextbox.text!)!
        }
        else {
            if tipSegment.selectedSegmentIndex != -1 {
                tip = Double(tipSegment.titleForSegment(at: tipSegment.selectedSegmentIndex)!)!
            }
        }
        if scratchCards.count == 0 {
            order = saveOrder(discount: 0.0, tip: tip)
        }
        else {
            updateScratchCard(scratchCard: scratchCards[0])
            order = saveOrder(discount: Double(scratchCards[0].discount), tip: tip)
        }
        scratchCardLabel.text = ""
        scratchCardLabel.textColor = UIColor.black
        turnOnGeofence()
        placeOrderButton.isEnabled = false
        
    }
    
    //Function that sets the initial values
    func setInitialValues() {
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        mapView.delegate = self
        addPin()
        locationManager!.requestAlwaysAuthorization()
        locationManager!.startUpdatingLocation()
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        mapView.showsUserLocation = true
        let defaults = UserDefaults.standard
        meal = getData(mealId: Int16(defaults.integer(forKey: "mealId")))
        user = searchUser(email: defaults.string(forKey: "email")!)
        scratchCards = searchScratchCard(user:user)
        if scratchCards.count == 0 {
            scratchCardLabel.text = "Sorry!! There are no scratch cards for you"
            scratchCardLabel.textColor = UIColor.red
        }
        else {
            scratchCardLabel.text = "You have offer of \(scratchCards[0].discount)% off on this order."
            scratchCardLabel.textColor = UIColor.green
        }
        orderPickedButton.isEnabled = false
        tipTextbox.delegate = self
    }
    
    //Function to forward data to next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let orderSummaryViewController = segue.destination as! OrderSummaryViewController
        orderSummaryViewController.order = order
    }
    
    //Function called to minimize keyboard when clicked on return from keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Function that acts when there is any update in current location of user
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        getCurrentLocation()
    }
    
    //Function to get current location of user
    func getCurrentLocation() {
        let location = CLLocationCoordinate2D(latitude: locationManager!.location!.coordinate.latitude, longitude: locationManager!.location!.coordinate.longitude)
        let zoomLevel = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
        let region = MKCoordinateRegion(center: location, span: zoomLevel)
        mapView.setRegion(region, animated: true)
    }
    
    //Funtion to get particular meal from array
    func getData(mealId:Int16) -> Meal {
        var meals:[Meal] = [Meal]()
        let request : NSFetchRequest<Meal> = Meal.fetchRequest()
        let query = NSPredicate(format: "id == %i", mealId)
        request.predicate = query
        let db = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let results = try db.fetch(request)
            if results.count == 0 {
                print("No results found!!")
            }
            else {
                meals = results
            }
        }
        catch {
            print("Error searching for the data!!")
        }
        return meals[0]
    }
    
    //Funtion to search user on basis of email provided
    func searchUser(email:String) -> User {
        var users:[User] = [User]()
        let request : NSFetchRequest<User> = User.fetchRequest()
        let query = NSPredicate(format: "email == %@", email)
        request.predicate = query
        let db = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let results = try db.fetch(request)
            users = results
        }
        catch {
            print("Error searching for the data!!")
        }
        return users[0]
    }
    
    //Function to search for any particular active scratch card
    func searchScratchCard(user:User) -> [ScratchCard] {
        var scratchCards:[ScratchCard] = [ScratchCard]()
        let request : NSFetchRequest<ScratchCard> = ScratchCard.fetchRequest()
        let query = NSPredicate(format: "user == %@ AND isUsed == %i", user, 0)
        request.predicate = query
        let db = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let results = try db.fetch(request)
            if results.count == 0 {
                print("No results found!!")
            }
            else {
                scratchCards = results
            }
        }
        catch {
            print("Error searching for the data!!")
        }
        return scratchCards
    }
    
    //Function to update scratch card of
    func updateScratchCard(scratchCard:ScratchCard) {
        let request : NSFetchRequest<ScratchCard> = ScratchCard.fetchRequest()
        let query = NSPredicate(format: "scratchCardCode == %@", scratchCard.scratchCardCode)
        request.predicate = query
        let db = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let results = try db.fetch(request)
            if results.count == 0 {
                print("No results found!!")
            }
            else {
                results[0].isUsed = true
            }
        }
        catch {
            print("Error searching for the data!!")
        }
    }
    
    //Function to save order to datasbase
    func saveOrder(discount:Double, tip:Double) -> Order {
        let db = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let order = Order(context: db)
        order.user = user
        order.meal = meal
        order.date = Date()
        order.discount = (meal.price * discount) / 100
        if tipTextbox.isEnabled {
            order.tip = tip
        }
        else {
            order.tip = (meal.price * tip) / 100
        }
        order.tax = (meal.price - order.discount) * 0.13
        order.subTotal = order.tax + meal.price - order.discount + order.tip
        do {
            try db.save()
            let box = UIAlertController(
                title: "Order Placed",
                message: "Your order will be processed when you are 100 metres away from the store.",
                preferredStyle: .alert
            )
            box.addAction(
                UIAlertAction(title:"OK", style: .default, handler:nil)
            )
            self.present(box, animated:true)
        } catch  {
            print("Save Unsuccessful!!")
        }
        return order
    }
    
    //Function to add pin of Live Fit Food Store
    func addPin() {
        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: 43.7022, longitude: -79.529)
        pin.title = "Live Fit Food Store"
        mapView.addAnnotation(pin)
    }
    
    //Function to turn on geofencing
    func turnOnGeofence() {
        let center = CLLocationCoordinate2D(latitude: 43.7022, longitude: -79.529)
        let region = CLCircularRegion(center: center, radius: 100, identifier: "Store Location");
        region.notifyOnExit = true
        region.notifyOnEntry = true
        self.locationManager!.startMonitoring(for: region)
    }
    
    //Function that notifies location manager when user enters geofencing region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.scratchCardLabel.text = "Your order will be ready in 5 seconds!!"
        self.scratchCardLabel.textColor = UIColor.red
        var timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
            self.scratchCardLabel.text = "Your order is now ready for pickup"
            self.scratchCardLabel.textColor = UIColor.blue
            self.orderPickedButton.isEnabled = true
        }
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    }
    
    //Function that notifies location manager when user exits geofencing region
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    }
}
