//
//  PutObjectsOnFlootVC.swift
//  ARSections
//
//  Created by Rageeni Jadam on 26/07/18.
//  Copyright © 2018 Rageeni Jadam. All rights reserved.
//

import UIKit
import ARKit

class PutObjectsOnFloorVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var lblPlaneDetected: UILabel!
    
    let config = ARWorldTrackingConfiguration()
    var objects:NSArray! = nil
    var selectedItem: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objects = ["Cup", "Vase", "Boxing", "Table"]
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        sceneView.delegate = self
        config.planeDetection = .horizontal
        sceneView.autoenablesDefaultLighting = true //automatically adds lights to a scene
        sceneView.session.run(config)
        
        //tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler(tap:)))
        sceneView.addGestureRecognizer(tapGesture)
        registerPinchGesture()
        registerLongPress()
    }
    
    @objc func tapHandler(tap: UITapGestureRecognizer) {
        let location = tap.location(in: tap.view)
        let hitTest =  (tap.view as! ARSCNView).hitTest(location, types: .existingPlaneUsingExtent)
        if !hitTest.isEmpty {
            print("surface detected")
            addItem(hitResult: hitTest.first!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addItem(hitResult: ARHitTestResult) {
        if let selectedObject = selectedItem {
            let scence = SCNScene(named: "art.scnassets/\(selectedObject).scn")
            if scence != nil {
                print("\(selectedObject) added")
                let node = scence?.rootNode.childNode(withName: selectedObject, recursively: false)
                if selectedObject == "Table" { //because table pivot points is not in center of table
                    centerPivot(for: node!)
                }
                let transform = hitResult.worldTransform //The position and orientation of the hit test result relative to the world coordinate system
                //at 3 col = position
                let col3 = transform.columns.3
                node?.position = SCNVector3(col3.x, col3.y, col3.z)
                sceneView.scene.rootNode.addChildNode(node!)
            }
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
        cell.layer.cornerRadius = 6.0
        let lblItem: UILabel = cell.viewWithTag(1) as! UILabel
        lblItem.text = objects.object(at: indexPath.item) as? String
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        selectedItem = objects.object(at: indexPath.item) as! String
        cell?.backgroundColor = UIColor.green
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.orange
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else {
            return
        }
        DispatchQueue.main.async {
            self.lblPlaneDetected.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { //exceute after 3 sec from now
                self.lblPlaneDetected.isHidden = true
            })
        }
    }
    
    //pinch gesture for scaling objects
    func registerPinchGesture() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchHandler(pinch:)))
        sceneView.addGestureRecognizer(pinch)
    }
    
    @objc func pinchHandler(pinch: UIPinchGestureRecognizer) {
        let loc = pinch.location(in: (pinch.view as! ARSCNView))
        let hitTest = (pinch.view as! ARSCNView).hitTest(loc)
        if !hitTest.isEmpty {
            let node = hitTest.first?.node
            let pinchAction = SCNAction.scale(by: pinch.scale, duration: 0)
            print(pinch.scale)
            node?.runAction(pinchAction)
            pinch.scale = 1.0
        }
    }
    
    //long press gesture
    func registerLongPress() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressHandler(longPress:)))
        sceneView.addGestureRecognizer(longPress)
    }
    
    @objc func longPressHandler(longPress: UILongPressGestureRecognizer) {
        let location = longPress.location(in: (longPress.view as! ARSCNView))
        let hitTest = (longPress.view as! ARSCNView).hitTest(location)
        if !hitTest.isEmpty {
            if longPress.state == .began {
                let rotation = SCNAction.rotateBy(x: 0, y: CGFloat(360*(Double.pi/180)), z: 0, duration: 2)
                let forever = SCNAction.repeatForever(rotation)
                hitTest.first?.node.runAction(forever)
            } else if longPress.state == .ended {
                hitTest.first?.node.removeAllActions()
            }
        }
    }
    
    //set pivot point to center of node
    //pivot pts are not set via story board
    func centerPivot(for node: SCNNode) {
        let min = node.boundingBox.min
        let max = node.boundingBox.max
        node.pivot = SCNMatrix4MakeTranslation(
            min.x + (max.x - min.x)/2,
            min.y + (max.y - min.y)/2,
            min.z + (max.z - min.z)/2
        )
    }
}
