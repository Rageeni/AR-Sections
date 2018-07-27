//
//  ViewController.swift
//  ARSections
//
//  Created by Rageeni Jadam on 18/07/18.
//  Copyright © 2018 Rageeni Jadam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func RenderSectionBtnAction(_ sender: Any) {
        performSegue(withIdentifier: "Renderer", sender: nil)
    }
    
    @IBAction func planetWorld(_ sender: Any) {
        performSegue(withIdentifier: "planets", sender: nil)
    }
    
    @IBAction func hitTestGame(_ sender: Any) {
        performSegue(withIdentifier: "hitTest", sender: nil)
    }
    
    @IBAction func planeDetection(_ sender: Any) {
        performSegue(withIdentifier: "planeDetection", sender: nil)
    }
    
    @IBAction func putObjects(_ sender: Any) {
        performSegue(withIdentifier: "putObjects", sender: nil)
    }
    
    @IBAction func vehicle(_ sender: Any) {
        performSegue(withIdentifier: "vehicle", sender: nil)
    }
    
}

