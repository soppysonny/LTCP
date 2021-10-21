//
//  ViewController.swift
//  SwifyLiteCoinPool
//
//  Created by zhang ming on 2021/10/21.
//

import UIKit
import Alamofire
let baseUrl = "https://www.litecoinpool.org/api?api_key="

class ViewController: UIViewController {
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var totalMhLb: UILabel!
    @IBOutlet weak var errLb: UILabel!
    @IBOutlet weak var setapiBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        
        guard let key = UserDefaults.standard.value(forKey: "key") as? String else {
            return
        }
        
        textfield.placeholder = key
        launchTimer()
    }
    

    @IBAction func setApiKey(_ sender: Any) {
        guard let key = textfield.text,
              !key.isEmpty else {
            return
        }
        saveNewApiKey(key)
    }
    
    func launchTimer() {
        let timer = Timer(fire: Date(), interval: 10, repeats: true, block: {_ in
            self.request()
        })
        
        RunLoop.current.add(timer, forMode: .common)
        timer.fire()
    }
    
    func saveNewApiKey(_ key: String) {
        UserDefaults.standard.setValue(key, forKey: "key")
        textfield.placeholder = key
        textfield.text = nil
        launchTimer()
    }

    
    func request() {
        guard let key = UserDefaults.standard.value(forKey: "key") as? String,
              let url = URL(string: baseUrl + key) else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            do {
                let model = try LTCPModel.decode(data: data)
                DispatchQueue.main.async {
                    self.setViewDetailWithModel(model)
                }
            } catch let error {
                print(error)
                self.view.backgroundColor = .white
                self.errLb.text = error.localizedDescription
            }
        }
        task.resume()
    }
    
    func setViewDetailWithModel(_ model: LTCPModel) {
        print(model)
        let mhCount = model.user.hash_rate / 1000
        totalMhLb.text = "\(mhCount)"
        let isMhLow = mhCount < 3800
        let isDisconnected = model.workers.values.contains(where: {
            $0.connected == false
        })
        var isWorkerLow = false
        model.workers.forEach {
            if isWorkerLow {
                return
            }
            guard let mh = self.workerLowDict[$0.key] else {
                return
            }
            isWorkerLow = Double(mh) * Double(1000000) > $0.value.hash_rate
        }
        if isMhLow || isDisconnected || isWorkerLow {
            view.backgroundColor = .white
            self.textfield.isHidden = false
            self.setapiBtn.isHidden = false
            self.errLb.isHidden = false
        } else {
            view.backgroundColor = .black
            self.textfield.isHidden = true
            self.setapiBtn.isHidden = true
            self.errLb.isHidden = true
        }
    }
    
    var workerLowDict: [String: Int] = [
        "soppysonny.01": 400,
        "soppysonny.02": 100,
        "soppysonny.03": 400,
        "soppysonny.04": 400,
        "soppysonny.05": 400,
        "soppysonny.06": 150,
        "soppysonny.07": 400,
        "soppysonny.08": 400,
        "soppysonny.09": 400,
        "soppysonny.10": 470,
    ]

}
