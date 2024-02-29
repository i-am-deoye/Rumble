//
//  File.swift
//  
//
//  Created by 13402598 on 29/02/2024.
//

//
//  File.swift
//
//
//  Created by 13402598 on 21/02/2024.
//

import Foundation
import LocalAuthentication



public class BiometricID {
    public typealias CanEvaluateResult = (success:Bool, type:BiometricType, error:BiometricError?)
    public typealias EvaluateResult = (success:Bool, error:BiometricError?)
    
    private let context = LAContext()
    private let policy: LAPolicy
    private let localizedReason: String
    
    private var error: NSError!
    
    public init(policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics,
         localizedReason: String = "Verify you Identify",
         localizeFallbackTitle: String = "Enter App Password",
         localizeCancelTitle: String = "Cancel") {
        self.policy = policy
        self.localizedReason = localizedReason
        self.context.localizedCancelTitle = localizeCancelTitle
        self.context.localizedFallbackTitle = localizeFallbackTitle
    }
    
    
    public func canEvaluate() async throws -> CanEvaluateResult {
        guard context.canEvaluatePolicy(policy, error: &error) else {
            let type = biometricType(for: context.biometryType)
            
            guard let error = error else {
                return (false, type, nil)
            }
            
            return (false, type, biometricError(from: error))
        }
        
        return (true, biometricType(for: context.biometryType), nil)
    }
    
    public func evaluate() async throws -> EvaluateResult {
        do {
            let success = try await context.evaluatePolicy(policy, localizedReason: localizedReason)
            return (success, nil)
        } catch {
            return (false, self.biometricError(from: error as NSError))
        }
    }
}


public extension BiometricID {
    enum BiometricType {
        case none
        case touchID
        case faceID
        case opticID
        case unknown
    }
    
    
    enum BiometricError: LocalizedError {
        case authenticationFailed
        case userCancel
        case userFallback
        case biometryNotAvailable
        case biometryNotEnrolled
        case biometryLockout
        case unknown
        public var errorDescription: String? {
            switch self {
            case .authenticationFailed: return "There was a problem verifying your identity."
            case .userCancel: return "You pressed cancel."
            case .userFallback: return "You pressed password."
            case .biometryNotAvailable: return "Face ID/Touch ID is not available."
            case .biometryNotEnrolled: return "Face ID/Touch ID is not set up."
            case .biometryLockout: return "Face ID/Touch ID is locked."
            case .unknown: return "Face ID/Touch ID may not be configured"
            }
        }
    }
}




extension BiometricID {
    private func biometricType(for type: LABiometryType) -> BiometricType {
        switch type {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        case .opticID:
            return .opticID
        @unknown default:
            return .unknown
        }
    }

    private func biometricError(from nsError: NSError) -> BiometricError {
        let error: BiometricError
        
        switch nsError {
        case LAError.authenticationFailed:
            error = .authenticationFailed
        case LAError.userCancel:
            error = .userCancel
        case LAError.userFallback:
            error = .userFallback
        case LAError.biometryNotAvailable:
            error = .biometryNotAvailable
        case LAError.biometryNotEnrolled:
            error = .biometryNotEnrolled
        case LAError.biometryLockout:
            error = .biometryLockout
        default:
            error = .unknown
        }
        
        return error
    }
}

