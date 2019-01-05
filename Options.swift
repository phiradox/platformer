//
//  Options.swift
//  Platformer
//
//  Created by Ariston Kalpaxis on 8/4/17.
//  Copyright © 2017 Ariston Kalpaxis. All rights reserved.
//

import Foundation
import os.log

class Options: NSObject, NSCoding {
    
    @objc static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    @objc static let ArchiveURL = DocumentsDirectory.appendingPathComponent("options")
    
    struct PropertyKey {
        static let cloudsBool = "cloudsBool"
        static let cloudBlurBool = "cloudBlurBool"
        static let cloudBlurIntensity = "cloudBlurIntensity"
        static let shadowsBool = "shadowsBool"
        static let shadowBlurBool = "shadowBlurBool"
        static let shadowBlurIntensity = "shadowBlurIntensity"
        static let ambienceBool = "ambienceBool"
        static let ambienceBlurBool = "ambienceBlurBool"
        static let ambienceBlurIntensity = "ambienceBlurIntensity"
        static let ambienceParticleCount = "ambienceParticleCount"
    }
    
    @objc static var cloudsBool = UnsafeMutablePointer<Bool>.allocate(capacity: 1)
    @objc static var cloudBlurBool = UnsafeMutablePointer<Bool>.allocate(capacity: 1)
    @objc static var cloudBlurIntensity = UnsafeMutablePointer<Float>.allocate(capacity: 1)
    @objc static var shadowsBool = UnsafeMutablePointer<Bool>.allocate(capacity: 1)
    @objc static var shadowBlurBool = UnsafeMutablePointer<Bool>.allocate(capacity: 1)
    @objc static var shadowBlurIntensity = UnsafeMutablePointer<Float>.allocate(capacity: 1)
    @objc static var ambienceBool = UnsafeMutablePointer<Bool>.allocate(capacity: 1)
    @objc static var ambienceBlurBool = UnsafeMutablePointer<Bool>.allocate(capacity: 1)
    @objc static var ambienceBlurIntensity = UnsafeMutablePointer<Float>.allocate(capacity: 1)
    @objc static var ambienceParticleCount = UnsafeMutablePointer<Float>.allocate(capacity: 1)
    
    @objc static func setDefaultProperties() {
        Options.cloudsBool.pointee = true
        Options.cloudBlurBool.pointee = true
        Options.cloudBlurIntensity.pointee = 30.0
        Options.shadowsBool.pointee = true
        Options.shadowBlurBool.pointee = true
        Options.shadowBlurIntensity.pointee = 10.0
        Options.ambienceBool.pointee = true
        Options.ambienceBlurBool.pointee = false
        Options.ambienceBlurIntensity.pointee = 5.0
        Options.ambienceParticleCount.pointee = 512
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(Options.cloudsBool.pointee, forKey: PropertyKey.cloudsBool)
        aCoder.encode(Options.cloudBlurBool.pointee, forKey: PropertyKey.cloudBlurBool)
        aCoder.encode(Options.cloudBlurIntensity.pointee, forKey: PropertyKey.cloudBlurIntensity)
        aCoder.encode(Options.shadowsBool.pointee, forKey: PropertyKey.shadowsBool)
        aCoder.encode(Options.shadowBlurBool.pointee, forKey: PropertyKey.shadowBlurBool)
        aCoder.encode(Options.shadowBlurIntensity.pointee, forKey: PropertyKey.shadowBlurIntensity)
        aCoder.encode(Options.ambienceBool.pointee, forKey: PropertyKey.ambienceBool)
        aCoder.encode(Options.ambienceBlurBool.pointee, forKey: PropertyKey.ambienceBlurBool)
        aCoder.encode(Options.ambienceBlurIntensity.pointee, forKey: PropertyKey.ambienceBlurIntensity)
        aCoder.encode(Options.ambienceParticleCount.pointee, forKey: PropertyKey.ambienceParticleCount)
    }
    
    override init() {
        super.init()
    }
    
    @objc init(cloudsBool: Bool, cloudBlurBool: Bool, cloudBlurIntensity: Float, shadowsBool: Bool, shadowBlurBool: Bool, shadowBlurIntensity: Float, ambienceBool: Bool, ambienceBlurBool: Bool, ambienceBlurIntensity: Float, ambienceParticleCount: Float) {
        Options.cloudsBool.pointee = cloudsBool
        Options.cloudBlurBool.pointee = cloudBlurBool
        Options.cloudBlurIntensity.pointee = cloudBlurIntensity
        Options.shadowsBool.pointee = shadowsBool
        Options.shadowBlurBool.pointee = shadowBlurBool
        Options.shadowBlurIntensity.pointee = shadowBlurIntensity
        Options.ambienceBool.pointee = ambienceBool
        Options.ambienceBlurBool.pointee = ambienceBlurBool
        Options.ambienceBlurIntensity.pointee = ambienceBlurIntensity
        Options.ambienceParticleCount.pointee = ambienceParticleCount
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let cloudsBool = aDecoder.decodeBool(forKey: PropertyKey.cloudsBool)
        let cloudBlurBool = aDecoder.decodeBool(forKey: PropertyKey.cloudBlurBool)
        let cloudBlurIntensity = aDecoder.decodeFloat(forKey: PropertyKey.cloudBlurIntensity)
        let shadowsBool = aDecoder.decodeBool(forKey: PropertyKey.shadowsBool)
        let shadowBlurBool = aDecoder.decodeBool(forKey: PropertyKey.shadowBlurBool)
        let shadowBlurIntensity = aDecoder.decodeFloat(forKey: PropertyKey.shadowBlurIntensity)
        let ambienceBool = aDecoder.decodeBool(forKey: PropertyKey.ambienceBool)
        let ambienceBlurBool = aDecoder.decodeBool(forKey: PropertyKey.ambienceBlurBool)
        let ambienceBlurIntensity = aDecoder.decodeFloat(forKey: PropertyKey.ambienceBlurIntensity)
        let ambienceParticleCount = aDecoder.decodeFloat(forKey: PropertyKey.ambienceParticleCount)
        self.init(cloudsBool: cloudsBool, cloudBlurBool: cloudBlurBool, cloudBlurIntensity: cloudBlurIntensity, shadowsBool: shadowsBool, shadowBlurBool: shadowBlurBool, shadowBlurIntensity: shadowBlurIntensity, ambienceBool: ambienceBool, ambienceBlurBool: ambienceBlurBool, ambienceBlurIntensity: ambienceBlurIntensity, ambienceParticleCount: ambienceParticleCount)
    }
    
}
