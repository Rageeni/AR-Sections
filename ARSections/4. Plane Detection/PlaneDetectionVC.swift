//
//  PlaneDetectionVC.swift
//  ARSections
//
//  Created by Rageeni Jadam on 26/07/18.
//  Copyright © 2018 Rageeni Jadam. All rights reserved.
//

import UIKit
import ARKit

class PlaneDetectionVC: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    let config = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        sceneView.delegate = self
        config.planeDetection = .horizontal
        sceneView.session.run(config)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //called if any anchor(information, A real-world position and orientation that can be used for placing objects in an AR scene.) is added
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        print("Node Added")
        node.addChildNode(createFloor(anchor: planeAnchor))
    }
    
    //called when Added Anchor is updated
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        print("Node Updated")
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
        node.addChildNode(createFloor(anchor: planeAnchor))
    }
    
    //called when present ARAnchor is remove
    //so did remove gets called when the device makes an error and makes more than one airplane anchor for
    //the same horizontal surface.
    //Every horizontal surface should only have one airplane anchor.
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        print("Node Remove")
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
    }
    
    func createFloor(anchor: ARPlaneAnchor) -> SCNNode {
        let plane = SCNNode(geometry: SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z)))
        plane.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "floor")
        plane.geometry?.firstMaterial?.isDoubleSided = true
        plane.position = SCNVector3(anchor.center.x,anchor.center.y,anchor.center.z)
        plane.eulerAngles = SCNVector3(90*(Double.pi/180),0,0)
        return plane
    }

}
