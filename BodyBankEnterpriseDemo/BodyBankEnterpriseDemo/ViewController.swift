//
//  ViewController.swift
//  BodyBankEnterpriseDemo
//
//  Created by Shunpei Kobayashi on 2018/10/15.
//  Copyright © 2018 Shunpei Kobayashi. All rights reserved.
//

import UIKit
import BodyBankEnterprise

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        makeRequest()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        BodyBankEnterprise.subscribeUpdateOfEstimationRequests { (request, errors) in
            print(request)
        }
    }
    
    func makeFetch(){
        BodyBankEnterprise.listEstimationRequests(limit: 20, nextToken: nil, callback: { (requests, nextToken, errors) in
            print(requests)
        })
    }
    
    

    func makeRequest(){
        var params = EstimationParameter()
        params.frontImage = UIImage(named: "logo")
        params.sideImage = UIImage(named: "logo")
        params.heightInCm = 180
        params.weightInKg = 90
        params.age = 30
        params.gender = .male
        BodyBankEnterprise.createEstimationRequest(estimationParameter: params, callback: { (request, errors) in
            if let request = request, let id = request.id{
                print(id) // id can be used to track estimation request
                BodyBankEnterprise.listEstimationRequests(limit: nil, nextToken: nil, callback: { (requests, nextToken, errors) in
                    if let requests = requests{
                        print(requests)
                    }
                })
                
                BodyBankEnterprise.getEstimationRequest(id: id, callback: { (request, errors) in
                    if let _ = request{
                        // Do something with request
                    }
                })
                
                BodyBankEnterprise.subscribeUpdateOfEstimationRequests(callback: { (request, errors) in
                    print(request)
                    print(errors)
                })
            }else if let errors = errors{
                errors.forEach({ (error) in
                    print(error.localizedDescription)
                })
            }else{
                print("fail")
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        BodyBankEnterprise.unsubscribeEstimationRequests()
    }
    

}

