//
//  VehicleVC.swift
//  ARSections
//
//  Created by Rageeni Jadam on 27/07/18.
//  Copyright © 2018 Rageeni Jadam. All rights reserved.
//

import UIKit
import ARKit

class VehicleVC: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var scenceView: ARSCNView!
    
    let config = ARWorldTrackingConfiguration()

    override func viewDidLoad() {
        super.viewDidLoad()
        scenceView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        scenceView.delegate = self
        config.planeDetection = .horizontal
        scenceView.session.run(config)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AddVehicle(_ sender: Any) {
        //get current position of camera
        guard let pointOfView = scenceView.pointOfView else { return }
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let currentLocation = orientation + location
        let boxNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        boxNode.position = currentLocation
        
        //add SCNPhysicsBody to the node, by this node has garvity force etc
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: boxNode, options: [SCNPhysicsShape.Option.keepAsCompound : true]))
        boxNode.physicsBody = body //The physics body associated with the node.
        
        scenceView.scene.rootNode.addChildNode(boxNode)
    }
    
    func createFloor(anchor: ARPlaneAnchor) -> SCNNode {
        let node = SCNNode(geometry: SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z)))
        node.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "floor")
        node.geometry?.firstMaterial?.isDoubleSided = true
        node.position = SCNVector3(anchor.center.x, anchor.center.y, anchor.center.z)
        node.eulerAngles = SCNVector3(90*(Double.pi/180),0,0)
        
        //applied static phisics body on floor node
        let staticBody = SCNPhysicsBody.static() //Creates a physics body that is unaffected by forces or collisions and that cannot move. (support vehicle)
        node.physicsBody = staticBody
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        scenceView.scene.rootNode.addChildNode(createFloor(anchor: planeAnchor))
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        DispatchQueue.main.async {
            node.enumerateChildNodes { (childNode, _) in
                childNode.removeFromParentNode()
            }
        }
        scenceView.scene.rootNode.addChildNode(createFloor(anchor: planeAnchor))
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {
            node.enumerateChildNodes { (childNode, _) in
                childNode.removeFromParentNode()
            }
        }
    }
}
