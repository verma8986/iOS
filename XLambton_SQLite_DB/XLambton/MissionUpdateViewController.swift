//
//  MissionUpdateViewController.swift
//  XLambton
//
//  Created by Sonal Verma on 2018-08-10.
//  Copyright © 2018 Sonal Verma. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import MessageUI

class MissionUpdateViewCell: UITableViewCell {
    
    @IBOutlet weak var ownerImageView: UIImageView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var agentImageView: UIImageView!
    @IBOutlet weak var lblAgentName: UILabel!
    @IBOutlet weak var lblKM: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var MailImageView: UIImageView!
    @IBOutlet weak var cameraImageView: UIImageView!
}

class MissionUpdateViewController: UIViewController,  UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,  MFMailComposeViewControllerDelegate  {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
   
    
    var encryption:Encryption = Encryption()
    var tableCell:MissionUpdateViewCell = MissionUpdateViewCell()
    var mapManager = CLLocationManager()
    
    var agents: [Agent] = []
    var db: DBManager?
    
    var countryMissionI: [String] = []
    var countryMissionR: [String] = []
    var countryMissionP: [String] = []
    var countryArrayRed: [String] = []
    var countryArrayGreen: [String] = []
    var countryArrayBlue: [String] = []
    var locationArray: [CLLocationCoordinate2D] = []
    var mylocation:CLLocation!
    var emailI:[String] = []
    var emailR:[String] = []
    var emailP:[String] = []
    var lat = Double()
    var lng = Double()
   
 
    
    override func viewWillAppear(_ animated: Bool){
        self.tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        mapView.delegate = self
        
        self.navigationItem.title = "Mission Update"
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.reloadData()
        
        
        // Ask for Authorisation from the User.
        self.mapManager.requestAlwaysAuthorization()
        self.mapManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            mapManager.delegate = self
            mapManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            mapManager.startUpdatingLocation()
        }
//        mapView.isZoomEnabled = true
//        mapView.isScrollEnabled = true
        
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            
            mylocation = mapManager.location
            lat = mylocation.coordinate.latitude
            lng = mylocation.coordinate.longitude
            print(mylocation.coordinate.latitude)
            print(mylocation.coordinate.longitude)
            
        }
        
        db = DBManager()
        agents.removeAll()
        if let db = db {
            agents = db.readValues()
        }
      
        (countryMissionI, countryMissionR, countryMissionP) = fetchCountry()
        dump(countryMissionI)
        dump(countryMissionR)
        dump(countryMissionP)
        
        getCountry()
    }
    
    func getCountry(){
        let countryMissionIString = countryMissionI.joined(separator: "-")
        print("Country:", countryMissionIString)
        let countryMissionRString = countryMissionR.joined(separator: "-")
        print("Country:", countryMissionRString)
        let countryMissionPString = countryMissionP.joined(separator: "-")
        print("Country:", countryMissionPString)
        
        let countryMissionIDecrypted = encryption.decrypt(countryMissionIString)
        print(countryMissionIDecrypted)
        let countryMissionRDecrypted = encryption.decrypt(countryMissionRString)
        print(countryMissionRDecrypted)
        let countryMissionPDecrypted = encryption.decrypt(countryMissionPString)
        print(countryMissionPDecrypted)
        
        let arrayCountryMissionI = countryMissionIDecrypted.components(separatedBy: " ").dropLast()
        print(arrayCountryMissionI)
        let arrayCountryMissionR = countryMissionRDecrypted.components(separatedBy: " ").dropLast()
        print(arrayCountryMissionR)
        let arrayCountryMissionP = countryMissionPDecrypted.components(separatedBy: " ").dropLast()
        print(arrayCountryMissionP)
        
        var i = true
        
        while i {
            for eachCountry in arrayCountryMissionI{
                getCoordinateFrom(address: eachCountry) { coordinate, error in
                    guard let coordinate = coordinate, error == nil else { return }
                    // don't forget to update the UI from the main thread
                    DispatchQueue.main.async {
                        var locationArray: [CLLocationCoordinate2D] = []
                        print(coordinate) // CLLocationCoordinate2D(latitude: -22.910863800000001, longitude: -43.204543600000001)
                        locationArray = [(coordinate)]
                        dump(locationArray)
                        
                        let annotation = MKPointAnnotation()
                        annotation.title = "I"
                        annotation.coordinate = locationArray[0]
                        self.mapView.addAnnotation(annotation)
                    }
                } // getCoordinateFrom func
            } //For loop ends
            
            i = false
        }
        
        var j = true
        while j {
            for eachCountry in arrayCountryMissionR{
                getCoordinateFrom(address: eachCountry) { coordinate, error in
                    guard let coordinate = coordinate, error == nil else { return }
                    // don't forget to update the UI from the main thread
                    DispatchQueue.main.async {
                        var locationArray: [CLLocationCoordinate2D] = []
                        print(coordinate) // CLLocationCoordinate2D(latitude: -22.910863800000001, longitude: -43.204543600000001)
                        locationArray = [(coordinate)]
                        dump(locationArray)
                        
                        let annotation = MKPointAnnotation()
                        annotation.title = "R"
                        annotation.coordinate = locationArray[0]
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
            j = false
        }
        
        var k = true
        while k {
            for eachCountry in arrayCountryMissionP{
                getCoordinateFrom(address: eachCountry) { coordinate, error in
                    guard let coordinate = coordinate, error == nil else { return }
                    // don't forget to update the UI from the main thread
                    DispatchQueue.main.async {
                        var locationArray: [CLLocationCoordinate2D] = []
                        print(coordinate) // CLLocationCoordinate2D(latitude: -22.910863800000001, longitude: -43.204543600000001)
                        locationArray = [(coordinate)]
                        dump(locationArray)
                        
                        let annotation = MKPointAnnotation()
                        annotation.title = "P"
                        annotation.coordinate = locationArray[0]
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
            k = false
        }
        
    }
    
    func fetchCountry() -> ([String], [String], [String]) {
        
        for value in agents{
            print(value.country)
            print(value.mission)
            if(value.mission == "23|"){
                countryArrayRed += [value.country]
            }else if(value.mission == "61|"){
                countryArrayGreen += [value.country]
            }else if(value.mission == "53|"){
                countryArrayBlue += [value.country]
            }
        }
        return (countryArrayRed, countryArrayGreen, countryArrayBlue)
    }
    
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            completion(placemarks?.first?.location?.coordinate, error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userlocation:CLLocation = locations.last!
        print("MANAGER", userlocation)
//        let mylocation = CLLocationCoordinate2D(latitude: userlocation.coordinate.latitude, longitude: userlocation.coordinate.longitude)
//        print("MYLOCATION", mylocation)
//        dump(mylocation)
        
        let worldRegion = MKCoordinateRegionForMapRect(MKMapRectWorld);
        mapView.region = worldRegion;
        mapView.showsUserLocation = true
    }
    
    func calcDistance() -> [String]{
        
        var allCountryArray : String = ""
        var allAgentCountries = [String]()
    
//        mylocation = CLLocation( latitude: UserDefaults.standard.value(forKey: "LAT") as! CLLocationDegrees,  longitude: UserDefaults.standard.value(forKey: "LON") as! CLLocationDegrees)
        if(lat == 0 && lng == 0){
            lat = 43.7732693
            lng = -79.4059208
        }
        mylocation = CLLocation( latitude: lat,  longitude: lng)
        print("MYLOCATON", mylocation!)
        
        let afghanistanCLLocation: CLLocation =  CLLocation(latitude: 34.543896, longitude: 69.160652)
        let australiaCLLocation: CLLocation =  CLLocation(latitude: -33.865143, longitude: 151.209900)
        let bangladeshCLLocation: CLLocation =  CLLocation(latitude: 23.777176, longitude: 90.399452)
        let brazilCLLocation: CLLocation =  CLLocation(latitude: -23.533773, longitude: -46.625290)
        let canadaCLLocation: CLLocation =  CLLocation(latitude: 55.585901, longitude: -105.750596)
        let franceCLLocation: CLLocation =  CLLocation(latitude: 47.824905, longitude: 2.618787)
        let germanyCLLocation: CLLocation =  CLLocation(latitude: 51.133481, longitude: 10.018343)
        let indiaCLLocation: CLLocation =  CLLocation(latitude: 22.199166, longitude: 78.476681)
        let japanCLLocation: CLLocation =  CLLocation(latitude: 36.386493, longitude: 138.59223)
        let singaporeCLLocation: CLLocation =  CLLocation(latitude: 1.351616, longitude: 103.808053)
        let southafricaCLLocation: CLLocation =  CLLocation(latitude: -28.378272, longitude: 23.913711)
        
        for value in agents{
            allAgentCountries += [value.country]
        }
        
        print("allAgentCountries", allAgentCountries)
        let allCountryString = allAgentCountries.joined(separator: "-")
        let allCountryDecrypted = encryption.decrypt(allCountryString)
        let arrayAllCountry = allCountryDecrypted.components(separatedBy: " ").dropLast()
        print("arrayAllCountry", arrayAllCountry)
        for allCountries in arrayAllCountry{
            
            switch allCountries{
                case "afghanistan":
                    allCountryArray +=  String((mylocation?.distance(from: afghanistanCLLocation))!/1000) + "-"
                    break
                case "australia":
                    allCountryArray +=  String((mylocation?.distance(from: australiaCLLocation))!/1000) + "-"
                    break
                case "bangladesh":
                    allCountryArray +=  String((mylocation?.distance(from: bangladeshCLLocation))!/1000) + "-"
                    break
                case "brazil":
                    allCountryArray +=  String((mylocation?.distance(from: brazilCLLocation))!/1000) + "-"
                    break
                case "canada":
                    allCountryArray +=  String((mylocation?.distance(from: canadaCLLocation))!/1000) + "-"
                    break
                case "france":
                    allCountryArray +=  String((mylocation?.distance(from: franceCLLocation))!/1000) + "-"
                    break
                case "germany":
                    allCountryArray +=  String((mylocation?.distance(from: germanyCLLocation))!/1000) + "-"
                    break
                case "india":
                    allCountryArray +=  String((mylocation?.distance(from: indiaCLLocation))!/1000) + "-"
                    break
                case "japan":
                    allCountryArray +=  String((mylocation?.distance(from: japanCLLocation))!/1000) + "-"
                    break
                case "singapore":
                    allCountryArray +=  String((mylocation?.distance(from: singaporeCLLocation))!/1000) + "-"
                    break
                case "southafrica":
                    allCountryArray +=  String((mylocation?.distance(from: southafricaCLLocation))!/1000) + "-"
                    break
                default:
                    print("Country Invalid")
                    break
            }
        }
        let finalDistance = allCountryArray.components(separatedBy: "-").dropLast()
        print("finalDistance",finalDistance)
        return Array(finalDistance)
    }
    
    func sendEmailBody(receipients: String){
        let emailDecrypted = encryption.decrypt(receipients)
        print("emailDecrypted",emailDecrypted)
        if(MFMailComposeViewController.canSendMail()){
            print("Can Send Mail")
            
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients([emailDecrypted])
            
            composeVC.setSubject("Live Image")
            composeVC.setMessageBody("Message content.", isHTML: false)
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "MissionUpdateCell", for: indexPath)
            as! MissionUpdateViewCell
        let agent = agents[indexPath.row]
        
        if(agent.mission == "23|"){
            cell.agentImageView?.image = UIImage(named: "agentRed")
            cell.cameraImageView?.image = UIImage(named: "camerared")
            cell.MailImageView?.image = UIImage(named: "mailred")
            cell.lblAgentName.text = agent.name

        }else if(agent.mission == "61|"){
            cell.agentImageView?.image = UIImage(named: "agentGreen")
            cell.cameraImageView?.image = UIImage(named: "cameragreen")
            cell.MailImageView?.image = UIImage(named: "mailgreen")
            cell.lblAgentName.text = agent.name

        }else if(agent.mission == "53|"){
            cell.agentImageView?.image = UIImage(named: "agentBlue")
            cell.cameraImageView?.image = UIImage(named: "camerablue")
            cell.MailImageView?.image = UIImage(named: "mailblue")
            cell.lblAgentName.text = agent.name
        }
        
        let distances = calcDistance()
        print("distances", distances)
        cell.lblDistance.text = distances[indexPath.row]
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        cell.cameraImageView.isUserInteractionEnabled = true
        cell.cameraImageView.tag = indexPath.row
        cell.cameraImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let tapMail = UITapGestureRecognizer(target: self, action: #selector(mailTapped(tapGestureRecognizer:)))
        cell.MailImageView.addGestureRecognizer(tapMail)
        cell.MailImageView.isUserInteractionEnabled = true
        return cell
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            UIImageWriteToSavedPhotosAlbum(pickedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            dismiss(animated: true, completion: nil)
        }
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

    @objc func mailTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if tapGestureRecognizer.state == UIGestureRecognizerState.ended {
            let tapLocation = tapGestureRecognizer.location(in: self.tableView)
            if let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation) {
                if (self.tableView.cellForRow(at: tapIndexPath) as? MissionUpdateViewCell) != nil {
                    let agentMail = agents[tapIndexPath.row]
                    print("agentMail",agentMail.email, tapIndexPath.row)
                    sendEmailBody(receipients: agentMail.email)
                }
            }
        }
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MissionUpdateViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
            
        else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            print(annotation.title!!)
            if(annotation.title!! == "I"){
                annotationView.tintColor = .red
                print(annotationView.tintColor)
            }else if(annotation.title!! == "R"){
                annotationView.tintColor = .blue
            }else if(annotation.title!! == "P"){
                annotationView.tintColor = .green
            }
            return annotationView
        }
    }
}


