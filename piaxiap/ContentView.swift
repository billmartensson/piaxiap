//
//  ContentView.swift
//  piaxiap
//
//  Created by Bill Martensson on 2021-11-29.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var storeManager : StoreManager
    
    var body: some View {
        VStack {
            Text("Hello, world!")
                .padding()
            
            Button(action: {
                storeManager.restoreProducts()
            }) {
                Text("Restore")
            }

            
            List(storeManager.myProducts, id: \.self) { product in
                VStack {
                    Text(product.localizedTitle).padding()
                    Text(product.localizedDescription).padding()
                    
                    Button(action: {
                        storeManager.purchaseProduct(product: product)
                    }) {
                        Text("BUY!!")
                    }.padding()
                    
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(storeManager: StoreManager())
    }
}
