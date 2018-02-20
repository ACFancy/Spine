//
//  Skeleton+Skins.swift
//  Spine
//
//  Created by Max Gribov on 20/02/2018.
//  Copyright © 2018 Max Gribov. All rights reserved.
//

import SpriteKit

public extension Skeleton {
    
    public func applySkin(named: String? = nil) {
        
        var skinsNames: Set = ["default"]
        
        if let named = named {
            
            skinsNames.insert(named)
        }
        
        guard let skins = skins?.filter({ skinsNames.contains($0.model.name) }) else {
            
            return
        }
        
        for skin in skins {
            
            guard let slotsModels = skin.model.slots else {
                
                continue
            }
            
            for slotModel in slotsModels {
                
                guard let slot = slots?.first(where: { $0.model.name == slotModel.name }),
                    let attachmentsModels = slotModel.attachments else {
                        
                        continue
                }
                
                var boundingBoxes = [BoundingBoxAttachment]()
                
                for attachmentModel in attachmentsModels {
                    
                    if let attachment = skin.attachment(attachmentModel) {
                        
                        if let region = attachment as? RegionAttachment {
                            
                            slot.addChild(region)
                            
                        } else if let boundingBox = attachment as? BoundingBoxAttachment {
                            
                            boundingBoxes.append(boundingBox)
                            
                        } else if let point = attachment as? PointAttachment {
                            
                            slot.addChild(point)
                        }
                    }
                }
                
                //TODO: if debug mode add bounding boxes as childs to slot
                
                if boundingBoxes.count > 1 {
                    
                    let physicBodies = boundingBoxes.flatMap({ $0.physicsBody })
                    let compositePhysicBody = SKPhysicsBody(bodies: physicBodies)
                    compositePhysicBody.isDynamic = false
                    slot.physicsBody = compositePhysicBody
                    
                } else {
                    
                    if let boundingBox = boundingBoxes.first {
                        
                        slot.physicsBody = boundingBox.physicsBody
                    }
                }
                
                slot.dropToDefaults()
            }
        }
    }
}
