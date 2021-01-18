//
//  ViewController.swift
//  CoronaApp
//
//  Created by Gustavo Feliciano Figueiredo on 15/01/21.
//  Copyright © 2021 Gustavo Feliciano Figueiredo. All rights reserved.
//

import UIKit


struct Response: Decodable {
    let country: String
    let cases: Int
    let deaths: Int
    let todayCases: Int
    let todayDeaths: Int
}

class ViewController: UIViewController {
    
    @IBOutlet weak var casesNumberLabel: UILabel!
    @IBOutlet weak var deathsNumberLabel: UILabel!
    @IBOutlet weak var casesTodayNumberLabel: UILabel!
    @IBOutlet weak var deathsTodayNumberLabel: UILabel!
    @IBOutlet weak var segmentedControll: UISegmentedControl!
    var response: Response?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        makeRequestAndUpdateView(countryName: "Brazil")
    }
    
    func setDataInView(){
        guard let response = response else { return }
        UIView.animate(withDuration: 3, animations: {
            self.casesNumberLabel.text = String(response.cases)
            self.deathsNumberLabel.text = String(response.deaths)
            self.casesTodayNumberLabel.text = String(response.todayCases)
            self.deathsTodayNumberLabel.text = String(response.todayDeaths)
            self.reloadInputViews()
        })
    }
    
    func makeRequestAndUpdateView(countryName: String){
        self.requestStateCovidInBrazil(countryName: countryName, completion: { response in
            self.response = response
            DispatchQueue.main.async {
                self.setDataInView()
                
            }
        })
    }
    
    @IBAction func changeCases(_ sender: Any) {
        switch self.segmentedControll.selectedSegmentIndex {
        case 0:
            makeRequestAndUpdateView(countryName: "Brazil")
        default:
            makeRequestAndUpdateView(countryName: "USA")
        }
    }
    
}

extension ViewController{
    func requestStateCovidInBrazil(countryName: String,completion: @escaping (Response) -> Void){
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://corona.lmao.ninja/v2/countries/\(countryName)")!
        let task = session.dataTask(with: url){
            (data, response, error) in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(Response.self, from: data)
                    completion(response)
                } catch let error {
                    print(error)
                }
            }
        }
        task.resume()
    }
}

