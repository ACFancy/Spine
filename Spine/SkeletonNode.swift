//
//  SkeletonNode.swift
//  Spine
//
//  Created by Max Gribov on 06/02/2018.
//  Copyright © 2018 Max Gribov. All rights reserved.
//

import SpriteKit

class SkeletonNode: SKNode {
    
    let model: SkeletonModel
    
    init(_ model: SpineModel) {

        self.model = model.skeleton
        super.init()
        self.createBones(model.bones)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createBones(_ bones: [BoneModel]?)  {
        
        if let bones = bones {
        
            let boneNodes: [BoneNode] = bones.map { BoneNode($0) }
            
            for boneNode in boneNodes {
                
                if let parentNode = boneNodes.filter( { $0.name == boneNode.model.parent }).first {
                    
                    parentNode.addChild(boneNode)

                } else {
                    
                    self.addChild(boneNode)
                }
            }
        }
    }
}
