//
//  PlanetWorldVC.swift
//  ARSections
//
//  Created by Rageeni Jadam on 19/07/18.
//  Copyright © 2018 Rageeni Jadam. All rights reserved.
//

import UIKit
import ARKit

class PlanetWorldVC: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var btnCollection: [UIButton]!
    let config = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
        sceneView.autoenablesDefaultLighting = true
        sceneView.session.run(config)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backAction(_: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AddPlanets(_ sender: Any) {
        switch (sender as! UIButton).tag {
        case 1: //Sun
            addSun()
            break
        case 2: //Moon
            addMoon()
            break
        case 3: //Earth
            addEarth()
            break
        case 4: //Stars and Milky Way
            addStarAndMilkyWay()
            break
        case 5: //Mars
            addMars()
            break
        case 6: //Mercury
            addMercury()
            break
        case 7: //Neptune
            addNeptune()
            break
        case 8: //Jupiter
            addJupiter()
            break
        case 9: //Saturn
            addSaturn()
            break
        case 10: //Uranus
            addUranus()
            break
        default:
            break
        }
    }
    
    func addSun() {
        let sun = SCNNode(geometry: SCNSphere(radius: 0.05))
        sun.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "sun")
        sun.position = SCNVector3(x: 0, y: 0, z: -0.3)
        sceneView.scene.rootNode.addChildNode(sun)
    }
    
    func addMoon() {
        let moon = SCNNode(geometry: SCNSphere(radius: 0.05))
        moon.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "moon")
        moon.position = SCNVector3(x: 0, y: 0, z: -0.3)
        sceneView.scene.rootNode.addChildNode(moon)
    }
    
    func addEarth() {
        let earth = SCNNode(geometry: SCNSphere(radius: 0.05))
        earth.name = "earth"
        earth.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "earth_daymap")
        earth.position = SCNVector3(x: 0.2, y: 0, z: -0.3)
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == "earth" {
                node.removeFromParentNode()
            }
        }
        sceneView.scene.rootNode.addChildNode(earth)
        
        //to rotate the earth
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(360*Double.pi/180), z: 0, duration: 5)//rotate stops after 5 sec
        //for rotate forever
        let foreverAction = SCNAction.repeatForever(action)
        earth.runAction(foreverAction)
        
        //add specular, it shows only water is present because of earth_specular_map image
        earth.geometry?.firstMaterial?.specular.contents = #imageLiteral(resourceName: "earth_specular_map")
        
        //add cloud
        //emission :- An object that defines the color emitted by each point on a surface.
        earth.geometry?.firstMaterial?.emission.contents = #imageLiteral(resourceName: "earth_clouds")
        
        //normal :- An object that defines the nominal orientation of the surface at each point for use in lighting.
        earth.geometry?.firstMaterial?.normal.contents = #imageLiteral(resourceName: "earth_normal_map")
    }
    
    func addStarAndMilkyWay() {
        let star = SCNNode(geometry: SCNSphere(radius: 0.05))
        star.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "stars_milky_way")
        star.position = SCNVector3(x: 0, y: 0, z: -0.3)
        sceneView.scene.rootNode.addChildNode(star)
    }
    
    func addMars() {
        let mars = SCNNode(geometry: SCNSphere(radius: 0.05))
        mars.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "mars")
        mars.position = SCNVector3(x: 0, y: 0, z: -0.3)
        sceneView.scene.rootNode.addChildNode(mars)
    }
    
    func addMercury() {
        let mars = SCNNode(geometry: SCNSphere(radius: 0.05))
        mars.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "mercury")
        mars.position = SCNVector3(x: 0, y: 0, z: -0.3)
        sceneView.scene.rootNode.addChildNode(mars)
    }
    
    func addNeptune() {
        let neptune = SCNNode(geometry: SCNSphere(radius: 0.05))
        neptune.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "neptune")
        neptune.position = SCNVector3(x: 0, y: 0, z: -0.3)
        sceneView.scene.rootNode.addChildNode(neptune)
    }
    
    func addJupiter() {
        let jupiter = SCNNode(geometry: SCNSphere(radius: 0.05))
        jupiter.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "jupiter")
        jupiter.position = SCNVector3(x: 0, y: 0, z: -0.3)
        sceneView.scene.rootNode.addChildNode(jupiter)
    }
    
    func addSaturn() {
        let saturn = SCNNode(geometry: SCNSphere(radius: 0.05))
        saturn.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "saturn")
        saturn.position = SCNVector3(x: 0, y: 0, z: -0.3)
//        saturn.geometry?.firstMaterial?.emission.contents = #imageLiteral(resourceName: "saturn_ring_alpha")
        sceneView.scene.rootNode.addChildNode(saturn)
    }
    
    func addUranus() {
        let uranus = SCNNode(geometry: SCNSphere(radius: 0.05))
        uranus.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "uranus")
        uranus.position = SCNVector3(x: 0, y: 0, z: -0.3)
        sceneView.scene.rootNode.addChildNode(uranus)
    }
    
}
