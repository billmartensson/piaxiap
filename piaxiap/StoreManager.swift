//
//  StoreManager.swift
//  piaxiap
//
//  Created by Bill Martensson on 2021-11-29.
//

import Foundation
import StoreKit

class StoreManager : NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @Published var myProducts = [SKProduct]()
    
    @Published var transactionState: SKPaymentTransactionState?
    
    // HÄMTA PRODUKTER
    
    func getProducts(productIDs: [String]) {
        print("Start requesting products ...")
        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        print("Did receive response")
            
        if !response.products.isEmpty {
            
            for fetchedProduct in response.products {
                
                print(fetchedProduct.localizedTitle)
                print(fetchedProduct.localizedDescription)
                print(fetchedProduct.price)
                print("**************")
                
                DispatchQueue.main.async {
                    self.myProducts.append(fetchedProduct)
                }
            }
            
        }
        
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        // FAIL GET PRODUCTS
    }
    
    // KÖP
    
    func purchaseProduct(product: SKProduct) {
        
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            print("User can't make payment.")
        }
            
    }
    
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch transaction.transactionState {
                case .purchasing:
                    transactionState = .purchasing
                case .purchased:
                    transactionState = .purchased
                    // GÖR KÖP KOD
                    print("KÖP OK " + transaction.payment.productIdentifier)
                    queue.finishTransaction(transaction)
                case .restored:
                    transactionState = .restored
                    // GÖR KÖP/RESTORE KOD
                    print("RESTORE OK " + transaction.payment.productIdentifier)
                    queue.finishTransaction(transaction)
                case .failed, .deferred:
                    transactionState = .failed
                    queue.finishTransaction(transaction)
                default:
                    queue.finishTransaction(transaction)
            }
        }
        
    }
    
    func restoreProducts() {
        print("Restoring products ...")
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
