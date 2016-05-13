//
//  BandConnectionManager.swift
//  BandDemo
//
//  Created by Manu Rink on 13/05/16.
//  Copyright © 2016 Manu Rink. All rights reserved.
//

import Foundation


class BandConnectionManager : NSObject, MSBClientManagerDelegate {
    
    static let defaultManager = BandConnectionManager()
    
    var observers : [MSBClientManagerDelegate]!
    var connectedClient : MSBClient?
    
    private override init() {
        super.init()
        observers = [MSBClientManagerDelegate]()
        watchForBands()
    }
    
    func watchForBands () {
        MSBClientManager.sharedManager().delegate = self
        
        let attachedClients = MSBClientManager.sharedManager().attachedClients()
        if let client = attachedClients.first {
            self.connectedClient = client as! MSBClient
            MSBClientManager.sharedManager().connectClient(self.connectedClient)
        }
    }
    
    func registerForEvents(observer: MSBClientManagerDelegate) -> MSBClient? {
        observers.append(observer)
        
        if let client = connectedClient {
            return client
        }
        
        return nil
    }
    
    func clientManager(clientManager: MSBClientManager!, clientDidConnect client: MSBClient!) {
        for observer in observers {
            observer.clientManager(clientManager, clientDidConnect: client)
        }
    }
    
    func clientManager(clientManager: MSBClientManager!, clientDidDisconnect client: MSBClient!) {
        for observer in observers {
            observer.clientManager(clientManager, clientDidDisconnect: client)
        }
    }
    
    func clientManager(clientManager: MSBClientManager!, client: MSBClient!, didFailToConnectWithError error: NSError!) {
        for observer in observers {
            observer.clientManager(clientManager, client: client, didFailToConnectWithError: error)
        }
    }
    

}