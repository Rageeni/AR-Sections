//
//  RendererDelegateVC.swift
//  ARSections
//
//  Created by Rageeni Jadam on 18/07/18.
//  Copyright © 2018 Rageeni Jadam. All rights reserved.
//

import UIKit
import ARKit

class RendererDelegateVC: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var btnDraw: UIButton!
    
    let config = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
        sceneView.showsStatistics = true //show statistics info like fps, scence render performance
        sceneView.session.run(config)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func resetDrawingAction(_ sender: Any) {
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
    }
    
    @IBAction func backAction(_: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //called 60 times in sec (60 fps)
    //Anything inside this delegate functions happens in the background.
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        //sceneView.pointOfView Contains current location and orientation of camera view (in transform of matrix )
        //combine current location and orientation we get current position of camera view
        
        guard let pointOfView = sceneView.pointOfView else { return }
        let transform = pointOfView.transform
        //oriention are in 3 col of transform matrix and at 1 row of 3 col represet x field, y field - 3 col 2 row, z field - 3 col 3 row
        
        //when print orienation value then right side of x axis is nagative and left side is positive same with y and z axis
        //let orientation = SCNVector3(transform.m31, transform.m32, transform.m33)
        //so we put -ve
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)//rotation the phone around itself where the phone is facing, When you're not actually moving the phone to a new location
        
        //location are in 4 col of transform matrix and at 1 row of 4 col represet x field, y field - 4 col 2 row, z field - 4 col 3 row
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)//location is when the phone actually changes location like so when it moves
        
        //Position = Orientation + Location
        let currentPosition = orientation + location //have to override + operator
        DispatchQueue.main.async {
            //if btn pressed then draw
            if self.btnDraw.isHighlighted {
                let node = SCNNode(geometry: SCNSphere(radius: 0.01))
                node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
                node.position = currentPosition
                self.sceneView.scene.rootNode.addChildNode(node)
            } else { //else show only pointer
                let pointer = SCNNode(geometry: SCNSphere(radius: 0.009))
                pointer.name = "pointer"
                pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
                pointer.position = currentPosition
                //remove pervious pointer before add new
                self.sceneView.scene.rootNode.enumerateChildNodes { (node,_) in
                    if node.name == "pointer" {
                        node.removeFromParentNode()
                    }
                }
                self.sceneView.scene.rootNode.addChildNode(pointer)
            }
        }
    }
}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}
