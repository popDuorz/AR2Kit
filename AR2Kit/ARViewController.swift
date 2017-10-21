//
//  ViewController.swift
//  AR2Kit
//
//  Created by popduorz on 14/10/2017.
//  Copyright © 2017 popduorz. All rights reserved.
//

import UIKit
import ARKit

class ARViewController: UIViewController {

    @IBOutlet weak var sceneView : ARSCNView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //addBox()
        addEarth()
        addTapGestureToScene()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.pause()
    }
    
    func addBox(x: Float = 0, y: Float = 0, z: Float = -0.4){
    
        let scene = SCNScene(named: "art.scnassets/lowpoly_tree_sample.dae")
        let airNode = scene?.rootNode.childNode(withName: "Tree_lp_11", recursively: true)
        airNode!.position = SCNVector3(x, y, z)
        
        sceneView.scene.rootNode.addChildNode(airNode!)
    }
    
    func addEarth() {
        let earth = SCNNode()
        earth.geometry = SCNSphere(radius: 1.0)
        earth.geometry?.firstMaterial?.diffuse.contents = "art.scnassets/earth/earth-diffuse-mini.jpg"
        earth.geometry?.firstMaterial?.emission.contents = "art.scnassets/earth/earth-emission-mini.jpg"
        earth.geometry?.firstMaterial?.specular.contents = "art.scnassets/earth/earth-specular-mini.jpg"
        earth.position = SCNVector3(0.0, 0.0, -4.0)
        let rotateEarth = SCNAction.rotateBy(x: 0.0, y: 10.0, z: 0.0, duration: 5.0)
        let rotateForever = SCNAction.repeatForever(rotateEarth)
        earth.runAction(rotateForever)
        sceneView.scene.rootNode.addChildNode(earth)
    }
    
    func addTapGestureToScene(){
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ARViewController.didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func  didTap(withGestureRecognizer recognizer : UIGestureRecognizer){
        
        let tapPosition = recognizer.location(in: sceneView)
        let hitTestResult = sceneView.hitTest(tapPosition)
        
        guard let node = hitTestResult.first?.node else {
            let hitTestResultWithFeaturePoints = sceneView.hitTest(tapPosition, types: .featurePoint)
            if let hitTestResultWithFeaturePoints = hitTestResultWithFeaturePoints.first {
                let translation = hitTestResultWithFeaturePoints.worldTransform.translation
                addBox(x: translation.x, y: translation.y, z: translation.z)
            }
            return
        }
        node.removeFromParentNode()
    }
}

extension float4x4{
    var translation : float3{
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}
