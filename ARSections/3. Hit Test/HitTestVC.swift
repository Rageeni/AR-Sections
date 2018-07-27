//
//  HitTestVC.swift
//  ARSections
//
//  Created by Rageeni Jadam on 23/07/18.
//  Copyright © 2018 Rageeni Jadam. All rights reserved.
//

import UIKit
import ARKit
import Each

class HitTestVC: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var btnPlay: UIButton!
    @IBOutlet var btnStop: UIButton!
    @IBOutlet var lblTimer: UILabel!
    @IBOutlet var lblScore: UILabel!
    
    let config = ARWorldTrackingConfiguration()
    var timer = Each(1).seconds
    var counter = 10
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let touchGesture = UITapGestureRecognizer(target: self, action: #selector(touchHandler(tap:)))
        sceneView.addGestureRecognizer(touchGesture)
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
        sceneView.session.run(config)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func touchHandler(tap: UITapGestureRecognizer) {
        let sceceViewTappedOn = tap.view as! SCNView
        let res = sceceViewTappedOn.hitTest(tap.location(in: sceceViewTappedOn))
        let node = res.first?.node
        if res.count > 0 && node!.animationKeys.isEmpty && counter > 0 { // or !res.isEmpty
            SCNTransaction.begin()// SCNTransaction:- control the animation
            animationOfNode(node: node!)
            SCNTransaction.completionBlock = {
                node?.removeFromParentNode()
                self.addNode()
                self.resetTimer()
                self.showScore()
            }
            SCNTransaction.commit()
        }
    }
    
    @IBAction func backAction(_: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playAction() {
        setTimer()
        addNode()
        btnPlay.isEnabled = false
    }
    
    @IBAction func stopAction() {
        timer.stop()
        resetTimer()
        btnPlay.isEnabled = true
        lblTimer.text = "Let's Play"
        score = 0
        lblScore.text = "Score:- \(self.score)"
        DispatchQueue.main.async {
            self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                node.removeFromParentNode()
            }
        }
    }
    
    func addNode() {
        let star = SCNScene(named: "art.scnassets/Jellyfish.scn")
        if star != nil {
            let node = star?.rootNode.childNode(withName: "Jellyfish", recursively: false)
            node?.position = SCNVector3(x: Float(randomNumbers(firstNum: -0.1, secondNum: 0.1)), y: Float(randomNumbers(firstNum: -0.1, secondNum: 0.1)), z: Float(randomNumbers(firstNum: -0.1, secondNum: 0.1)))
            sceneView.scene.rootNode.addChildNode(node!)
        }
    }
    
    func randomNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    func animationOfNode(node: SCNNode) {
        let spin = CABasicAnimation(keyPath: "position")
        spin.fromValue = node.presentation.position
        spin.toValue = SCNVector3(x: node.presentation.position.x - 0.01, y: node.presentation.position.y - 0.01, z: node.presentation.position.z - 0.01)
        spin.duration = 0.1
        spin.repeatCount = 5
        spin.autoreverses = true
        node.addAnimation(spin, forKey: "position")
    }
    
    func setTimer() {
        timer.perform { () -> NextStep in
            self.counter -= 1
            if self.counter == 0 {
                self.lblTimer.text = "You Lose"
                return .stop
            } else {
                self.lblTimer.text = "\(self.counter)"
            }
            return .continue
        }
    }
    
    func resetTimer() {
        counter = 10
        lblTimer.text = "\(counter)"
    }
    
    func showScore() {
        score += 1
        lblScore.text = "Score:- \(score)"
    }
    
}
