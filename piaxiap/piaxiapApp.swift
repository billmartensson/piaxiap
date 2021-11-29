//
//  piaxiapApp.swift
//  piaxiap
//
//  Created by Bill Martensson on 2021-11-29.
//

import SwiftUI
import StoreKit

@main
struct piaxiapApp: App {
    
    @StateObject var storemanager = StoreManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView(storeManager: storemanager)
                .onAppear(perform: {
                    
                    SKPaymentQueue.default().add(storemanager)
                    
                    var theproducts = ["fancycredit", "fancypremium"]
                    storemanager.getProducts(productIDs: theproducts)
                })
        }
    }
}
