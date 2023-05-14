//
//  SimulateLocationOperation.swift
//  SideStore
//
//  Created by So Young on 15/5/2023.
//  Copyright © 2023 SideStore. All rights reserved.
//

import UIKit
import Combine
import minimuxer

import AltStoreCore

@available(iOS 14, *)
protocol SimulateLocationContext
{
    var latitude: String? { get }
    var longitude: String? { get }
    var mode: Int32? { get }

    var error: Error? { get }
}

@available(iOS 14, *)
final class SimulateLocationOperation<Context: SimulateLocationContext>: ResultOperation<Void>
{
    let context: Context
    
    init(context: Context)
    {
        self.context = context
    }
    
    override func main()
    {
        super.main()
        
        if let error = self.context.error
        {
            self.finish(.failure(error))
            return
        }

        guard let lat = self.context.latitude, let lon = self.context.longitude, let mode = self.context.mode else { return self.finish(.failure(OperationError.invalidParameters)) }
        
        do {
            try set_location(lat, lon, mode)
        } catch {
            return self.finish(.failure(error))
        }
        
        self.finish(.success(()))
        
    }
}
